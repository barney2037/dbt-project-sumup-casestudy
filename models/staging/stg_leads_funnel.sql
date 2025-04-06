-- models/staging/stg_leads_funnel.sql

with raw_leads_funnel as (
    select
        DATE,
        CURRENCY,
        COUNTRY_CODE,
        CAMPAIGN_ID,
        CAMPAIGN_NAME,
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
    from {{ source('DBT_BYUKSEL', 'LEADS_FUNNEL') }}  -- Source the raw data from raw schema
)

select
    -- Clean and uppercase the DATE column (if necessary)
    DATE as lead_date,
    
    -- Clean and uppercase CURRENCY (if necessary)
    case 
        when CURRENCY is null then 'UNKNOWN_CURRENCY' -- Default value for NULL currency
        else upper(trim(CURRENCY)) -- Clean and uppercase the currency
    end as currency,

    -- Clean and uppercase COUNTRY_CODE
    case 
        when COUNTRY_CODE is null then 'UNKNOWN_COUNTRY' -- Default value for NULL country code
        else upper(trim(COUNTRY_CODE)) -- Clean and uppercase the country code
    end as country_code,

    -- Clean and uppercase CAMPAIGN_ID
    case 
        when CAMPAIGN_ID is null then 'UNKNOWN_CAMPAIGN' -- Default value for NULL campaign ID
        else upper(trim(CAMPAIGN_ID)) -- Clean and uppercase the campaign ID
    end as campaign_id,

    -- Clean and uppercase CAMPAIGN_NAME
    case 
        when CAMPAIGN_NAME is null then 'UNKNOWN_CAMPAIGN_NAME' -- Default value for NULL campaign name
        else upper(trim(CAMPAIGN_NAME)) -- Clean and uppercase the campaign name
    end as campaign_name,

    -- Clean and uppercase PRODUCT
    case 
        when PRODUCT is null then 'UNKNOWN_PRODUCT' -- Default value for NULL product
        else upper(trim(PRODUCT)) -- Clean and uppercase the product name
    end as product,

    -- Clean and uppercase CHANNEL_3
    case 
        when CHANNEL_3 is null then 'UNKNOWN_CHANNEL_3' -- Default value for NULL channel 3
        else upper(trim(CHANNEL_3)) -- Clean and uppercase channel 3
    end as channel_3,

    -- Clean and uppercase CHANNEL_4
    case 
        when CHANNEL_4 is null then 'UNKNOWN_CHANNEL_4' -- Default value for NULL channel 4
        else upper(trim(CHANNEL_4)) -- Clean and uppercase channel 4
    end as channel_4,

    -- Clean and uppercase CHANNEL_5
    case 
        when CHANNEL_5 is null then 'UNKNOWN_CHANNEL_5' -- Default value for NULL channel 5
        else upper(trim(CHANNEL_5)) -- Clean and uppercase channel 5
    end as channel_5,

    -- Use COALESCE to replace NULL values with 0 for numeric fields
    COALESCE(TOTAL_IMPRESSIONS, 0) as total_impressions,
    COALESCE(TOTAL_CLICKS, 0) as total_clicks,
    COALESCE(TOTAL_SPEND, 0) as total_spend,
    COALESCE(TOTAL_LEADS, 0) as total_leads,
    COALESCE(TOTAL_FAKE_LEADS, 0) as total_fake_leads,
    COALESCE(TOTAL_SQLS, 0) as total_sqls,
    COALESCE(TOTAL_MEETING_DONE, 0) as total_meeting_done,
    COALESCE(TOTAL_SIGNED_LEADS, 0) as total_signed_leads,
    COALESCE(TOTAL_POS_LITE_DEALS, 0) as total_pos_lite_deals

from raw_leads_funnel
