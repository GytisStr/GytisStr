WITH sales AS (
    SELECT 
        COUNT(DISTINCT location_id) AS location_count,
        promotion,
        SUM(sales_in_thousands) AS sum_sales, 
        AVG(sales_in_thousands) AS avg_sales, 
        STDDEV(sales_in_thousands) AS stddev_sales,
        VARIANCE(sales_in_thousands) as variance_sales,
        AVG(age_of_store) AS avg_age
    FROM 
       (
        SELECT 
            location_id, 
            promotion,
            SUM(sales_in_thousands) AS sales_in_thousands,
            AVG(age_of_store) AS age_of_store
        FROM 
            `tc-da-1.turing_data_analytics.wa_marketing_campaign`
        GROUP BY 
            location_id, 
            promotion
    ) AS check_for_quadruplicates
    GROUP BY 
        promotion
    ORDER BY 
        promotion
),
comparison AS (
    SELECT 
        a.avg_sales AS avg_sales_1,
        a.stddev_sales AS stddev_sales_1,
        a.location_count AS num_stores_1,
        a.variance_sales as variance_sales_1,
        b.avg_sales AS avg_sales_2,
        b.stddev_sales AS stddev_sales_2,
        b.location_count AS num_stores_2,
        b.variance_sales as variance_sales_2,
    FROM
        sales a
    JOIN 
        sales b
    ON 
        a.promotion = 1 AND b.promotion = 2
), 
comparison_w_pooled_variance as (
    SELECT *,
    ((num_stores_1 - 1 ) * variance_sales_1 + (num_stores_2 - 1 ) * variance_sales_2) / (num_stores_1 + num_stores_2 - 2) as pooled_variance,
    num_stores_1 + num_stores_2 - 2 as df
    FROM comparison )
SELECT 
    avg_sales_1,
    stddev_sales_1,
    num_stores_1,
    variance_sales_1,
    variance_sales_2,
    avg_sales_2,
    stddev_sales_2,
    num_stores_2,
    pooled_variance,
    (avg_sales_1 - avg_sales_2) / SQRT(pooled_variance * (1 / num_stores_1 + 1 / num_stores_2)) AS t_statistic
FROM 
    comparison_w_pooled_variance;
