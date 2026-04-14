-- rolling_average_anomalies.sql
-- Flags years where TB incidence deviates more than 1 stddev from the 5-year rolling average.

WITH tb_incidence AS (
  SELECT year, value AS incidence
  FROM {{ ref('stg_tb_indicator') }}
  WHERE indicator_code = 'MDG_0000000020'
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
  ROUND(incidence - rolling_5yr_avg, 1)                                   AS deviation,
  CASE
    WHEN ABS(incidence - rolling_5yr_avg) > rolling_5yr_stddev THEN 'ANOMALY'
    ELSE 'Normal'
  END AS status
FROM rolling_stats
ORDER BY year DESC
