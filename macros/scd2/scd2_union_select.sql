{% macro scd2_union_select(
        table,
        unique_key = 'fk_person1',
        from_date = 'gyldig_fra_dato'
    ) -%}

 SELECT
    {{ unique_key }}
    , {{ from_date }}
FROM
    {{ table }} 

{%- endmacro %}
