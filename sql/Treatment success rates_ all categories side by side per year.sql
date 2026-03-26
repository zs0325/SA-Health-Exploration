SELECT
  `YEAR _DISPLAY_` AS year,
  ROUND(MAX(CASE WHEN `GHO _CODE_` = 'TB_c_new_tsr' THEN Numeric END), 1) AS new_cases_tsr,
  ROUND(MAX(CASE WHEN `GHO _CODE_` = 'TB_c_ret_tsr' THEN Numeric END), 1) AS retreatment_tsr,
  ROUND(MAX(CASE WHEN `GHO _CODE_` = 'TB_c_mdr_tsr' THEN Numeric END), 1) AS mdr_tb_tsr,
  ROUND(MAX(CASE WHEN `GHO _CODE_` = 'TB_c_tbhiv_tsr' THEN Numeric END), 1) AS hiv_tb_tsr
FROM `healthmetrics-491205.who_health.TB_Indicator`
WHERE `GHO _CODE_` IN (
  'TB_c_new_tsr', 'TB_c_ret_tsr', 'TB_c_mdr_tsr', 'TB_c_tbhiv_tsr'
)
GROUP BY year
ORDER BY year DESC