-- models/marts/unified_marketing_data.sql

with unified_data as (
    -- Web Orders Data (WEB_ORDER source)
    select
        WO.WEB_DATE as activity_date,
        WO.COUNTRY_CODE as country,
        WO.CAMPAIGN_ID as campaign_id,
        NULL as product,
        'WEB_ORDER' as source,
        sum(COALESCE(WO.nb_of_orders, 0)) as total_orders,
        sum(COALESCE(WO.nb_of_poslite_items_ordered, 0)) as total_poslite_items_ordered,
        sum(COALESCE(WO.nb_of_sessions, 0)) as total_sessions,
        sum(COALESCE(WO.nb_of_signups, 0)) as total_signups,
        sum(COALESCE(WO.total_spend_eur, 0)) as total_spend_eur,
        0 as total_impressions, -- No impressions for web orders
        0 as total_clicks, -- No clicks for web orders
        0 as total_leads, -- No leads for web orders
        0 as total_fake_leads, -- No fake leads for web orders
        0 as total_sqls, -- No SQL data for web orders
        0 as total_meeting_done, -- No meetings for web orders
        0 as total_signed_leads, -- No signed leads for web orders
        0 as total_poslite_deals, -- No deals for web orders
        C.CAMPAIGN_NAME,
        C.CHANNEL_3,
        C.CHANNEL_4,
        C.CHANNEL_5
    from {{ ref('stg_web_orders') }} as WO
    left join {{ ref('stg_channels') }} as C
        on WO.CAMPAIGN_ID = C.CAMPAIGN_ID
    group by WO.WEB_DATE, WO.COUNTRY_CODE, WO.CAMPAIGN_ID, C.CAMPAIGN_NAME, C.CHANNEL_3, C.CHANNEL_4, C.CHANNEL_5

    union all

    -- Lead Funnel Data (LEAD_FUNNEL source)
    select
        LF.LEAD_DATE as activity_date,
        LF.COUNTRY_CODE as country,
        LF.CAMPAIGN_ID as campaign_id,
        LF.PRODUCT as product,
        'LEAD_FUNNEL' as source,
        0 as total_orders, -- No order data for leads
        0 as total_poslite_items_ordered, -- No POS Lite items ordered for leads
        0 as total_sessions, -- No session data for leads
        0 as total_signups, -- No signup data for leads
        sum(COALESCE(LF.total_spend, 0)) as total_spend_eur, -- Spend tracked for leads
        sum(COALESCE(LF.total_impressions, 0)) as total_impressions,
        sum(COALESCE(LF.total_clicks, 0)) as total_clicks,
        sum(COALESCE(LF.total_leads, 0)) as total_leads,
        sum(COALESCE(LF.total_fake_leads, 0)) as total_fake_leads,
        sum(COALESCE(LF.total_sqls, 0)) as total_sqls,
        sum(COALESCE(LF.total_meeting_done, 0)) as total_meeting_done,
        sum(COALESCE(LF.total_signed_leads, 0)) as total_signed_leads,
        sum(COALESCE(LF.total_pos_lite_deals, 0)) as total_poslite_deals,
        C.CAMPAIGN_NAME,
        C.CHANNEL_3,
        C.CHANNEL_4,
        C.CHANNEL_5
    from {{ ref('stg_leads_funnel') }} as LF
    left join {{ ref('stg_channels') }} as C
        on LF.CAMPAIGN_ID = C.CAMPAIGN_ID
    group by LF.LEAD_DATE, LF.COUNTRY_CODE, LF.CAMPAIGN_ID, LF.PRODUCT, C.CAMPAIGN_NAME, C.CHANNEL_3, C.CHANNEL_4, C.CHANNEL_5
)

-- Final selection of unified data for reporting
select
    activity_date,
    country,
    source,
    campaign_id,
    CAMPAIGN_NAME,
    CHANNEL_3,
    CHANNEL_4,
    CHANNEL_5
    product,
    total_orders,
    total_poslite_items_ordered,
    total_sessions,
    total_signups,
    total_spend_eur,
    total_impressions,
    total_clicks,
    total_leads,
    total_fake_leads,
    total_sqls,
    total_meeting_done,
    total_signed_leads,
    total_poslite_deals
   
from unified_data
