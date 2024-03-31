What is our user repeat rate?
--> 0.79 (99/124)


_____________________________________________________________________________________________________________________________________________________



What are good indicators of a user who will likely purchase again? What about indicators of users who are likely NOT to purchase again? If you had more data, what features would you want to look into to answer this question?
--> The majority of customers that come back are in Texas and California. The customers with only one order didn't have clear distinction regionally. I also created some SQLs to see if there was difference in avg shipment cost or order total, but the numbers were pretty close. it would be interesting to ivestigate if age would play a part here, but age was not available.

sqls that I used
with 
repeat_customers as (
    select user_id, count(*) as repeated, min(created_at) as first_order, max(created_at) as last_order from stg_orders
    group by user_id
    having repeated > 1
    order by repeated desc)
select state, count(repeated) as cust_by_state, sum(repeated) as orders_by_state, min(first_order), max(last_order)
from repeat_customers
inner join stg_users on stg_users.user_id = repeat_customers.user_id
inner join stg_addresses on stg_users.address_id = stg_addresses.address_id
group by state
order by cust_by_state desc;

with one_time_purchasers as (
    select 
        user_id, count(*) as repeated, 
        avg(shipping_cost) as users_avg_shipping_cost, 
        avg(order_cost) as user_avg_order, 
        avg(timestampdiff('hours', estimated_delivery_at, delivered_at)) as user_avg_delivery_time_hours
    from stg_orders
    group by user_id
    having repeated = 1
)
select 'one_time_purchaser_row' as cohort,
    avg(users_avg_shipping_cost), avg(user_avg_order), avg(user_avg_delivery_time_hours) from one_time_purchasers
union
(with repeated_cust as (
    select 
        user_id, count(*) as repeated, 
        avg(shipping_cost) as users_avg_shipping_cost, 
        avg(order_cost) as user_avg_order, 
        avg(timestampdiff('hours', estimated_delivery_at, delivered_at)) as user_avg_delivery_time_hours
    from stg_orders
    group by user_id
    having repeated > 1
)
select 'repeated_purchaser_row' as cohort,
    avg(users_avg_shipping_cost), avg(user_avg_order), avg(user_avg_delivery_time_hours) from repeated_cust);



________________________________________________________________________________________________________________________________



Explain the product mart models you added. Why did you organize the models in the way you did?
--> I followed the instructions. I was thinking if dim users would need some personal data encryption and intermediate model, but I didn't do it. Product_dim felt simple stupid to create a copy from staging area, but maybe with some extra dimensions it would be more sensible. I didn't use any intermediate models, eventhough if I had done the marketing part, maybe intermediate model for repeated customers/one time purchasers would have been good.



___________________________________________________________________________________________________________________________________


Did you find any “bad” data as you added and ran tests on your models? How did you go about either cleaning the data in the dbt model or adjusting your assumptions/tests?
--> I didn't, but I guess if any test was to fail, I would check if it is something that can be fixed on my own (assumption was wrong) or to reach out to someone else. 

Explain how you would ensure these tests are passing regularly and how you would alert stakeholders about bad data getting through.
--> Maybe alerting me and analytics team when it hasn't passed. In my work we utilize Tableau reports to alert when there is bad data coming in and it is sent daily to us. 


______________________________________________________________________________________________________________________________________

Which products had their inventory change from week 1 to week 2? 
Pothos
Philodendron
Monstera
String of pearls
