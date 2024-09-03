WITH

    user_register AS
    (
      SELECT
      user_pseudo_id,
      MIN(DATE_TRUNC(DATETIME(TIMESTAMP_MICROS(event_timestamp)), WEEK)) AS registration_week
      FROM `tc-da-1.turing_data_analytics.raw_events`
      WHERE DATE_TRUNC(DATETIME(TIMESTAMP_MICROS(event_timestamp)), WEEK) <= '2021-01-24'
      GROUP BY user_pseudo_id
      ),

    weekly_purchases AS
    (
      SELECT
      ur.registration_week,
      re.user_pseudo_id,
      SUM (CASE WHEN DATE_TRUNC(DATETIME(TIMESTAMP_MICROS(event_timestamp)), WEEK) = registration_week
                THEN purchase_revenue_in_usd END
                )AS week_0,
      SUM (CASE WHEN DATE_TRUNC(DATETIME(TIMESTAMP_MICROS(event_timestamp)), WEEK) <= DATE_ADD(ur.registration_week, INTERVAL 1 WEEK) AND DATE_ADD(ur.registration_week,INTERVAL 1 WEEK) >= '2021-01-31'THEN NULL ELSE
                (CASE WHEN DATE_TRUNC(DATETIME(TIMESTAMP_MICROS(event_timestamp)), WEEK) <= DATE_ADD(ur.registration_week, INTERVAL 1 WEEK)
                THEN purchase_revenue_in_usd END) END
                ) AS week_1,
      SUM (CASE WHEN DATE_TRUNC(DATETIME(TIMESTAMP_MICROS(event_timestamp)), WEEK) <= DATE_ADD(ur.registration_week, INTERVAL 2 WEEK) AND DATE_ADD(ur.registration_week,INTERVAL 2 WEEK) >= '2021-01-31' THEN NULL ELSE
                (CASE WHEN DATE_TRUNC(DATETIME(TIMESTAMP_MICROS(event_timestamp)), WEEK) <= DATE_ADD(ur.registration_week, INTERVAL 2 WEEK)
                THEN purchase_revenue_in_usd END) END
                ) AS week_2,
      SUM (CASE WHEN DATE_TRUNC(DATETIME(TIMESTAMP_MICROS(event_timestamp)), WEEK) <= DATE_ADD(ur.registration_week, INTERVAL 3 WEEK) AND DATE_ADD(ur.registration_week,INTERVAL 3 WEEK) >= '2021-01-31' THEN NULL ELSE
                (CASE WHEN DATE_TRUNC(DATETIME(TIMESTAMP_MICROS(event_timestamp)), WEEK) <= DATE_ADD(ur.registration_week, INTERVAL 3 WEEK)
                THEN purchase_revenue_in_usd END) END
                ) AS week_3,
      SUM (CASE WHEN DATE_TRUNC(DATETIME(TIMESTAMP_MICROS(event_timestamp)), WEEK) <= DATE_ADD(ur.registration_week, INTERVAL 4 WEEK) AND DATE_ADD(ur.registration_week,INTERVAL 4 WEEK) >= '2021-01-31' THEN NULL ELSE
                (CASE WHEN DATE_TRUNC(DATETIME(TIMESTAMP_MICROS(event_timestamp)), WEEK) <= DATE_ADD(ur.registration_week, INTERVAL 4 WEEK)
                THEN purchase_revenue_in_usd END) END
                ) AS week_4,
      SUM (CASE WHEN DATE_TRUNC(DATETIME(TIMESTAMP_MICROS(event_timestamp)), WEEK) <= DATE_ADD(ur.registration_week, INTERVAL 5 WEEK) AND DATE_ADD(ur.registration_week,INTERVAL 5 WEEK) >= '2021-01-31' THEN NULL ELSE
                (CASE WHEN DATE_TRUNC(DATETIME(TIMESTAMP_MICROS(event_timestamp)), WEEK) <= DATE_ADD(ur.registration_week, INTERVAL 5 WEEK)
                THEN purchase_revenue_in_usd END) END
                ) AS week_5,
      SUM (CASE WHEN DATE_TRUNC(DATETIME(TIMESTAMP_MICROS(event_timestamp)), WEEK) <= DATE_ADD(ur.registration_week, INTERVAL 6 WEEK) AND DATE_ADD(ur.registration_week,INTERVAL 6 WEEK) >= '2021-01-31' THEN NULL ELSE
                (CASE WHEN DATE_TRUNC(DATETIME(TIMESTAMP_MICROS(event_timestamp)), WEEK) <= DATE_ADD(ur.registration_week, INTERVAL 6 WEEK)
                THEN purchase_revenue_in_usd END) END
                ) AS week_6,
      SUM (CASE WHEN DATE_TRUNC(DATETIME(TIMESTAMP_MICROS(event_timestamp)), WEEK) <= DATE_ADD(ur.registration_week, INTERVAL 7 WEEK) AND DATE_ADD(ur.registration_week,INTERVAL 7 WEEK) >= '2021-01-31' THEN NULL ELSE
                (CASE WHEN DATE_TRUNC(DATETIME(TIMESTAMP_MICROS(event_timestamp)), WEEK) <= DATE_ADD(ur.registration_week, INTERVAL 7 WEEK)
                THEN purchase_revenue_in_usd END) END
                ) AS week_7,
      SUM (CASE WHEN DATE_TRUNC(DATETIME(TIMESTAMP_MICROS(event_timestamp)), WEEK) <= DATE_ADD(ur.registration_week, INTERVAL 8 WEEK) AND DATE_ADD(ur.registration_week,INTERVAL 8 WEEK) >= '2021-01-31' THEN NULL ELSE
                (CASE WHEN DATE_TRUNC(DATETIME(TIMESTAMP_MICROS(event_timestamp)), WEEK) <= DATE_ADD(ur.registration_week, INTERVAL 8 WEEK)
                THEN purchase_revenue_in_usd END) END
                ) AS week_8,
      SUM (CASE WHEN DATE_TRUNC(DATETIME(TIMESTAMP_MICROS(event_timestamp)), WEEK) <= DATE_ADD(ur.registration_week, INTERVAL 9 WEEK) AND DATE_ADD(ur.registration_week,INTERVAL 9 WEEK) >= '2021-01-31' THEN NULL ELSE
                (CASE WHEN DATE_TRUNC(DATETIME(TIMESTAMP_MICROS(event_timestamp)), WEEK) <= DATE_ADD(ur.registration_week, INTERVAL 9 WEEK)
                THEN purchase_revenue_in_usd END) END
                ) AS week_9,
      SUM (CASE WHEN DATE_TRUNC(DATETIME(TIMESTAMP_MICROS(event_timestamp)), WEEK) <= DATE_ADD(ur.registration_week, INTERVAL 10 WEEK) AND DATE_ADD(ur.registration_week,INTERVAL 10 WEEK) >= '2021-01-31' THEN NULL ELSE
                (CASE WHEN DATE_TRUNC(DATETIME(TIMESTAMP_MICROS(event_timestamp)), WEEK) <= DATE_ADD(ur.registration_week, INTERVAL 10 WEEK)
                THEN purchase_revenue_in_usd END) END
                ) AS week_10,
      SUM (CASE WHEN DATE_TRUNC(DATETIME(TIMESTAMP_MICROS(event_timestamp)), WEEK) <= DATE_ADD(ur.registration_week, INTERVAL 11 WEEK) AND DATE_ADD(ur.registration_week,INTERVAL 11 WEEK) >= '2021-01-31' THEN NULL ELSE
                (CASE WHEN DATE_TRUNC(DATETIME(TIMESTAMP_MICROS(event_timestamp)), WEEK) <= DATE_ADD(ur.registration_week, INTERVAL 11 WEEK)
                THEN purchase_revenue_in_usd END) END
                ) AS week_11,
      SUM (CASE WHEN DATE_TRUNC(DATETIME(TIMESTAMP_MICROS(event_timestamp)), WEEK) <= DATE_ADD(ur.registration_week, INTERVAL 12 WEEK) AND DATE_ADD(ur.registration_week,INTERVAL 12 WEEK) >= '2021-01-31' THEN NULL ELSE
                (CASE WHEN DATE_TRUNC(DATETIME(TIMESTAMP_MICROS(event_timestamp)), WEEK) <= DATE_ADD(ur.registration_week, INTERVAL 12 WEEK)
                THEN purchase_revenue_in_usd END) END
                ) AS week_12
  FROM `tc-da-1.turing_data_analytics.raw_events` re
  JOIN user_register ur
  ON re.user_pseudo_id = ur.user_pseudo_id
  GROUP BY registration_week, user_pseudo_id),

