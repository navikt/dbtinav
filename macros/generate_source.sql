---
{% macro generate_source_nav(schema_name, database_name=target.database, generate_columns=False, include_descriptions=False, table_pattern='%', exclude='', name=schema_name, table_names=None) %}

{% set sources_yaml=[] %}
{% do sources_yaml.append('version: 2') %}
{% do sources_yaml.append('') %}
{% do sources_yaml.append('sources:') %}
{% do sources_yaml.append('  - name: ' ~ name | lower) %}

{% if include_descriptions %}
    {% do sources_yaml.append('    description: ""' ) %}
{% endif %}

{% if database_name != target.database %}
{% do sources_yaml.append('    database: ' ~ database_name | lower) %}
{% endif %}

{% if schema_name != name %}
{% do sources_yaml.append('    schema: ' ~ schema_name | lower) %}
{% endif %}

{% do sources_yaml.append('    tables:') %}

{% if table_names is none %}
{% set tables=codegen.get_tables_in_schema(schema_name, database_name, table_pattern, exclude) %}
{% else %}
{% set tables = table_names %}
{% endif %}

{% for table in tables %}
    {% do sources_yaml.append('      - name: ' ~ table | lower ) %}
    {% if include_descriptions %}
        {% set description = dbt_utils.get_single_value(
            get_table_comment_sql(schema_name, table), default=none
        ) %}
        {% if description is none %}
            {% set description='Description missing.' %}
        {% endif %}
        {% do sources_yaml.append('        description: >') %}
        {% for line in description.split('\n') %}
            {% do sources_yaml.append('          ' ~ line) %}
        {% endfor %}        
        
    {% endif %}
    {% if generate_columns %}
    {% do sources_yaml.append('        columns:') %}

        {% set table_relation=api.Relation.create(
            database=database_name,
            schema=schema_name,
            identifier=table
        ) %}

        {% set columns=adapter.get_columns_in_relation(table_relation) %}

        {% set comment_columns = dbt_utils.get_query_results_as_dict(
            get_all_column_comments_sql(schema_name, table)
        ) %}

        {% set col_comments = dict(zip(comment_columns['COLUMN_NAME'], comment_columns['COMMENTS']))%}

        {% for column in columns %}
            {% do sources_yaml.append('          - &' ~ column.name | lower ) %}
            {% do sources_yaml.append('            name: ' ~ column.name | lower ) %}
            {% if include_descriptions %}
                {% set description=col_comments[column.name] %}
                {% if description is none %}
                    {% set description='Description missing.' %}
                {% endif %}
                {% do sources_yaml.append('            description: >') %}
                {% for line in description.split('\n') %}
                    {% do sources_yaml.append('              ' ~ line) %}
                {% endfor %}
            {% endif %}
        {% endfor %}
            {% do sources_yaml.append('') %}

    {% endif %}

{% endfor %}

{% if execute %}

    {% set joined = sources_yaml | join ('\n') %}
    {{ log(joined, info=True) }}
    {% do return(joined) %}

{% endif %}

{% endmacro %}

{% macro get_table_comment_sql(schema_name, table_name) %}

        select
            comments
        from all_tab_comments
        where
            owner = UPPER('{{schema_name}}')
            and table_name = UPPER('{{table_name}}')


{% endmacro %}

{% macro get_all_column_comments_sql(schema_name, table_name) %}

    SELECT 
        column_name,
        comments
    FROM dba_col_comments
    WHERE owner = UPPER('{{schema_name}}')
        and table_name = UPPER('{{table_name}}')


{% endmacro %}