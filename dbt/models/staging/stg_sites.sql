with source as (

  select * from {{ ref('raw_sites') }}

)

, final as (

  select
    site_id as site_id
    , siteName as site_name
    , countryCode as country_code
    , country_name as country_name
  from source

)

select * from final