cohort_cumulative AS

(
  SELECT wp.registration_week AS cohort,
  COUNT(*) AS cohort_population,
  SUM(week_0) AS week_0,
  SUM(week_1) AS week_1,
  SUM(week_2) AS week_2, 
  SUM(week_3) AS week_3,
  SUM(week_4) AS week_4,
  SUM(week_5) AS week_5,
  SUM(week_6) AS week_6,
  SUM(week_7) AS week_7,
  SUM(week_8) AS week_8,
  SUM(week_9) AS week_9,
  SUM(week_10) AS week_10,
  SUM(week_11) AS week_11,
  SUM(week_12) AS week_12
  FROM weekly_purchases wp
  GROUP BY wp.registration_week
  ORDER BY wp.registration_week
)

  SELECT
    cohort,
    cohort_population,
    week_0/cohort_population AS week_0,
    week_1/cohort_population AS week_1,
    week_2/cohort_population AS week_2, 
    week_3/cohort_population AS week_3,
    week_4/cohort_population AS week_4, 
    week_5/cohort_population AS week_5, 
    week_6/cohort_population AS week_6,
    week_7/cohort_population AS week_7, 
    week_8/cohort_population AS week_8, 
    week_9/cohort_population AS week_9,
    week_10/cohort_population AS week_10, 
    week_11/cohort_population AS week_11, 
    week_12/cohort_population AS week12
    FROM cohort_cumulative