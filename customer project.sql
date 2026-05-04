create database customer;

USE customer;

select*from customer limit 10;

select*from customer where Age>50;

# what is the total revenue genereated by male vs female customer?

SELECT gender, SUM(`Purchase Amount (USD)`) AS revenue
FROM customer
GROUP BY gender;

#Q2 which customer used a discount but still spent more than the average purchase amount

SELECT `Customer ID`, `Purchase Amount (USD)`
FROM customer
WHERE `Discount Applied` = 'Yes'
  AND `Purchase Amount (USD)` >= (
      SELECT AVG(`Purchase Amount (USD)`)
      FROM customer
  );

#Q3 which are the top 5 products with the higest avereage review rating?

SELECT `Item Purchased`, ROUND(AVG(`Review Rating`), 2) AS `Average Product Rating`
FROM customer
GROUP BY `Item Purchased`
ORDER BY AVG(`Review Rating`) DESC
LIMIT 5;

# Q4 compare the avereage purchase Amount between standard and Express Shipping

SELECT `Shipping Type`, ROUND(AVG(`Purchase Amount (USD)`), 2) AS avg_purchase
FROM customer
WHERE `Shipping Type` IN ('Standard', 'Express')
GROUP BY `Shipping Type`;

#Q5 Do subscribed customer spend more ? compare average spend and total revenue
# brtween subscriber and non subscriber

SELECT `Subscription Status`,
       COUNT(`Customer ID`) AS total_customers,
       ROUND(AVG(`Purchase Amount (USD)`), 2) AS avg_spend,
       ROUND(SUM(`Purchase Amount (USD)`), 2) AS total_revenue
FROM customer
GROUP BY `Subscription Status`
ORDER BY total_revenue DESC, avg_spend DESC;

#Q6 WHICH 5 PRODUCT HAVE THE HIGEST PERCENTAGE OF PURCHASE WITH DISCOUNTS APPLIED

SELECT `Item Purchased`,
       ROUND(100 * SUM(CASE WHEN `Discount Applied` = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS discount_rate
FROM customer
GROUP BY `Item Purchased`
ORDER BY discount_rate DESC
LIMIT 5;

#-- Q7. Segment customers into New, Returning, and Loyal based on their total
-- number of previous purchases, and show the count of each segment.

WITH customer_type AS (
    SELECT `Customer ID`, `Previous Purchases`,
           CASE
               WHEN `Previous Purchases` = 1 THEN 'New'
               WHEN `Previous Purchases` BETWEEN 2 AND 10 THEN 'Returning'
               ELSE 'Loyal'
           END AS customer_segment
    FROM customer
)
SELECT customer_segment, COUNT(*) AS `Number of Customers`
FROM customer_type
GROUP BY customer_segment;

#8 what are the top 3 most purchased products within each category:
WITH item_counts AS (
    SELECT `Category`,
           `Item Purchased`,
           COUNT(`Customer ID`) AS total_orders,
           ROW_NUMBER() OVER (
               PARTITION BY `Category`
               ORDER BY COUNT(`Customer ID`) DESC
           ) AS item_rank
    FROM customer
    GROUP BY `Category`, `Item Purchased`
)
SELECT item_rank, `Category`, `Item Purchased`, total_orders
FROM item_counts
WHERE item_rank <= 3;

-- Q9. Are customers who are repeat buyers (more than 5 previous purchases) also likely to subscribe?

SELECT `Subscription Status`,
       COUNT(`Customer ID`) AS repeat_buyers
FROM customer
WHERE `Previous Purchases` > 5
GROUP BY `Subscription Status`;

#10 what is the revenue contributionn of each age group
create view Age_Group as
SELECT  CASE
           WHEN Age BETWEEN 18 AND 25 THEN 'Young-Age'
           WHEN Age BETWEEN 26 AND 35 THEN 'Middle-Age'
           WHEN Age BETWEEN 36 AND 50 THEN 'Adult'
           ELSE 'Senior'
       END AS age_group,
       SUM(`Purchase Amount (USD)`) AS total_revenue
FROM customer
GROUP BY age_group
ORDER BY total_revenue DESC;

select * from Age_group;


select * from customer limit 20;






