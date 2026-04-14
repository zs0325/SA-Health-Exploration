-- stg_tb_indicator.sql
-- Cleans up raw column names from the WHO TB_Indicator source table.
-- All downstream models reference this staging model via ref().

SELECT
  `YEAR _DISPLAY_`  AS year,
  `GHO _CODE_`      AS indicator_code,
  Numeric           AS value
FROM `healthmetrics-491205.who_health.TB_Indicator`
WHERE `YEAR _DISPLAY_` IS NOT NULL
