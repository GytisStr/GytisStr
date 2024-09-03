WITH
  weekly_cohorts AS (
  SELECT
    user_pseudo_id,
    DATE_TRUNC(DATE(TIMESTAMP_MICROS(MIN(event_timestamp))), WEEK) AS reg_date,
  FROM
    `turing_data_analytics.raw_events`
  WHERE DATE_TRUNC(DATE(TIMESTAMP_MICROS(event_timestamp)), WEEK) <= '2021-01-24'
  GROUP BY
    1), --CTE establisheses the first day any user used our website as the registration date, filtering the "current" week
  weekly_revenue AS (
  SELECT
    re.user_pseudo_id,
    DATE_TRUNC(DATE(TIMESTAMP_MICROS(event_timestamp)), WEEK) AS p_date,
    purchase_revenue_in_usd AS p_revenue --CTE checks for any user purchases and truncates the event date to the week as purchase week
  FROM
    `turing_data_analytics.raw_events` re
)
SELECT
  wc.reg_date, 
  SUM(CASE
      WHEN wr.p_date = wc.reg_date THEN (wr.p_revenue)
  END
    ) / COUNT(DISTINCT wc.user_pseudo_id) AS week_0,
  SUM(CASE
      WHEN wr.p_date = TIMESTAMP_ADD(wc.reg_date, INTERVAL 7 DAY) THEN (wr.p_revenue) 
  END
    ) / COUNT(DISTINCT wc.user_pseudo_id) AS week_1, --Calculates the purchase revenue for the interval of 7 day i.e. a week and divides it by the ammount of users to find the avg. revenue per user for that week.
  SUM(CASE
      WHEN wr.p_date = TIMESTAMP_ADD(wc.reg_date, INTERVAL 14 DAY) THEN (wr.p_revenue)
  END
    ) / COUNT(DISTINCT wc.user_pseudo_id) AS week_2,
  SUM(CASE
      WHEN wr.p_date = TIMESTAMP_ADD(wc.reg_date, INTERVAL 21 DAY) THEN (wr.p_revenue)
  END
    ) / COUNT(DISTINCT wc.user_pseudo_id) AS week_3,
  SUM(CASE
      WHEN wr.p_date = TIMESTAMP_ADD(wc.reg_date, INTERVAL 28 DAY) THEN (wr.p_revenue)
  END
    ) / COUNT(DISTINCT wc.user_pseudo_id) AS week_4,
  SUM(CASE
      WHEN wr.p_date = TIMESTAMP_ADD(wc.reg_date, INTERVAL 35 DAY) THEN (wr.p_revenue)
  END
    ) / COUNT(DISTINCT wc.user_pseudo_id) AS week_5,
  SUM(CASE
      WHEN wr.p_date = TIMESTAMP_ADD(wc.reg_date, INTERVAL 42 DAY) THEN (wr.p_revenue)
  END
    ) / COUNT(DISTINCT wc.user_pseudo_id) AS week_6,
  SUM(CASE
      WHEN wr.p_date = TIMESTAMP_ADD(wc.reg_date, INTERVAL 49 DAY) THEN (wr.p_revenue)
  END
    ) / COUNT(DISTINCT wc.user_pseudo_id) AS week_7,
  SUM(CASE
      WHEN wr.p_date = TIMESTAMP_ADD(wc.reg_date, INTERVAL 56 DAY) THEN (wr.p_revenue)
  END
    ) / COUNT(DISTINCT wc.user_pseudo_id) AS week_8,
  SUM(CASE
      WHEN wr.p_date = TIMESTAMP_ADD(wc.reg_date, INTERVAL 63 DAY) THEN (wr.p_revenue)
  END
    ) / COUNT(DISTINCT wc.user_pseudo_id) AS week_9,
  SUM(CASE
      WHEN wr.p_date = TIMESTAMP_ADD(wc.reg_date, INTERVAL 70 DAY) THEN (wr.p_revenue)
  END
    ) / COUNT(DISTINCT wc.user_pseudo_id) AS week_10,
  SUM(CASE
      WHEN wr.p_date = TIMESTAMP_ADD(wc.reg_date, INTERVAL 77 DAY) THEN (wr.p_revenue)
  END
    ) / COUNT(DISTINCT wc.user_pseudo_id) AS week_11,
  SUM(CASE
      WHEN wr.p_date = TIMESTAMP_ADD(wc.reg_date, INTERVAL 84 DAY) THEN (wr.p_revenue)
  END
    ) / COUNT(DISTINCT wc.user_pseudo_id) AS week_12
FROM
  weekly_revenue wr
JOIN
  weekly_cohorts wc
ON
  wr.user_pseudo_id = wc.user_pseudo_id
GROUP BY
  1
ORDER BY
  1
