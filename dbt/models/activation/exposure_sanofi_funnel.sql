with funnel as (

  select * from {{ ref('exposure_sponsor_funnel') }}

)

, final as (

  select
    sponsor_id
    , sponsor_name
    , trial_id
    , trial_name
    , site_id
    , site_name
    , country_code
    , country_name
    , total_matches
    , processed_count
    , reviewed_count
    , enrolled_count
    , processed_to_reviewed_conversion_rate
    , reviewed_to_enrolled_conversion_rate
    , processed_to_enrolled_conversion_rate
    , avg_days_processed_to_reviewed
    , avg_days_reviewed_to_enrolled
    , avg_days_processed_to_enrolled
  from funnel
  where sponsor_name = 'Sanofi'

)

select * from final
