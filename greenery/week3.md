PART 1
What is our overall conversion rate?
-> 62.45
--> select 
    sum(case when event_type = 'checkout' then 1 else 0 end) as checkouts,
    sum(case when event_type = 'package_shipped' then 1 else 0 end) as package_shipped,
    sum(case when event_type = 'add_to_cart' then 1 else 0 end) as add_to_cart,
    sum(case when event_type = 'page_view' then 1 else 0 end) as page_views,
    count(distinct session_id) as all_sessions,
    checkouts/all_sessions*100 as conversion_rate
    from stg_events;

What is our conversion rate by product?
-> 32...60
--> with 
page_views as (
    select product_id, count(session_id) as sessions from stg_events where event_type = 'page_view' group by product_id),
purchases as 
    (select product_id, count(order_id) as orders from stg_order_items group by product_id)
select page_views.product_id, sessions, orders, orders/sessions*100 as coversion_rate_per_product
from page_views left join purchases on page_views.product_id = purchases.product_id;

Some products might convert better than other due to season or promos. It might be also, that we could have some problem with pricing with certain products.



_______________________________________________________________________________________________________________________________________________________________

PART 2
Created the same macro as in project kick-off for sum clauses. 

______________________________________________________________________________________________________

PART 3
Added posthook that applies to the whole project and a prehook to fact_product_event_totals model
_______________________________________________________________________________________________________

PART 4
dbt_utils was needed in the macro that I created

_____________________________________________________________

PART 5
The macro that I added made the sum clause easier to maintain, but I am not sure how it is visible from the model DAG illustration


_______________________________________________________________

PART 6
Philodendron
String of pearls
Bamboo
Monstera
ZZ Plant
Pothos
Pothos