-- models/staging/stg_channels.sql

with raw_channels as (
    select
        CAMPAIGN_ID,
        CAMPAIGN_NAME,
        CAMPAIGN_PERIOD_BUDGET_CATEGORY,
        CHANNEL_3,
        CHANNEL_4,
        CHANNEL_5
    from {{ source('DBT_BYUKSEL', 'CHANNELS') }}
)

select
    -- Textual metadata cleaned and uppercased
    COALESCE(
        UPPER(TRIM(REGEXP_REPLACE(CAMPAIGN_ID, '\.\d+$', ''))),
        'UNKNOWN_CAMPAIGN'
    ) as CAMPAIGN_ID,
    
    COALESCE(UPPER(TRIM(CAMPAIGN_NAME)), 'UNKNOWN_CAMPAIGN_NAME') as CAMPAIGN_NAME,
    COALESCE(UPPER(TRIM(CAMPAIGN_PERIOD_BUDGET_CATEGORY)), 'UNKNOWN') as CAMPAIGN_PERIOD_BUDGET_CATEGORY,
    COALESCE(UPPER(TRIM(CHANNEL_3)), 'UNKNOWN_CHANNEL_3') as CHANNEL_3,
    COALESCE(UPPER(TRIM(CHANNEL_4)), 'UNKNOWN_CHANNEL_4') as CHANNEL_4,
    COALESCE(UPPER(TRIM(CHANNEL_5)), 'UNKNOWN_CHANNEL_5') as CHANNEL_5

from raw_channels
