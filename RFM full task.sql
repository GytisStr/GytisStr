WITH 
Freq_Mon AS (
    SELECT  
    CustomerID,
    Country,
    CAST(MAX(InvoiceDate) AS DATE) AS last_purchase_date,
    COUNT(DISTINCT InvoiceNo) AS frequency,
    SUM(UnitPrice * Quantity) AS monetary 
    FROM `turing_data_analytics.rfm`
    WHERE InvoiceDate BETWEEN '2010-12-01' AND '2011-12-01' AND CustomerID IS NOT NULL AND Description IS NOT NULL
    GROUP BY CustomerID, Country 
),

--Compute for R
Receny AS (
    SELECT *,
    DATE_DIFF(reference_date, last_purchase_date, DAY) AS recency
    FROM (
        SELECT  *,
        MAX(last_purchase_date) OVER () + 1 AS reference_date
        FROM Freq_mon
    )  
),

--Determine quintiles for RFM
Quant AS (
SELECT 
    a.*,
    b.percentiles[offset(25)] AS m25, 
    b.percentiles[offset(50)] AS m50,
    b.percentiles[offset(75)] AS m75, 
    b.percentiles[offset(100)] AS m100,
    c.percentiles[offset(25)] AS f25, 
    c.percentiles[offset(50)] AS f50,
    c.percentiles[offset(75)] AS f75, 
    c.percentiles[offset(100)] AS f100,
    d.percentiles[offset(25)] AS r25, 
    d.percentiles[offset(50)] AS r50,
    d.percentiles[offset(75)] AS r75, 
    d.percentiles[offset(100)] AS r100
FROM 
    Receny a,
    (SELECT APPROX_QUANTILES(monetary, 100) percentiles FROM
    Receny) b,
    (SELECT APPROX_QUANTILES(frequency, 100) percentiles FROM
    Receny) c,
    (SELECT APPROX_QUANTILES(recency, 100) percentiles FROM
    Receny) d
),

--Assigning scores for R, F & M
Full_RFM AS (
    SELECT *,
    FROM (
        SELECT *, 
        CASE WHEN monetary <= m25 THEN 1
            WHEN monetary <= m50 AND monetary > m25 THEN 2 
            WHEN monetary <= m75 AND monetary > m50 THEN 3 
            WHEN monetary <= m100 AND monetary > m75 THEN 4
        END AS m_score,
        CASE WHEN frequency <= f25 THEN 1
            WHEN frequency <= f50 AND frequency > f25 THEN 2 
            WHEN frequency <= f75 AND frequency > f50 THEN 3 
            WHEN frequency <= f100 AND frequency > f75 THEN 4
        END AS f_score,
        --Recency scoring is reversed
        CASE WHEN recency <= r25 THEN 4
            WHEN recency <= r50 AND recency > r25 THEN 3 
            WHEN recency <= r75 AND recency > r50 THEN 2 
            WHEN recency <= r100 AND recency > r75 THEN 1
        END AS r_score,
        FROM Quant
        )
),

--Define RFM segments
Def_RFM AS (
    SELECT 
        CustomerID, 
        Country,
        recency,
        frequency, 
        monetary,
        r_score,
        f_score,
        m_score,
        (r_score * 100) + (f_score * 10) + m_score AS rfm_score,
        CASE 
    WHEN r_score = 4 AND f_score = 4 AND m_score = 4 THEN 'Champions'

    WHEN (r_score = 3 AND f_score = 4 AND m_score IN (1, 2, 3, 4)) 
         OR (r_score = 4 AND f_score = 4 AND m_score IN (2, 3, 4)) 
         OR (r_score = 4 AND f_score = 3 AND m_score IN (3, 4)) 
         OR (r_score = 3 AND f_score = 3 AND m_score IN (3, 4)) THEN 'Loyal Customers'

    WHEN (r_score = 4 AND f_score = 4 AND m_score IN (1, 2, 3)) 
         OR (r_score = 4 AND f_score = 3 AND m_score IN (1, 2 )) 
         OR (r_score = 4 AND f_score = 2 AND m_score IN (1, 2, 3, 4))
         OR (r_score = 3 AND f_score = 4 AND m_score IN (2 ))
         OR (r_score = 3 AND f_score = 3 AND m_score IN (1, 2, 3))
         OR (r_score = 2 AND f_score = 4 AND m_score IN (1, 2, 3, 4)) THEN 'Potential Loyalists'

    WHEN r_score = 4 AND f_score = 1 AND m_score IN (1, 2, 3, 4) THEN 'Recent Customers'

    WHEN r_score = 3 AND f_score = 1 AND m_score IN (1, 2, 3, 4)
         OR (r_score = 3 AND f_score = 2 AND m_score IN (1, 2, 3, 4))
         OR (r_score = 3 AND f_score = 3 AND m_score IN (1, 2, 3, 4)) THEN 'Promising'

    WHEN r_score = 2 AND f_score = 2 AND m_score IN (1, 2, 3, 4)
         OR r_score = 2 AND f_score = 3 AND m_score IN (1, 2, 3, 4) THEN 'Customers Needing Attention'

    WHEN r_score = 2 AND f_score = 1 AND m_score IN (1, 2, 3, 4) THEN 'About to Sleep'

    WHEN r_score = 1 AND f_score = 4 AND m_score IN (1, 2, 3, 4)
         OR r_score = 1 AND f_score = 3 AND m_score IN (1, 2, 3, 4)
         OR r_score = 1 AND f_score = 2 AND m_score = 2 THEN 'At Risk'

    WHEN r_score = 1 AND f_score = 1 AND m_score IN (2, 3, 4)
         OR (r_score = 1 AND f_score = 2 AND m_score IN (1, 3, 4)) THEN 'Cant Lose Them'

    WHEN r_score = 1 AND f_score = 1 AND m_score = 1 THEN 'Lost'

    ELSE 'Other'
END AS rfm_segment 
    FROM Full_RFM
)

SELECT * FROM Def_RFM 