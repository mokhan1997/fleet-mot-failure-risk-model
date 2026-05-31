-- ============================================================
-- Project: Fleet MOT Failure Risk Model
-- File: 03_views_for_powerbi.sql
-- Purpose: Create SQL views for Power BI dashboard reporting
-- ============================================================


-- 1. Main MOT record-level dashboard view
DROP VIEW IF EXISTS v_mot_record_level_dashboard;

CREATE VIEW v_mot_record_level_dashboard AS
SELECT
    test_result,
    test_date,
    first_use_date,
    test_mileage,
    make,
    model,
    fuel_type,
    vehicle_class,
    colour,
    postcode_area,
    source_file,
    is_fail,
    is_pass,
    mot_outcome,
    vehicle_age_years,
    mileage_band,
    vehicle_age_band,
    test_month
FROM mot_cleaned_sample;


-- 2. Overall KPI view
DROP VIEW IF EXISTS v_mot_kpi_summary;

CREATE VIEW v_mot_kpi_summary AS
SELECT
    COUNT(*) AS total_mot_tests,
    SUM(CASE WHEN mot_outcome = 'Pass' THEN 1 ELSE 0 END) AS passed_tests,
    SUM(CASE WHEN mot_outcome = 'Fail' THEN 1 ELSE 0 END) AS failed_tests,
    ROUND(
        100.0 * SUM(CASE WHEN mot_outcome = 'Fail' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS failure_rate_percent,
    ROUND(
        100.0 * SUM(CASE WHEN mot_outcome = 'Pass' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS pass_rate_percent,
    ROUND(AVG(test_mileage), 0) AS avg_test_mileage,
    ROUND(AVG(vehicle_age_years), 2) AS avg_vehicle_age_years
FROM mot_cleaned_sample;


-- 3. Outcome summary view
DROP VIEW IF EXISTS v_mot_outcome_summary;

CREATE VIEW v_mot_outcome_summary AS
SELECT
    mot_outcome,
    COUNT(*) AS test_count,
    ROUND(
        100.0 * COUNT(*) / SUM(COUNT(*)) OVER (),
        2
    ) AS percentage_of_tests
FROM mot_cleaned_sample
GROUP BY mot_outcome;


-- 4. Failure rate by vehicle age band
DROP VIEW IF EXISTS v_age_band_performance;

CREATE VIEW v_age_band_performance AS
SELECT
    vehicle_age_band,
    COUNT(*) AS test_count,
    SUM(CASE WHEN mot_outcome = 'Fail' THEN 1 ELSE 0 END) AS failed_tests,
    SUM(CASE WHEN mot_outcome = 'Pass' THEN 1 ELSE 0 END) AS passed_tests,
    ROUND(
        100.0 * SUM(CASE WHEN mot_outcome = 'Fail' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS failure_rate_percent,
    ROUND(AVG(test_mileage), 0) AS avg_test_mileage
FROM mot_cleaned_sample
WHERE vehicle_age_band IS NOT NULL
GROUP BY vehicle_age_band;


-- 5. Failure rate by mileage band
DROP VIEW IF EXISTS v_mileage_band_performance;

CREATE VIEW v_mileage_band_performance AS
SELECT
    mileage_band,
    COUNT(*) AS test_count,
    SUM(CASE WHEN mot_outcome = 'Fail' THEN 1 ELSE 0 END) AS failed_tests,
    SUM(CASE WHEN mot_outcome = 'Pass' THEN 1 ELSE 0 END) AS passed_tests,
    ROUND(
        100.0 * SUM(CASE WHEN mot_outcome = 'Fail' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS failure_rate_percent,
    ROUND(AVG(vehicle_age_years), 2) AS avg_vehicle_age_years
FROM mot_cleaned_sample
WHERE mileage_band IS NOT NULL
GROUP BY mileage_band;


-- 6. Failure rate by make
DROP VIEW IF EXISTS v_make_performance;

CREATE VIEW v_make_performance AS
SELECT
    make,
    COUNT(*) AS test_count,
    SUM(CASE WHEN mot_outcome = 'Fail' THEN 1 ELSE 0 END) AS failed_tests,
    SUM(CASE WHEN mot_outcome = 'Pass' THEN 1 ELSE 0 END) AS passed_tests,
    ROUND(
        100.0 * SUM(CASE WHEN mot_outcome = 'Fail' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS failure_rate_percent,
    ROUND(AVG(test_mileage), 0) AS avg_test_mileage,
    ROUND(AVG(vehicle_age_years), 2) AS avg_vehicle_age_years
FROM mot_cleaned_sample
WHERE make IS NOT NULL
GROUP BY make
HAVING COUNT(*) >= 100;


-- 7. Failure rate by fuel type
DROP VIEW IF EXISTS v_fuel_type_performance;

CREATE VIEW v_fuel_type_performance AS
SELECT
    fuel_type,
    COUNT(*) AS test_count,
    SUM(CASE WHEN mot_outcome = 'Fail' THEN 1 ELSE 0 END) AS failed_tests,
    SUM(CASE WHEN mot_outcome = 'Pass' THEN 1 ELSE 0 END) AS passed_tests,
    ROUND(
        100.0 * SUM(CASE WHEN mot_outcome = 'Fail' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS failure_rate_percent,
    ROUND(AVG(test_mileage), 0) AS avg_test_mileage,
    ROUND(AVG(vehicle_age_years), 2) AS avg_vehicle_age_years
FROM mot_cleaned_sample
WHERE fuel_type IS NOT NULL
GROUP BY fuel_type;


-- 8. Failure rate by vehicle class
DROP VIEW IF EXISTS v_vehicle_class_performance;

CREATE VIEW v_vehicle_class_performance AS
SELECT
    vehicle_class,
    COUNT(*) AS test_count,
    SUM(CASE WHEN mot_outcome = 'Fail' THEN 1 ELSE 0 END) AS failed_tests,
    SUM(CASE WHEN mot_outcome = 'Pass' THEN 1 ELSE 0 END) AS passed_tests,
    ROUND(
        100.0 * SUM(CASE WHEN mot_outcome = 'Fail' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS failure_rate_percent,
    ROUND(AVG(test_mileage), 0) AS avg_test_mileage,
    ROUND(AVG(vehicle_age_years), 2) AS avg_vehicle_age_years
FROM mot_cleaned_sample
WHERE vehicle_class IS NOT NULL
GROUP BY vehicle_class;


-- 9. Monthly MOT outcome trend
DROP VIEW IF EXISTS v_monthly_outcome_trend;

CREATE VIEW v_monthly_outcome_trend AS
SELECT
    test_month,
    COUNT(*) AS test_count,
    SUM(CASE WHEN mot_outcome = 'Pass' THEN 1 ELSE 0 END) AS passed_tests,
    SUM(CASE WHEN mot_outcome = 'Fail' THEN 1 ELSE 0 END) AS failed_tests,
    ROUND(
        100.0 * SUM(CASE WHEN mot_outcome = 'Fail' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS failure_rate_percent,
    ROUND(AVG(test_mileage), 0) AS avg_test_mileage,
    ROUND(AVG(vehicle_age_years), 2) AS avg_vehicle_age_years
FROM mot_cleaned_sample
WHERE test_month IS NOT NULL
GROUP BY test_month;


-- 10. Age and mileage risk matrix
DROP VIEW IF EXISTS v_age_mileage_risk_matrix;

CREATE VIEW v_age_mileage_risk_matrix AS
SELECT
    vehicle_age_band,
    mileage_band,
    COUNT(*) AS test_count,
    SUM(CASE WHEN mot_outcome = 'Fail' THEN 1 ELSE 0 END) AS failed_tests,
    ROUND(
        100.0 * SUM(CASE WHEN mot_outcome = 'Fail' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS failure_rate_percent
FROM mot_cleaned_sample
WHERE vehicle_age_band IS NOT NULL
  AND mileage_band IS NOT NULL
GROUP BY vehicle_age_band, mileage_band
HAVING COUNT(*) >= 50;