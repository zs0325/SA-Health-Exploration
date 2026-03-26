WITH metrics AS (
  SELECT
    `YEAR _DISPLAY_` AS year,
    ROUND(MAX(CASE WHEN `GHO _CODE_` = 'TB_c_new_tsr' THEN Numeric END), 1) AS new_tsr,
    ROUND(MAX(CASE WHEN `GHO _CODE_` = 'TB_1' THEN Numeric END), 1) AS treatment_coverage,
    ROUND(MAX(CASE WHEN `GHO _CODE_` = 'TB_hivtest_pct' THEN Numeric END), 1) AS hiv_test_pct
  FROM `healthmetrics-491205.who_health.TB_Indicator`
  GROUP BY year
)
SELECT
  year,
  new_tsr,
  treatment_coverage,
  hiv_test_pct,
  ROUND(
    (COALESCE(new_tsr, 0) * 0.4)
    + (COALESCE(treatment_coverage, 0) * 0.4)
    + (COALESCE(hiv_test_pct, 0) * 0.2)
  , 1) AS composite_health_score
FROM metrics
WHERE year IS NOT NULL
ORDER BY year DESC