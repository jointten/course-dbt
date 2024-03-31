{{
    config(
        materialized='table'
        )
}}

with order_fact as (
    select 
        stg_orders.order_id, 
        user_id, 
        order_cost, 
        shipping_cost, 
        order_total,
        object_agg(name, quantity) as order_items,
        shipping_service, 
        estimated_delivery_at, 
        delivered_at, 
        stg_orders.status as order_status,
        created_at, 
        promo_id
    from {{ref('stg_orders')}} stg_orders
    inner join {{ref('stg_order_items')}} stg_order_items on stg_order_items.order_id = stg_orders.order_id
    inner join {{ref('stg_products')}} stg_products on stg_products.product_id = stg_order_items.product_id
    group by all
)
select 
        order_fact.*, 
        discount 
from order_fact
    left join {{ref('stg_promos')}} on stg_promos.promo_id = order_fact.promo_id