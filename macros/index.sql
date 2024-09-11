{% macro create_index_if_not_exists(index_name, table_name, column_name, is_unique=False) %}
  {%- set check_index_exists_query -%}
    SELECT COUNT(*) 
    FROM all_indexes 
    WHERE index_name = UPPER('{{ index_name }}') 
    AND table_name = UPPER('{{ table_name }}')
  {%- endset -%}
  {% if execute %}
    {%- set index_exists = run_query(check_index_exists_query).columns[0][0] -%}
    {% if index_exists == 0 %}
      {%- set create_index_query -%}
        {% if is_unique %}
          CREATE UNIQUE INDEX {{ index_name }} ON {{ table_name }} ({{ column_name }})
        {% else %}
          CREATE INDEX {{ index_name }} ON {{ table_name }} ({{ column_name }})
        {% endif %}
      {%- endset -%}
      {{ create_index_query.strip() }}
    {% else %}
      {{ '' }}
    {% endif %}
  {% endif %}
{% endmacro %}