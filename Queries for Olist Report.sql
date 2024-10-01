-- First query
WITH unique_orders AS (
    SELECT 
        od.order_id, 
        cd.customer_id,
        cd.customer_state, 
        DATE(EXTRACT(YEAR FROM od.order_purchase_timestamp), EXTRACT(MONTH FROM od.order_purchase_timestamp), 1) AS year_month
    FROM 
        olist_db.olist_orders_dataset od
    JOIN 
        olist_db.olist_customesr_dataset cd 
        ON od.customer_id = cd.customer_id
),
-- Aggregate payments to avoid duplicates
aggregated_payments AS (
    SELECT 
        opd.order_id,
        STRING_AGG(opd.payment_type, ', ') AS payment_types,  -- Concatenating payment types for multiple payments
        SUM(opd.payment_value) AS total_payment_value  -- Aggregating payment values
    FROM 
        olist_db.olist_order_payments_dataset opd
    GROUP BY opd.order_id
)
-- Final query to join the aggregated data
SELECT 
    uo.year_month,
    ap.payment_types,  -- Using concatenated payment types
    SUM(ap.total_payment_value) AS total_value,  -- Aggregated payment value
    COUNT(DISTINCT uo.customer_id) AS customer_count,  -- Counting unique customers
    COUNT(DISTINCT uo.order_id) AS order_count,  -- Counting unique orders
    AVG(ap.total_payment_value) AS avg_order_value,  -- Average payment per order
    CASE 
        WHEN uo.customer_state IN ('AC', 'AP', 'AM', 'PA', 'RO', 'RR', 'TO') THEN 'North'
        WHEN uo.customer_state IN ('AL', 'BA', 'CE', 'MA', 'PB', 'PE', 'PI', 'RN', 'SE') THEN 'Northeast'
        WHEN uo.customer_state IN ('DF', 'GO', 'MT', 'MS') THEN 'Central-West'
        WHEN uo.customer_state IN ('ES', 'MG', 'RJ', 'SP') THEN 'Southeast'
        WHEN uo.customer_state IN ('PR', 'RS', 'SC') THEN 'South'
        ELSE 'Other'
    END AS customer_region
FROM 
    unique_orders uo
JOIN 
    aggregated_payments ap ON uo.order_id = ap.order_id  -- Joining aggregated payment data
GROUP BY 1, 2, 7  -- Grouping by year_month, payment_types, and customer_region
ORDER BY 1, 7;
-- Second Query
SELECT
	DATE(EXTRACT(YEAR FROM od.order_purchase_timestamp), EXTRACT(MONTH FROM od.order_purchase_timestamp), 1) AS year_month,
    pcnt.string_field_1 AS category_name,  -- Category name
    pd.product_id,  -- Product ID to differentiate between products rather than category_name, which sums up product by category
    Count(oid.order_item_id) AS total_units_sold,  -- Product volume (units sold)
    AVG(oid.price) AS avg_price_per_unit,  -- Average price per unit (could help with profit analysis)
    SUM(oid.price) as total_price
FROM 
    `olist_db.olist_orders_dataset` od
JOIN 
    `olist_db.olist_order_payments_dataset` opd
    ON opd.order_id = od.order_id
JOIN 
    `olist_db.olist_order_items_dataset` oid
    ON od.order_id = oid.order_id
JOIN 
    `olist_db.olist_products_dataset` pd
    ON oid.product_id = pd.product_id
JOIN 
    `olist_db.product_category_name_translation` pcnt
    ON pd.product_category_name = pcnt.string_field_0
GROUP BY 
     1, pd.product_id, category_name --Group by year_month,product_id, category_name
ORDER BY 
    total_price DESC;  -- Sort by highest revenue
