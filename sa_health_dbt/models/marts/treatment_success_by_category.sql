-- treatment_success_by_category.sql
-- Treatment success rates broken out by category with rank within each year.

WITH treatment_data AS (
  SELECT
    year,
    CASE indicator_code
      WHEN 'TB_c_new_tsr'   THEN 'New cases'
      WHEN 'TB_c_ret_tsr'   THEN 'Previously treated'
      WHEN 'TB_c_mdr_tsr'   THEN 'MDR-TB'
      WHEN 'TB_c_tbhiv_tsr' THEN 'HIV-positive TB'
    END AS treatment_category,
    value AS success_rate
  FROM {{ ref('stg_tb_indicator') }}
  WHERE indicator_code IN (
    'TB_c_new_tsr',
    'TB_c_ret_tsr',
    'TB_c_mdr_tsr',
    'TB_c_tbhiv_tsr'
  )
)
SELECT
  year,
  treatment_category,
  ROUND(success_rate, 1)                                                   AS success_rate,
  RANK() OVER (PARTITION BY year ORDER BY success_rate DESC)              AS rank_within_year
FROM treatment_data
ORDER BY year DESC, rank_within_year
