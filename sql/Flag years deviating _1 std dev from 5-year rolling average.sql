WITH tb_incidence AS (
  SELECT
    `YEAR _DISPLAY_` AS year,
    Numeric AS incidence
  FROM `healthmetrics-491205.who_health.TB_Indicator`
  WHERE `GHO _CODE_` = 'MDG_0000000020'
),
rolling_stats AS (
  SELECT
    year,
    incidence,
    ROUND(AVG(incidence) OVER (
      ORDER BY year
      ROWS BETWEEN 4 PRECEDING AND CURRENT ROW
    ), 1) AS rolling_5yr_avg,
    ROUND(STDDEV(incidence) OVER (
      ORDER BY year
      ROWS BETWEEN 4 PRECEDING AND CURRENT ROW
    ), 1) AS rolling_5yr_stddev
  FROM tb_incidence
)
SELECT
  year,
  incidence,
  rolling_5yr_avg,
  rolling_5yr_stddev,
  ROUND(incidence - rolling_5yr_avg, 1) AS deviation,
  CASE
    WHEN ABS(incidence - rolling_5yr_avg) > rolling_5yr_stddev THEN 'ANOMALY'
    ELSE 'Normal'
  END AS status
FROM rolling_stats
ORDER BY year DESC