-- Third Query
-- Aggregate payments to avoid duplicates
WITH aggregated_payments AS (
    SELECT
        opd.order_id,
        SUM(opd.payment_value) AS total_payment_value
    FROM
        `olist_db.olist_order_payments_dataset` opd
    GROUP BY opd.order_id
)
--Focus on Sellers and the revenue they've made
SELECT 
    DATE(EXTRACT(YEAR FROM od.order_purchase_timestamp), EXTRACT(MONTH FROM od.order_purchase_timestamp), 1) AS year_month,
    uo.order_id, 
    oid.seller_id,
    uo.total_payment_value,
    CASE 
        WHEN osd.seller_state IN ('AC', 'AP', 'AM', 'PA', 'RO', 'RR', 'TO') THEN 'North'
        WHEN osd.seller_state IN ('AL', 'BA', 'CE', 'MA', 'PB', 'PE', 'PI', 'RN', 'SE') THEN 'Northeast'
        WHEN osd.seller_state IN ('DF', 'GO', 'MT', 'MS') THEN 'Central-West'
        WHEN osd.seller_state IN ('ES', 'MG', 'RJ', 'SP') THEN 'Southeast'
        WHEN osd.seller_state IN ('PR', 'RS', 'SC') THEN 'South'
        ELSE 'Other'
    END AS seller_region
FROM 
    aggregated_payments uo  -- Using pre-aggregated payments to avoid duplicates
JOIN 
    `olist_db.olist_orders_dataset` od ON uo.order_id = od.order_id
JOIN 
    `olist_db.olist_order_items_dataset` oid ON od.order_id = oid.order_id
JOIN 
    `olist_db.olist_sellers_dataset` osd ON oid.seller_id = osd.seller_id
GROUP BY 
    year_month, uo.order_id, oid.seller_id, uo.total_payment_value, osd.seller_state
ORDER BY 
    year_month;
--Fourth Query
-- CTE for seller revenue
WITH seller_revenue AS (
    SELECT 
        oid.seller_id, 
        SUM(opd.payment_value) AS total_revenue
    FROM 
        `olist_db.olist_order_payments_dataset` opd
    JOIN 
        `olist_db.olist_order_items_dataset` oid ON opd.order_id = oid.order_id
    JOIN 
        `olist_db.olist_orders_dataset` od ON oid.order_id = od.order_id
    GROUP BY 
        oid.seller_id
),
--CTE for Total revenue to build a percentage column in the final query
total_revenue AS (
    SELECT 
        SUM(total_revenue) AS total_market_revenue
    FROM 
        seller_revenue
),
-- Ranking sellers by revenue
ranked_sellers AS (
    SELECT 
        sr.seller_id,
        sr.total_revenue,
        RANK() OVER (ORDER BY sr.total_revenue DESC) AS revenue_rank,
        SUM(sr.total_revenue) OVER (ORDER BY sr.total_revenue DESC) AS cumulative_revenue,
        tr.total_market_revenue
    FROM 
        seller_revenue sr
    CROSS JOIN 
        total_revenue tr
)
-- Final SELECT with Cumulative, Total and Percentage revenues
SELECT 
    rs.seller_id,
    rs.total_revenue,
    rs.revenue_rank,
    (rs.total_revenue / rs.total_market_revenue) AS percentage_of_total_revenue,
    rs.cumulative_revenue
FROM 
    ranked_sellers rs
ORDER BY 
    rs.revenue_rank;
-Fifth Query
-- Finding the revenue of each seller
WITH seller_revenue AS (
    SELECT 
        oid.seller_id, 
        SUM(opd.payment_value) AS total_revenue
    FROM 
        `olist_db.olist_order_payments_dataset` opd
    JOIN 
        `olist_db.olist_order_items_dataset` oid ON opd.order_id = oid.order_id
    GROUP BY 
        oid.seller_id
),
-- Cutting out the lead digits
leading_digits AS (
    SELECT 
        seller_id, 
        total_revenue,
        CAST(LEFT(CAST(total_revenue AS STRING), 1) AS INT64) AS leading_digit
    FROM 
        seller_revenue
),
--Counting out the lead digits
benford_distribution AS (
    SELECT 
        leading_digit, 
        COUNT(leading_digit) AS occurrences,
        RANK() OVER (ORDER BY COUNT(leading_digit) DESC) AS rank
    FROM 
        leading_digits
    GROUP BY 
        leading_digit
)
--Last select to find the occurrences for each leading digits and then calculating the percentage total
SELECT 
    leading_digit,
    occurrences,
    occurrences / SUM(occurrences) OVER () AS percentage_of_total
FROM 
    benford_distribution
ORDER BY 
    leading_digit;
