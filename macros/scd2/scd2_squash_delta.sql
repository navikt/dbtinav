{% macro scd2_squash_delta(table, unique_key, valid_from_column, hash_columns) -%}

{% set table_columns_list = dbt_utils.get_filtered_columns_in_relation(from=table, except=[valid_from_column]) %}


(SELECT 
    {{ table_columns_list | join('\n    , ')}}
    , {{ valid_from_column }} AS gyldig_fra_dato
    , {{ scd2_valid_to_date(unique_key, valid_from_column) }} AS gyldig_til_dato
    FROM (
    SELECT *
        FROM (
            SELECT
                source.*
                ,{{ dbt_utils.generate_surrogate_key(hash_columns)}} as hashed_columns
                ,coalesce(
                    lag({{ dbt_utils.generate_surrogate_key(hash_columns)}}) over (partition by {{ unique_key }} order by {{ valid_from_column }} asc)
                    , {{ dbt.hash("'RAD1'") }})
                as hashed_columns_prev
            FROM {{ table }} source
            {% if is_incremental() %}
            where valid_from_column > (select max(valid_from_column) from  {{ this }})
            {% endif %}
            )
    WHERE hashed_columns != hashed_columns_prev
    )
)


{%- endmacro %}
