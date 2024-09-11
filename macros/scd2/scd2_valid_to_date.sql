{% macro scd2_valid_to_date(
        unique_key,
        date_column
    ) -%}
    COALESCE(LEAD({{ date_column }}) OVER (PARTITION BY {{ unique_key }}
ORDER BY
    {{ date_column }} ASC) - 1, to_date('9999-12-31', 'YYYY-MM-DD'))
{%- endmacro %}
