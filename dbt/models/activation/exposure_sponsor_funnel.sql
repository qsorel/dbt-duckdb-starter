with matches as (

  select * from {{ ref('fct_patient_trial_matches') }}

)

, trials as (

  select * from {{ ref('dim_trials') }}

)

, sites as (

  select * from {{ ref('dim_sites') }}

)

, sponsors as (

  select * from {{ ref('dim_sponsors') }}

)

, joined as (

  select
    matches.patient_id
    , matches.trial_id
    , matches.site_id
    , matches.is_processed
    , matches.is_reviewed
    , matches.is_enrolled
    , matches.days_from_processed_to_reviewed
    , matches.days_from_reviewed_to_enrolled
    , matches.days_from_processed_to_enrolled
    , trials.sponsor_id
    , trials.trial_name
    , trials.indication
    , trials.phase
    , trials.status
    , sites.site_name
    , sites.country_code
    , sites.country_name
    , sponsors.sponsor_name
  from matches
  left join trials
    on matches.trial_id = trials.trial_id
  left join sites
    on matches.site_id = sites.site_id
  left join sponsors
    on trials.sponsor_id = sponsors.sponsor_id

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
    , count(*) as total_matches
    , sum(case when is_processed then 1 else 0 end) as processed_count
    , sum(case when is_reviewed then 1 else 0 end) as reviewed_count
    , sum(case when is_enrolled then 1 else 0 end) as enrolled_count
    , cast(sum(case when is_reviewed then 1 else 0 end) as double) / nullif(sum(case when is_processed then 1 else 0 end), 0) as processed_to_reviewed_conversion_rate
    , cast(sum(case when is_enrolled then 1 else 0 end) as double) / nullif(sum(case when is_reviewed then 1 else 0 end), 0) as reviewed_to_enrolled_conversion_rate
    , cast(sum(case when is_enrolled then 1 else 0 end) as double) / nullif(sum(case when is_processed then 1 else 0 end), 0) as processed_to_enrolled_conversion_rate
    , avg(days_from_processed_to_reviewed) as avg_days_processed_to_reviewed
    , avg(days_from_reviewed_to_enrolled) as avg_days_reviewed_to_enrolled
    , avg(days_from_processed_to_enrolled) as avg_days_processed_to_enrolled
  from joined
  group by
    sponsor_id
    , sponsor_name
    , trial_id
    , trial_name
    , site_id
    , site_name
    , country_code
    , country_name

)

select * from final
