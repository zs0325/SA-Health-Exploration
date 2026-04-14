-- composite_health_score.sql
-- Weighted composite health score combining treatment coverage, success rate, and HIV test %.

WITH metrics AS (
  SELECT
    year,
    ROUND(MAX(CASE WHEN indicator_code = 'TB_c_new_tsr'    THEN value END), 1) AS new_tsr,
    ROUND(MAX(CASE WHEN indicator_code = 'TB_1'            THEN value END), 1) AS treatment_coverage,
    ROUND(MAX(CASE WHEN indicator_code = 'TB_hivtest_pct'  THEN value END), 1) AS hiv_test_pct
  FROM {{ ref('stg_tb_indicator') }}
  GROUP BY year
)
SELECT
  year,
  new_tsr,
  treatment_coverage,
  hiv_test_pct,
  ROUND(
    (COALESCE(new_tsr, 0)            * 0.4)
    + (COALESCE(treatment_coverage, 0) * 0.4)
    + (COALESCE(hiv_test_pct, 0)      * 0.2)
  , 1) AS composite_health_score
FROM metrics
WHERE year IS NOT NULL
ORDER BY year DESC
