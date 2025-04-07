-- models/marts/marketing_data_extended.sql

with marketing_data as (
    select
        WO.WEB_DATE as activity_date,
        WO.COUNTRY_CODE as country,
        WO.CAMPAIGN_ID as campaign_id,
        'WEB_ORDER' as source,
        sum(COALESCE(WO.nb_of_orders, 0)) as total_orders,
        sum(COALESCE(WO.nb_of_poslite_items_ordered, 0)) as total_poslite_items_ordered,
        sum(COALESCE(WO.nb_of_sessions, 0)) as total_sessions,
        sum(COALESCE(WO.nb_of_signups, 0)) as total_signups,
        sum(COALESCE(WO.total_spend_eur, 0)) as total_spend_eur
    from {{ ref('stg_web_orders') }} as WO
    group by WO.WEB_DATE, WO.COUNTRY_CODE, WO.CAMPAIGN_ID
)

-- Join with campaign details from stg_channels
select
    MD.activity_date,
    MD.country,
    MD.campaign_id,
    C.CHANNEL_3,
    C.CAMPAIGN_NAME,
    C.CHANNEL_4,
    C.CHANNEL_5,
    MD.source,
    MD.total_orders,
    MD.total_poslite_items_ordered,
    MD.total_sessions,
    MD.total_signups,
    MD.total_spend_eur
    
from marketing_data MD
left join {{ ref('stg_channels') }} C
    on MD.campaign_id = C.CAMPAIGN_ID
