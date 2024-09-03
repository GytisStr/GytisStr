--Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales.
WITH acc_reg_sales AS (SELECT r.name as region_name, sr.name as sales_rep_name, AVG(o.total_amt_usd) as total_avg
                       FROM region r
                       JOIN sales_reps sr
                       ON r.id = sr.region_id
                       JOIN accounts a
                       ON sr.id = a.sales_rep_id
                       JOIN orders o
                       ON a.id = o.account_id
                       GROUP BY 1,2
                       ORDER BY 3 DESC),
      MAXout AS       (SELECT acc_reg_sales.region_name, MAX(acc_reg_sales.total_avg) as total_avg
                        FROM acc_reg_sales
                        GROUP BY 1)
                       
                       
SELECT acc_reg_sales.region_name, acc_reg_sales.sales_rep_name, acc_reg_sales.total_avg
FROM acc_reg_sales
JOIN MAXout
ON acc_reg_sales.region_name = MAXout.region_name AND acc_reg_sales.total_avg = MAXout.total_avg