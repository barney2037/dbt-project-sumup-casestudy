-- models/marts/mkt_web_performance.sql


WITH web_orders AS (
    SELECT
        order_date AS order_date,
        country,
        CAMPAIGN_ID,
        spend_eur AS total_spend,
        sessions AS nb_sessions,
        signups AS nb_signups,
        orders AS nb_orders,
        poslite_items_ordered AS nb_poslite_items_ordered,
        poslite_items_dispatched AS nb_poslite_items_dispatched
    FROM {{ ref('stg_web_orders') }}  -- Referring to the staging table 'stg_web_orders' (it should be materialized as a model)
),
channels AS (
    SELECT
        CAMPAIGN_ID,
        CHANNEL_3,
        CHANNEL_4,
        CHANNEL_5
    FROM {{ ref('stg_channels') }}  -- Referring to the staging table 'stg_channels'
)

-- Final query that joins web orders with channel data
SELECT
    wo.order_date,
    wo.country,
    ch.channel_3,
    ch.channel_4,
    ch.channel_5,
    wo.total_spend,
    wo.nb_sessions,
    wo.nb_signups,
    wo.nb_orders,
    wo.nb_poslite_items_ordered,
    wo.nb_poslite_items_dispatched
FROM web_orders wo
LEFT JOIN channels ch
    ON wo.campaign_id = ch.campaign_id  -- Joining the two staging tables
