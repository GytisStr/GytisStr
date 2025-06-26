WITH Cleaned AS (
  SELECT
    CONCAT(YEAR(Ataskaitinis_periodas), ' Q', QUARTER(Ataskaitinis_periodas)) AS Ataskaitinis_periodas,
    Subjektas,
    `Išlaidų_grupės_lygis_2`,
    CAST(REPLACE(REPLACE(Vykdymas, ' ', ''), ',', '.') AS DOUBLE) AS Vykdymas_clean
  FROM Su_kult_filtru
),

Grouped AS (
  SELECT
    Ataskaitinis_periodas,
    Subjektas,
    `Išlaidų_grupės_lygis_2`,
    SUM(Vykdymas_clean) AS Vykdymo_suma
  FROM Cleaned
  GROUP BY Ataskaitinis_periodas, Subjektas, `Išlaidų_grupės_lygis_2`
),

Subjektas_Total AS (
  SELECT
    Ataskaitinis_periodas,
    Subjektas,
    'Iš viso' AS `Išlaidų_grupės_lygis_2`,
    SUM(Vykdymo_suma) AS Vykdymo_suma
  FROM Grouped
  GROUP BY Ataskaitinis_periodas, Subjektas
),

Grand_Total AS (
  SELECT
    Ataskaitinis_periodas,
    'Lietuvos Respublika' AS Subjektas,
    'Iš viso' AS `Išlaidų_grupės_lygis_2`,
    SUM(Vykdymo_suma) AS Vykdymo_suma
  FROM Grouped
  GROUP BY Ataskaitinis_periodas
)

SELECT * FROM Grouped
UNION ALL
SELECT * FROM Subjektas_Total
UNION ALL
SELECT * FROM Grand_Total
