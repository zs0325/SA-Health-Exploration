SELECT
  `YEAR _DISPLAY_` AS year,
  ROUND(Numeric, 1) AS incidence_per_100k,
  ROUND(Numeric - LAG(Numeric) OVER (ORDER BY `YEAR _DISPLAY_`), 1) AS yoy_change,
  ROUND(
    (Numeric - LAG(Numeric) OVER (ORDER BY `YEAR _DISPLAY_`)) 
    / LAG(Numeric) OVER (ORDER BY `YEAR _DISPLAY_`) * 100, 1
  ) AS pct_change
FROM `healthmetrics-491205.who_health.TB_Indicator`
WHERE `GHO _CODE_` = 'MDG_0000000020'
ORDER BY year DESC