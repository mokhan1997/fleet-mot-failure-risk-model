-- ============================================================
-- Project: Fleet MOT Failure Risk Model
-- File: 01_data_quality_checks.sql
-- Purpose: SQL data quality checks for MOT analysis database
-- ============================================================


-- 1. Check row count in main MOT sample table
SELECT 
    COUNT(*) AS total_rows
FROM mot_cleaned_sample;


-- 2. Check MOT outcome values
SELECT
    mot_outcome,
    COUNT(*) AS test_count
FROM mot_cleaned_sample
GROUP BY mot_outcome
ORDER BY test_count DESC;


-- 3. Check pass/fail flag values
SELECT
    is_pass,
    is_fail,
    COUNT(*) AS test_count
FROM mot_cleaned_sample
GROUP BY is_pass, is_fail
ORDER BY test_count DESC;


-- 4. Check missing values in key columns
SELECT
    SUM(CASE WHEN test_result IS NULL THEN 1 ELSE 0 END) AS missing_test_result,
    SUM(CASE WHEN test_date IS NULL THEN 1 ELSE 0 END) AS missing_test_date,
    SUM(CASE WHEN first_use_date IS NULL THEN 1 ELSE 0 END) AS missing_first_use_date,
    SUM(CASE WHEN test_mileage IS NULL THEN 1 ELSE 0 END) AS missing_test_mileage,
    SUM(CASE WHEN make IS NULL THEN 1 ELSE 0 END) AS missing_make,
    SUM(CASE WHEN model IS NULL THEN 1 ELSE 0 END) AS missing_model,
    SUM(CASE WHEN fuel_type IS NULL THEN 1 ELSE 0 END) AS missing_fuel_type,
    SUM(CASE WHEN vehicle_class IS NULL THEN 1 ELSE 0 END) AS missing_vehicle_class,
    SUM(CASE WHEN vehicle_age_years IS NULL THEN 1 ELSE 0 END) AS missing_vehicle_age_years
FROM mot_cleaned_sample;


-- 5. Check mileage range
SELECT
    MIN(test_mileage) AS min_test_mileage,
    MAX(test_mileage) AS max_test_mileage,
    ROUND(AVG(test_mileage), 2) AS avg_test_mileage
FROM mot_cleaned_sample;


-- 6. Check vehicle age range
SELECT
    MIN(vehicle_age_years) AS min_vehicle_age_years,
    MAX(vehicle_age_years) AS max_vehicle_age_years,
    ROUND(AVG(vehicle_age_years), 2) AS avg_vehicle_age_years
FROM mot_cleaned_sample;


-- 7. Check number of unique makes and models
SELECT
    COUNT(DISTINCT make) AS unique_makes,
    COUNT(DISTINCT model) AS unique_models,
    COUNT(DISTINCT fuel_type) AS unique_fuel_types,
    COUNT(DISTINCT vehicle_class) AS unique_vehicle_classes
FROM mot_cleaned_sample;


-- 8. Check test month coverage
SELECT
    test_month,
    COUNT(*) AS test_count
FROM mot_cleaned_sample
GROUP BY test_month
ORDER BY test_month;


-- 9. Check mileage band values
SELECT
    mileage_band,
    COUNT(*) AS test_count
FROM mot_cleaned_sample
GROUP BY mileage_band
ORDER BY test_count DESC;


-- 10. Check vehicle age band values
SELECT
    vehicle_age_band,
    COUNT(*) AS test_count
FROM mot_cleaned_sample
GROUP BY vehicle_age_band
ORDER BY test_count DESC;