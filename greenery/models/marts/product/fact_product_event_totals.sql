{{
config(
    materialized='view'
    ,prehook = 'use warehouse sigma_corise_wh'

)
}}
select 
    count(distinct session_id) as all_sessions
    {{event_types('stg_events', 'event_type')}}
    ,checkout/all_sessions*100 as conversion_rate
    from {{ref('stg_events')}}