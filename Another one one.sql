--For the region with the largest sales total_amt_usd, how many total orders were placed?
WITH t1 as (SELECT r.name as region_name, MAX(o.total_amt_usd) as total_amt, COUNT(o.occurred_at) as total_ord
            FROM region r
            JOIN sales_reps sr
            ON r.id = sr.region_id
            JOIN accounts a
            ON sr.id = a.sales_rep_id
            JOIN orders o
            ON a.id = o.account_id
            GROUP BY 1)
            
SELECT t1.region_name, t1.total_ord
FROM t1
ORDER BY 2 DESC