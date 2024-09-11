with

src_dummydata as (
    select
    pk
  , lk
  , tekst
  , dato
from
    {{ source('dbtinav','dummydata') }}
)

, final as ( 
      select
    pk
  , lk
  , tekst
  , dato
from
    src_dummydata
)

select * from final