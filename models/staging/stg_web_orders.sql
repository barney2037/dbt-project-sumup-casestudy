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
    -- Dates
    DATE as WEB_DATE,

    -- Textual metadata cleaned and uppercased
    COALESCE(UPPER(TRIM(COUNTRY_CODE)), 'UNKNOWN_COUNTRY') as COUNTRY_CODE,
    COALESCE(
        UPPER(TRIM(REGEXP_REPLACE(CAMPAIGN_ID, '\.\d+$', ''))),
        'UNKNOWN_CAMPAIGN'
    ) as CAMPAIGN_ID,

    -- Numeric metrics with COALESCE and casting
    COALESCE(TOTAL_SPEND_EUR, 0)::FLOAT as TOTAL_SPEND_EUR,
    COALESCE(NB_OF_SESSIONS, 0)::INT as NB_OF_SESSIONS,

    -- Handle NB_OF_SIGNUPS: If 'f' or empty, treat as 0
    case
        when NB_OF_SIGNUPS = 'f' then 0
        when NB_OF_SIGNUPS = '' then 0
        else TRY_CAST(NB_OF_SIGNUPS AS INT)
    end as NB_OF_SIGNUPS,

    COALESCE(NB_OF_ORDERS, 0)::INT as NB_OF_ORDERS,
    COALESCE(NB_OF_POSLITE_ITEMS_ORDERED, 0)::INT as NB_OF_POSLITE_ITEMS_ORDERED,
    COALESCE(NB_POSLITE_ITEMS_DISPATCHED, 0)::INT as NB_POSLITE_ITEMS_DISPATCHED

from raw_web_orders
