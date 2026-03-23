create database customer_behavior;
select * from customer limit 20
USE customer_behavior

## Q1: What is the total revenue generated b male vs female customers?
select gender , sum(purchase_amount) as revenue
from customer
group by gender
_______________________________________________________________________
## Q2: which customers used a discount but still spent more than the avarage purches amount?
SELECT customer_id, purchase_amount
FROM customer
WHERE discount_applied = 'Yes'
AND purchase_amount >= (
    SELECT AVG(purchase_amount)
    FROM customer
);
__________________________________________________________________________________
## Q3: which are the top 5 porduct with the highest avarege review rating?
select item_purchased, AVG(review_rating) as "Avarage Product Rating"
from customer
group by item_purchased
order by avg(review_rating) desc
limit 5;
_______________________________________________________________________________________
## Q4: compare the average purchase amount between standard and express shipping.
SELECT shipping_type,
AVG(purchase_amount)
FROM customer
WHERE shipping_type IN ('Standard','Express')
GROUP BY shipping_type;
_______________________________________________________________________________________________________________________________
## Q5: do subscibed customers spend more? compare average spend and total revenue between subscribers and non-subscribers
select subscription_status,
count(customer_id) as total_customers,
round(avg(purchase_amount),2) as avg_spend,
round(sum(purchase_amount),2) as total_revenue
from customer
group by subscription_status
order by total_revenue, avg_spend desc;
__________________________________________________________________________________________________
## Q6: which 5 products have the hightest percentage of purchases with discounts applied?
SELECT item_purchased,
ROUND(SUM(CASE WHEN discount_applied = 'YES' THEN 1 ELSE 0 END) / COUNT(*), 2) AS discount_rate
FROM customer
GROUP BY item_purchased
ORDER BY discount_rate DESC
LIMIT 5;
________________________________________________________________________________________________________________________________________________
## Q7: segments coutomers into new, returning, nad loyal based on their total number of previous purchases, and show the count of each segment.
with customer_type as(
select  customer_id, previous_purchases,
case
    when previous_purchases = 1 then 'New'
    when previous_purchases between 2 and 10 then 'Returning'
    else 'Loyal'
    end as customer_segment
from customer
)
select customer_segment, count(*) as "Number of Customers"
from customer_type
group by customer_segment;
_____________________________________________________________________________________
## Q8: what are the top 3 most purchases products within each category?
WITH item_counts AS (
    SELECT 
        category,
        item_purchased,
        COUNT(customer_id) AS total_orders,
        ROW_NUMBER() OVER (
            PARTITION BY category 
            ORDER BY COUNT(customer_id) DESC
        ) AS item_rank
    FROM customer
    GROUP BY category, item_purchased
)

SELECT item_rank, category, item_purchased, total_orders
FROM item_counts
WHERE item_rank <= 3;
______________________________________________________________________________________________________________________
## Q9: are coustoners who are repeat buyers (more than 5 previous purchases) alos likely to subscribe?
select subscription_status,
count(customer_id) as repeat_buyers
from customer
where previous_purchases > 5
group by subscription_status;
___________________________________________________________________________________________________________________________
## Q10: what is the revenue contribition of each age group?
select age_group,
sum(purchase_amount) as total_revenue
from customer
group by age_group
order by total_revenue desc;
