-- models/staging/stg_web_orders.sql

with raw_web_orders as (
    select
        DATE,
        COUNTRY_CODE,
        CAMPAIGN_ID,
        TOTAL_SPEND_EUR,
        NB_OF_SESSIONS,
        NB_OF_SIGNUPS,
        NB_OF_ORDERS,
        NB_OF_POSLITE_ITEMS_ORDERED,
        NB_POSLITE_ITEMS_DISPATCHED
    from {{ source('DBT_BYUKSEL', 'WEB_ORDERS') }}
)

select
    -- Clean and alias DATE
    DATE as WEB_DATE,

    -- Clean and uppercase COUNTRY_CODE
    case 
        when COUNTRY_CODE is null then 'UNKNOWN_COUNTRY'
        else upper(trim(COUNTRY_CODE))
    end as COUNTRY_CODE,

    -- Clean and uppercase CAMPAIGN_ID
    case 
        when CAMPAIGN_ID is null then 'UNKNOWN_CAMPAIGN'
        else upper(trim(CAMPAIGN_ID))
    end as CAMPAIGN_ID,

    -- Numeric metrics with COALESCE and casting
    COALESCE(TOTAL_SPEND_EUR, 0)::FLOAT as TOTAL_SPEND_EUR,
    COALESCE(NB_OF_SESSIONS, 0)::INT as NB_OF_SESSIONS,
-- Handle NB_OF_SIGNUPS: If 'f', replace with 0 (or NULL)
    case
        when NB_OF_SIGNUPS = 'f' then 0  -- Replace 'f' with 0 (or NULL if preferred)
        when NB_OF_SIGNUPS = '' then 0  -- Replace empty strings with 0
        else TRY_CAST(NB_OF_SIGNUPS AS INT)  -- Convert to integer if valid
    end as NB_OF_SIGNUPS,    COALESCE(NB_OF_ORDERS, 0)::INT as NB_OF_ORDERS,
    COALESCE(NB_OF_POSLITE_ITEMS_ORDERED, 0)::INT as NB_OF_POSLITE_ITEMS_ORDERED,
    COALESCE(NB_POSLITE_ITEMS_DISPATCHED, 0)::INT as NB_POSLITE_ITEMS_DISPATCHED

from raw_web_orders
