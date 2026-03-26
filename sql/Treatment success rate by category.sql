WITH treatment_data AS (
  SELECT
    `YEAR _DISPLAY_` AS year,
    CASE `GHO _CODE_`
      WHEN 'TB_c_new_tsr' THEN 'New cases'
      WHEN 'TB_c_ret_tsr' THEN 'Previously treated'
      WHEN 'TB_c_mdr_tsr' THEN 'MDR-TB'
      WHEN 'TB_c_tbhiv_tsr' THEN 'HIV-positive TB'
    END AS treatment_category,
    Numeric AS success_rate
  FROM `healthmetrics-491205.who_health.TB_Indicator`
  WHERE `GHO _CODE_` IN (
    'TB_c_new_tsr', 'TB_c_ret_tsr', 'TB_c_mdr_tsr', 'TB_c_tbhiv_tsr'
  )
)
SELECT
  year,
  treatment_category,
  ROUND(success_rate, 1) AS success_rate,
  RANK() OVER (PARTITION BY year ORDER BY success_rate DESC) AS rank_within_year
FROM treatment_data
ORDER BY year DESC, rank_within_year