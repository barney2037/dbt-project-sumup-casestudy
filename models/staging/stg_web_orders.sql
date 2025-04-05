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
    from {{ source('raw', 'web_orders') }}  -- Source the raw data from raw schema
)

select
    DATE as order_date,
    COUNTRY_CODE as country,
    CAMPAIGN_ID as campaign_id,
    TOTAL_SPEND_EUR as spend_eur,
    NB_OF_SESSIONS as sessions,
    NB_OF_SIGNUPS as signups,
    NB_OF_ORDERS as orders,
    NB_OF_POSLITE_ITEMS_ORDERED as poslite_items_ordered,
    NB_POSLITE_ITEMS_DISPATCHED as poslite_items_dispatched
from raw_web_orders
