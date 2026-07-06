with source as (

  select * from {{ ref('raw_trials') }}

)

, final as (

  select
    trial_id as trial_id
    , sponsor_id as sponsor_id
    , trialName as trial_name
    , indication as indication
    , phase as phase
    , status as status
    , start_date as start_date
    , end_date as end_date
  from source

)

select * from final
