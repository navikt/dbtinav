{{
  config(
    pre_hook="{% if is_incremental() %}DELETE FROM {{ this }} WHERE GYLDIG_TIL_DATO > CURRENT_DATE{% endif %};",
    materialized='incremental',
    unique_key='pk',
    incremental_strategy='append',
  )
}}

WITH scd2_squash AS (
    SELECT * FROM {{ scd2_squash_delta(ref('stg_dummydata'), 'lk', 'dato', ['tekst']) }}
)

, final as (
    select
        pk
        , lk
        , tekst
        , gyldig_fra_dato
        , gyldig_til_dato
    from scd2_squash
    
)

SELECT * FROM final
