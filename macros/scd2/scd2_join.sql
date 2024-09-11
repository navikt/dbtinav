{% macro scd2_join(
        table,
        unique_key = 'fk_person1'
    ) -%}

 LEFT JOIN {{table}}
    ON {{ table }}.{{ unique_key }} = scd2.{{ unique_key }}
    AND scd2.gyldig_fra_dato BETWEEN {{ table }}.gyldig_fra_dato
    AND {{ table }}.gyldig_til_dato

{%- endmacro %}
