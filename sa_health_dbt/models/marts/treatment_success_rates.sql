-- treatment_success_rates.sql
-- Pivoted treatment success rates across all TB categories per year.

SELECT
  year,
  ROUND(MAX(CASE WHEN indicator_code = 'TB_c_new_tsr'   THEN value END), 1) AS new_cases_tsr,
  ROUND(MAX(CASE WHEN indicator_code = 'TB_c_ret_tsr'   THEN value END), 1) AS retreatment_tsr,
  ROUND(MAX(CASE WHEN indicator_code = 'TB_c_mdr_tsr'   THEN value END), 1) AS mdr_tb_tsr,
  ROUND(MAX(CASE WHEN indicator_code = 'TB_c_tbhiv_tsr' THEN value END), 1) AS hiv_tb_tsr
FROM {{ ref('stg_tb_indicator') }}
WHERE indicator_code IN (
  'TB_c_new_tsr',
  'TB_c_ret_tsr',
  'TB_c_mdr_tsr',
  'TB_c_tbhiv_tsr'
)
GROUP BY year
ORDER BY year DESC
