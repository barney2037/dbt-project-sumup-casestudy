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
    from {{ source('DBT_BYUKSEL', 'WEB_ORDERS') }}  -- Source the raw data from raw schema
)

select
    -- Clean and uppercase the DATE column
    DATE as WEB_DATE,

    -- Clean and uppercase COUNTRY_CODE
    case 
        when COUNTRY_CODE is null then 'UNKNOWN_COUNTRY' -- Default value for NULL country code
        else upper(trim(COUNTRY_CODE)) -- Clean and uppercase the country code
    end as COUNTRY_CODE,

    -- Clean and uppercase CAMPAIGN_ID
    case 
        when CAMPAIGN_ID is null then 'UNKNOWN_CAMPAIGN' -- Default value for NULL campaign ID
        else upper(trim(CAMPAIGN_ID)) -- Clean and uppercase the campaign ID
    end as CAMPAIGN_ID,

    -- Use COALESCE to replace NULL values with 0 for numeric fields
    COALESCE(TOTAL_SPEND_EUR, 0) as total_spend_eur,
    COALESCE(NB_OF_SESSIONS, 0) as nb_of_sessions,
    COALESCE(NB_OF_SIGNUPS, 0) as nb_of_signups,
    COALESCE(NB_OF_ORDERS, 0) as nb_of_orders,
    COALESCE(NB_OF_POSLITE_ITEMS_ORDERED, 0) as nb_of_poslite_items_ordered,
    COALESCE(NB_POSLITE_ITEMS_DISPATCHED, 0) as nb_poslite_items_dispatched

from raw_web_orders