--Sixth and Last Query
WITH shipping_groups AS (
    SELECT 
        CASE 
            WHEN TIMESTAMP_DIFF(od.order_estimated_delivery_date, od.order_delivered_customer_date, DAY) > 0 THEN 'Group B - Faster Shipping'
            ELSE 'Group A - Standard Shipping'
        END AS shipping_group,
        ord.review_score, 
        od.order_id,
        ROW_NUMBER() OVER (PARTITION BY 
            CASE 
                WHEN TIMESTAMP_DIFF(od.order_estimated_delivery_date, od.order_delivered_customer_date, DAY) > 0 THEN 'Group B - Faster Shipping'
                ELSE 'Group A - Standard Shipping'
            END ORDER BY RAND()) AS row_num  -- Assigning random row numbers per group, this way every output would be random for both groups
    FROM 
        `olist_db.olist_orders_dataset` od
    JOIN 
        `olist_db.olist_order_reviews_dataset` ord 
        ON od.order_id = ord.order_id
)
, balanced_groups AS (
    -- Limiting both groups to 11,000 rows
    SELECT * 
    FROM shipping_groups
    WHERE (shipping_group = 'Group A - Standard Shipping' AND row_num <= 11000)
       OR (shipping_group = 'Group B - Faster Shipping' AND row_num <= 11000)
)

, stats_by_group AS (
    SELECT 
        shipping_group,
        AVG(review_score) AS avg_review_score,
        COUNT(order_id) AS total_orders,
        SUM(CASE WHEN review_score >= 4 THEN 1 ELSE 0 END) AS positive_reviews,  -- Counting of positive reviews with a score >= 4 as positive reviews
        ROUND(SUM(CASE WHEN review_score >= 4 THEN 1 ELSE 0 END) / COUNT(order_id), 4) AS conversion_rate,  -- Conversion rate (proportion of positive reviews)
        STDDEV(review_score) AS stddev_review_score,  -- Standard Deviation
        VAR_POP(review_score) AS var_review_score    -- Variance (Population Variance)
    FROM balanced_groups
    GROUP BY shipping_group
)

-- Computed pooled variance, standard error, degrees of freedom, and t-statistic
SELECT 
    sg.shipping_group,
    sg.avg_review_score,
    sg.total_orders,
    sg.positive_reviews,
    sg.conversion_rate,
    sg.stddev_review_score,
    sg.var_review_score,
    -- Pooled Variance calculation
    (SELECT 
        ((a.total_orders - 1) * a.var_review_score + (b.total_orders - 1) * b.var_review_score)
        / (a.total_orders + b.total_orders - 2)
     FROM stats_by_group a, stats_by_group b
     WHERE a.shipping_group = 'Group A - Standard Shipping'
       AND b.shipping_group = 'Group B - Faster Shipping'
    ) AS pooled_variance,
    -- Degrees of Freedom
    (SELECT 
        (a.total_orders + b.total_orders - 2)
     FROM stats_by_group a, stats_by_group b
     WHERE a.shipping_group = 'Group A - Standard Shipping'
       AND b.shipping_group = 'Group B - Faster Shipping'
    ) AS degrees_of_freedom,
    -- Pooled Standard Deviation
    (SELECT 
        SQRT(
            ((a.total_orders - 1) * a.var_review_score + (b.total_orders - 1) * b.var_review_score)
            / (a.total_orders + b.total_orders - 2)
        )
     FROM stats_by_group a, stats_by_group b
     WHERE a.shipping_group = 'Group A - Standard Shipping'
       AND b.shipping_group = 'Group B - Faster Shipping'
    ) AS pooled_stddev,
    -- Standard Error
    (SELECT 
        SQRT(
            (a.var_review_score / a.total_orders) + (b.var_review_score / b.total_orders)
        )
     FROM stats_by_group a, stats_by_group b
     WHERE a.shipping_group = 'Group A - Standard Shipping'
       AND b.shipping_group = 'Group B - Faster Shipping'
    ) AS standard_error,
    -- t-statistic for the difference in means
    (SELECT 
        (a.avg_review_score - b.avg_review_score) / 
        SQRT(
            (a.var_review_score / a.total_orders) + (b.var_review_score / b.total_orders)
        )
     FROM stats_by_group a, stats_by_group b
     WHERE a.shipping_group = 'Group A - Standard Shipping'
       AND b.shipping_group = 'Group B - Faster Shipping'
    ) AS t_statistic
FROM 
    stats_by_group sg
ORDER BY 
    sg.shipping_group;

