-- models/staging/stg_leads_funnel.sql


WITH raw_leads_funnel AS (
    SELECT
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
    FROM {{ source('DBT_BYUKSEL', 'LEADS_FUNNEL') }}  -- Source the raw data from raw schema
)

SELECT
    DATE AS lead_date,
    COUNTRY_CODE AS country,
    CAMPAIGN_ID AS campaign_id,
    CAMPAIGN_NAME AS campaign_name,
    CURRENCY AS currency,
    PRODUCT AS product,
    CHANNEL_3 AS channel_3,
    CHANNEL_4 AS channel_4,
    CHANNEL_5 AS channel_5,
    TOTAL_IMPRESSIONS AS impressions,
    TOTAL_CLICKS AS clicks,
    TOTAL_SPEND AS spend,
    TOTAL_LEADS AS leads,
    TOTAL_FAKE_LEADS AS fake_leads,
    TOTAL_SQLS AS sqls,
    TOTAL_MEETING_DONE AS meetings_done,
    TOTAL_SIGNED_LEADS AS signed_leads,
    TOTAL_POS_LITE_DEALS AS pos_lite_deals
FROM raw_leads_funnel;
