-- models/staging/stg_channels.sql

with raw_channels as (
    select
        CAMPAIGN_ID,
        CAMPAIGN_NAME,
        CAMPAIGN_PERIOD_BUDGET_CATEGORY,
        CHANNEL_3,
        CHANNEL_4,
        CHANNEL_5
    from {{ source('DBT_BYUKSEL', 'CHANNELS') }}  -- Source the raw data from raw schema
)

select
    -- Ensure campaign_id is not NULL, clean, and standardized to uppercase
    case 
        when CAMPAIGN_ID is null then 'UNKNOWN_CAMPAIGN' -- Default value for NULL IDs
        else upper(trim(CAMPAIGN_ID)) -- Clean and uppercase the campaign ID
    end as campaign_id,
    
    -- Clean, trim, and standardize the campaign name to uppercase
    case 
        when CAMPAIGN_NAME is null then 'UNKNOWN_CAMPAIGN_NAME' -- Default value for NULL names
        else upper(trim(CAMPAIGN_NAME)) -- Clean and uppercase the campaign name
    end as CAMPAIGN_NAME,

    -- Clean the campaign period/budget category and handle NULLs, then uppercase
    case 
        when CAMPAIGN_PERIOD_BUDGET_CATEGORY is null then 'UNKNOWN' -- Default value
        else upper(trim(CAMPAIGN_PERIOD_BUDGET_CATEGORY)) -- Clean and uppercase the budget category
    end as CAMPAIGN_PERIOD_BUDGET_CATEGORY,

    -- Clean, trim, and standardize the channel details to uppercase
    case 
        when CHANNEL_3 is null then 'UNKNOWN_CHANNEL_3' -- Default value
        else upper(trim(CHANNEL_3)) -- Clean and uppercase channel 3
    end as channCHANNEL_3el_3,

    case 
        when CHANNEL_4 is null then 'UNKNOWN_CHANNEL_4' -- Default value
        else upper(trim(CHANNEL_4)) -- Clean and uppercase channel 4
    end as CHANNEL_4,

    case 
        when CHANNEL_5 is null then 'UNKNOWN_CHANNEL_5' -- Default value
        else upper(trim(CHANNEL_5)) -- Clean and uppercase channel 5
    end as CHANNEL_5

from raw_channels
