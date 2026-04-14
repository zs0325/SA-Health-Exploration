-- tb_incidence_trend.sql
-- Year-over-year TB incidence trend per 100k population.

SELECT
  year,
  ROUND(value, 1)                                                         AS incidence_per_100k,
  ROUND(value - LAG(value) OVER (ORDER BY year), 1)                      AS yoy_change,
  ROUND(
    (value - LAG(value) OVER (ORDER BY year))
    / LAG(value) OVER (ORDER BY year) * 100, 1
  )                                                                        AS pct_change
FROM {{ ref('stg_tb_indicator') }}
WHERE indicator_code = 'MDG_0000000020'
ORDER BY year DESC
