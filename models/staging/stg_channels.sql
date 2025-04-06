-- models/staging/stg_channels.sql

with raw_channels as (
    select
        CAMPAIGN_ID,
        CCAMPAIGN_NAME,
        CAMPAIGN_PERIOD_BUDGET_CATEGORY,
        CHANNEL_3,
        CHANNEL_4,
        CHANNEL_5
    from {{ source('DBT_BYUKSEL', 'CHANNELS') }}  -- Source the raw data from raw schema
)

select
    CAMPAIGN_ID as campaign_id,
    CCAMPAIGN_NAME as campaign_name,
    CAMPAIGN_PERIOD_BUDGET_CATEGORY as budget_category,
    CHANNEL_3 as channel_3,
    CHANNEL_4 as channel_4,
    CHANNEL_5 as channel_5
from raw_channels
