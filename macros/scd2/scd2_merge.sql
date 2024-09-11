{% macro scd2_merge(
        unique_key = 'fk_person1',
        from_date = 'gyldig_fra_dato',
        stg_dicts = [],
        CTE = True
    ) -%}
    {% set table_columns_list = [] %}
    {% set union_queries = [] %}
    {% set join_queries = [] %}
    {% set scd2_table = 'scd2' %}
    {% for stg_dict in stg_dicts %}
        {% set union_query = scd2_union_select(stg_dict.table) %}
        {% set join_query = scd2_join(stg_dict.table) %}
        {% do union_queries.append(union_query) %}
        {% do join_queries.append(join_query) %}
        {% for column in stg_dict.columns %}
            {% set table_column = stg_dict.table ~ '.' ~ column %}
            {% do table_columns_list.append(table_column) %}
        {% endfor %}
    {% endfor %}



{% if not CTE %}
SELECT * FROM
{% endif %}

(SELECT
    scd2.{{ unique_key }},
    {{ table_columns_list | join(',') }},
    scd2.{{ from_date }} as gyldig_fra_dato,
    scd2.gyldig_til_dato

FROM (
    SELECT
        en_rad_per_dag.*,
        {{ scd2_valid_to_date(unique_key, from_date) }} AS gyldig_til_dato
    FROM (
        SELECT 
            * 
        FROM ( {{ union_queries | join('\nUNION ALL ') }} ) GROUP BY {{ unique_key }}, {{ from_date }} ) en_rad_per_dag
    ) scd2

{{ join_queries | join('\n ') }}

ORDER BY {{ unique_key }}, {{ from_date }}
)
{%- endmacro %}
