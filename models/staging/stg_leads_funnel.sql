-- models/staging/stg_leads_funnel.sql

with raw_leads_funnel as (
    select
        DATE,
        COUNTRY_CODE,
        CAMPAIGN_ID,
        CAMPAIGN_NAME,
        CURRENCY,
        PRODUCT,
        CHANNEL_3,
        CHANNEL_4,
        CHANNEL_5,
        TOTAL_IMPRESSIONS,
        TOTAL_CLICKS,
        TOTAL_SPEND,
        TOTAL_LEADS,
        TOTAL_FAKE_LEADS,
        TOTAL_SQLS,
        TOTAL_MEETING_DONE,
        TOTAL_SIGNED_LEADS,
        TOTAL_POS_LITE_DEALS
    from {{ source('raw', 'leads_funnel') }}  -- Source the raw data from raw schema
)

select
    DATE as lead_date,
    COUNTRY_CODE as country,
    CAMPAIGN_ID as campaign_id,
    CAMPAIGN_NAME as campaign_name,
    CURRENCY as currency,
    PRODUCT as product,
    CHANNEL_3 as channel_3,
    CHANNEL_4 as channel_4,
    CHANNEL_5 as channel_5,
    TOTAL_IMPRESSIONS as impressions,
    TOTAL_CLICKS as clicks,
    TOTAL_SPEND as spend,
    TOTAL_LEADS as leads,
    TOTAL_FAKE_LEADS as fake_leads,
    TOTAL_SQLS as sqls,
    TOTAL_MEETING_DONE as meetings_done,
    TOTAL_SIGNED_LEADS as signed_leads,
    TOTAL_POS_LITE_DEALS as pos_lite_deals
from raw_leads_funnel
