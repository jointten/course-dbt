-- Calculate the overall average views over all available history
{{
    config(
        materialized='view'
    )
}}

with daily_views as 
(
    SELECT
        product_id, 
        DATE(created_at) AS date,
        AVG(COUNT(*)) OVER (PARTITION BY product_id, DATE(created_at) ORDER BY DATE(created_at)) AS avg
    FROM {{ ref('stg_events')}}
    WHERE event_type = 'page_view'
    GROUP BY product_id, date 
),
daily_orders as 
(
    select  
       stg_order_items.product_id, 
       DATE(created_at) AS date,
       AVG(SUM(quantity)) OVER (PARTITION BY stg_order_items.product_id, DATE(created_at) ORDER BY DATE(created_at)) AS avg
    from {{ ref('stg_events')}} stg_events
    inner join {{ref('stg_order_items')}} stg_order_items on stg_order_items.order_id = stg_events.order_id
    where event_type = 'checkout'
    group by stg_order_items.product_id, date
),
daily_added_to_carts as 
(
    SELECT 
       product_id, 
       DATE(created_at) AS date,
       AVG(COUNT(*)) OVER (PARTITION BY product_id, DATE(created_at) ORDER BY DATE(created_at)) AS avg
    FROM {{ ref('stg_events')}} stg_events
    WHERE event_type in ('add_to_cart')
    GROUP BY product_id, date
)
SELECT 
    name as product_name, 
    daily_views.date,
   daily_views.avg as viewed,
   daily_added_to_carts.avg as added_to_cart,
   daily_orders.avg as ordered
FROM stg_products
inner join daily_views on daily_views.product_id = stg_products.product_id 
inner join daily_orders on daily_orders.product_id = stg_products.product_id and daily_orders.date = daily_views.date
inner join daily_added_to_carts on daily_added_to_carts.product_id = stg_products.product_id and daily_added_to_carts.date = daily_views.date