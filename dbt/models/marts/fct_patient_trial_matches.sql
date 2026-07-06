with matches as (

  select * from {{ ref('stg_patient_trial_matches') }}

)

, final as (

  select
    patient_id
    , trial_id
    , site_id
    , processed_at
    , reviewed_at
    , enrolled_at
    , case when processed_at is not null then true else false end as is_processed
    , case when reviewed_at is not null then true else false end as is_reviewed
    , case when enrolled_at is not null then true else false end as is_enrolled
    , case
        when processed_at is not null and reviewed_at is not null then datediff('day', processed_at, reviewed_at)
      end as days_from_processed_to_reviewed
    , case
        when reviewed_at is not null and enrolled_at is not null then datediff('day', reviewed_at, enrolled_at)
      end as days_from_reviewed_to_enrolled
    , case
        when processed_at is not null and enrolled_at is not null then datediff('day', processed_at, enrolled_at)
      end as days_from_processed_to_enrolled
  from matches

)

select * from final
