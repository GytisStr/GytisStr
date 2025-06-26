WITH Quarters AS (
  SELECT 'Q1' AS Q UNION ALL
  SELECT 'Q2' UNION ALL
  SELECT 'Q3' UNION ALL
  SELECT 'Q4'
)

SELECT
  CONCAT(CAST(p.Metai AS STRING), ' ', q.Q) AS Ataskaitinis_periodas,
  p.Miestas,
  p.`Gyventojų_sk`
FROM data_table_1_ p
CROSS JOIN Quarters q
