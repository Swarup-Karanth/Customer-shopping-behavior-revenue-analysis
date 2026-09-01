select *
from customer_shopping_data;

select gender ,sum(purchase_amount) as revenue
from customer_shopping_data
group by gender;

select customer_id,purchase_amount
from customer_shopping_data
where discount_applied='yes' and purchase_amount>=(select avg(purchase_amount)
from customer_shopping_data);

select item_purchased,round(avg(review_rating),2) as "average purchase rating"
from customer_shopping_data
group by item_purchased
order by avg(review_rating) desc
limit 5;

select shipping_type,round(avg(purchase_amount),2)
from customer_shopping_data
where shipping_type in ('Standard','Express')
group by shipping_type
;
select subscription_status,count(customer_id) as total_customer,round(avg(purchase_amount),2) as average_spent,round(sum(purchase_amount),2) as total_revenue
from customer_shopping_data
group by subscription_status
order by total_revenue ,average_spent desc;

select item_purchased,round(sum(case when discount_applied='yes' then 1 else 0 end)/count(*)*100,2) as discount_rate
from customer_shopping_data
group by item_purchased
order by discount_rate desc
limit 5;

with customer as (
select customer_id,previous_purchases,
case
 when previous_purchases = 1 then 'new' 
 when previous_purchases between 2 and 10 then 'returning'
 else 'loyal'
 end as customer_segment
from customer_shopping_data
)
select customer_segment , count(*) as "number of customer"
from customer
group by customer_segment;

with item_count as (
select category,item_purchased,count(customer_id) as total_orders,
row_number() over(partition by category order by  count(customer_id) desc) as item_rank
from customer_shopping_data
group by category,item_purchased)
select item_rank , category,item_purchased,total_orders
from item_count
where item_rank<=3;

select subscription_status,count(customer_id) as repeat_buyers
from customer_shopping_data
where previous_purchases>5
group by subscription_status;

select age_group,sum(purchase_amount) as total_revenue
from customer_shopping_data
group by age_group
order by total_revenue desc;