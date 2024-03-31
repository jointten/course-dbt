{{
    config(
        materialized='table'
    )
}}

select 
    user_id, 
    first_name, 
    last_name, 
    email, 
    phone_number, 
    address, 
    zipcode, 
    state, 
    country 
from {{ref('stg_users')}} stg_users
inner join {{ref('stg_addresses')}} stg_addresses on stg_users.address_id = stg_addresses.address_id