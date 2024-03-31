{{
    config(
    materialized='table'
    )
}}

select 
    product_id, 
    name, 
    price as current_price, 
    inventory 
from {{ref('stg_products')}}
