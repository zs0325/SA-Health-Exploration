WITH hiv_tb AS (
  SELECT `YEAR _DISPLAY_` AS year, Numeric AS hiv_tb_cases
  FROM `healthmetrics-491205.who_health.TB_Indicator`
  WHERE `GHO _CODE_` = 'TB_e_inc_tbhiv_num'
),
total_tb AS (
  SELECT `YEAR _DISPLAY_` AS year, Numeric AS total_tb_cases
  FROM `healthmetrics-491205.who_health.TB_Indicator`
  WHERE `GHO _CODE_` = 'TB_e_inc_num'
),
hiv_tsr AS (
  SELECT `YEAR _DISPLAY_` AS year, Numeric AS hiv_tb_treatment_success
  FROM `healthmetrics-491205.who_health.TB_Indicator`
  WHERE `GHO _CODE_` = 'TB_c_tbhiv_tsr'
)
SELECT
  t.year,
  ROUND(t.total_tb_cases, 0) AS total_tb_cases,
  ROUND(h.hiv_tb_cases, 0) AS hiv_tb_cases,
  ROUND(h.hiv_tb_cases / t.total_tb_cases * 100, 1) AS hiv_tb_pct_of_total,
  ROUND(s.hiv_tb_treatment_success, 1) AS hiv_tb_treatment_success_rate
FROM total_tb t
LEFT JOIN hiv_tb h ON t.year = h.year
LEFT JOIN hiv_tsr s ON t.year = s.year
ORDER BY t.year DESC