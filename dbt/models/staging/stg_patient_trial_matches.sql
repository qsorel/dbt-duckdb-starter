with source as (

  select * from {{ ref('raw_patient_trial_matches') }}

)

, final as (

  select
    patient_id
    , trial_id
    , substr(site_id, length(site_id) - 6) as site_id
    , processedAt as processed_at
    , reviewedAt as reviewed_at
    , enrolledAt as enrolled_at
  from source

)

select * from final
