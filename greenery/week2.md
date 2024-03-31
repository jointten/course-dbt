How many users do we have?
-> select count(distinct user_id) from stg_users
--> 130 unique user ids

On average, how many orders do we receive per hour?
-> select avg(cnt) from(
    select date_part(hour, created_at) as hod,
    count(order_id) as cnt from stg_orders
    group by hod);
--> 15

On average, how long does an order take from being placed to being delivered?
-> select avg(timestampdiff('days', created_at,delivered_at)) from  stg_orders;
--> On average the created_at and delivered-at have 3.89 days difference

How many users have only made one purchase? Two purchases? Three+ purchases?
->with order_per_cust as (
select user_id, count(distinct order_id) as order_cnt from stg_orders
group by user_id)
select 
    order_cnt,
    count(user_id) from order_per_cust
    group by 1;

--> 1 order --> 25 
--> 2 orders --> 28
--> 3+ --> 71 

On average, how many unique sessions do we have per hour?
-> select avg(cnt) from(
select date_part(hour, created_at) as hod,
count(distinct session_id) as cnt from stg_events
group by hod);
--> 39.5
