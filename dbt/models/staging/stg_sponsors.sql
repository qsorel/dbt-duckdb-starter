with source as (

  select * from {{ ref('raw_sponsors') }}

)

, final as (

  select
    sponsor_id as sponsor_id
    , sponsor_name as sponsor_name
    , createdAt as created_at
  from source

)

select * from final
