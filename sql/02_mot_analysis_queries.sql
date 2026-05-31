-- ============================================================
-- Project: Fleet MOT Failure Risk Model
-- File: 02_mot_analysis_queries.sql
-- Purpose: SQL analysis queries for MOT failure risk patterns
-- ============================================================


-- 1. Overall MOT KPI summary
SELECT
    COUNT(*) AS total_mot_tests,
    SUM(CASE WHEN mot_outcome = 'Pass' THEN 1 ELSE 0 END) AS passed_tests,
    SUM(CASE WHEN mot_outcome = 'Fail' THEN 1 ELSE 0 END) AS failed_tests,
    ROUND(
        100.0 * SUM(CASE WHEN mot_outcome = 'Fail' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS failure_rate_percent,
    ROUND(AVG(test_mileage), 0) AS avg_test_mileage,
    ROUND(AVG(vehicle_age_years), 2) AS avg_vehicle_age_years
FROM mot_cleaned_sample;


-- 2. MOT outcome split
SELECT
    mot_outcome,
    COUNT(*) AS test_count,
    ROUND(
        100.0 * COUNT(*) / SUM(COUNT(*)) OVER (),
        2
    ) AS percentage_of_tests
FROM mot_cleaned_sample
GROUP BY mot_outcome
ORDER BY test_count DESC;


-- 3. Failure rate by vehicle age band
SELECT
    vehicle_age_band,
    COUNT(*) AS test_count,
    SUM(CASE WHEN mot_outcome = 'Fail' THEN 1 ELSE 0 END) AS failed_tests,
    ROUND(
        100.0 * SUM(CASE WHEN mot_outcome = 'Fail' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS failure_rate_percent,
    ROUND(AVG(test_mileage), 0) AS avg_test_mileage
FROM mot_cleaned_sample
WHERE vehicle_age_band IS NOT NULL
GROUP BY vehicle_age_band
ORDER BY failure_rate_percent DESC;


-- 4. Failure rate by mileage band
SELECT
    mileage_band,
    COUNT(*) AS test_count,
    SUM(CASE WHEN mot_outcome = 'Fail' THEN 1 ELSE 0 END) AS failed_tests,
    ROUND(
        100.0 * SUM(CASE WHEN mot_outcome = 'Fail' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS failure_rate_percent,
    ROUND(AVG(vehicle_age_years), 2) AS avg_vehicle_age_years
FROM mot_cleaned_sample
WHERE mileage_band IS NOT NULL
GROUP BY mileage_band
ORDER BY failure_rate_percent DESC;


-- 5. Top 20 makes by MOT test volume
SELECT
    make,
    COUNT(*) AS test_count,
    SUM(CASE WHEN mot_outcome = 'Fail' THEN 1 ELSE 0 END) AS failed_tests,
    ROUND(
        100.0 * SUM(CASE WHEN mot_outcome = 'Fail' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS failure_rate_percent,
    ROUND(AVG(test_mileage), 0) AS avg_test_mileage,
    ROUND(AVG(vehicle_age_years), 2) AS avg_vehicle_age_years
FROM mot_cleaned_sample
WHERE make IS NOT NULL
GROUP BY make
ORDER BY test_count DESC
LIMIT 20;


-- 6. Makes with highest failure rate
-- Minimum test count is applied to avoid misleading results from very small samples.
SELECT
    make,
    COUNT(*) AS test_count,
    SUM(CASE WHEN mot_outcome = 'Fail' THEN 1 ELSE 0 END) AS failed_tests,
    ROUND(
        100.0 * SUM(CASE WHEN mot_outcome = 'Fail' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS failure_rate_percent,
    ROUND(AVG(test_mileage), 0) AS avg_test_mileage,
    ROUND(AVG(vehicle_age_years), 2) AS avg_vehicle_age_years
FROM mot_cleaned_sample
WHERE make IS NOT NULL
GROUP BY make
HAVING COUNT(*) >= 500
ORDER BY failure_rate_percent DESC
LIMIT 20;


-- 7. Failure rate by fuel type
SELECT
    fuel_type,
    COUNT(*) AS test_count,
    SUM(CASE WHEN mot_outcome = 'Fail' THEN 1 ELSE 0 END) AS failed_tests,
    ROUND(
        100.0 * SUM(CASE WHEN mot_outcome = 'Fail' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS failure_rate_percent,
    ROUND(AVG(test_mileage), 0) AS avg_test_mileage,
    ROUND(AVG(vehicle_age_years), 2) AS avg_vehicle_age_years
FROM mot_cleaned_sample
WHERE fuel_type IS NOT NULL
GROUP BY fuel_type
ORDER BY test_count DESC;


-- 8. Failure rate by vehicle class
SELECT
    vehicle_class,
    COUNT(*) AS test_count,
    SUM(CASE WHEN mot_outcome = 'Fail' THEN 1 ELSE 0 END) AS failed_tests,
    ROUND(
        100.0 * SUM(CASE WHEN mot_outcome = 'Fail' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS failure_rate_percent,
    ROUND(AVG(test_mileage), 0) AS avg_test_mileage,
    ROUND(AVG(vehicle_age_years), 2) AS avg_vehicle_age_years
FROM mot_cleaned_sample
WHERE vehicle_class IS NOT NULL
GROUP BY vehicle_class
ORDER BY test_count DESC;


-- 9. Monthly MOT outcome trend
SELECT
    test_month,
    COUNT(*) AS test_count,
    SUM(CASE WHEN mot_outcome = 'Pass' THEN 1 ELSE 0 END) AS passed_tests,
    SUM(CASE WHEN mot_outcome = 'Fail' THEN 1 ELSE 0 END) AS failed_tests,
    ROUND(
        100.0 * SUM(CASE WHEN mot_outcome = 'Fail' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS failure_rate_percent
FROM mot_cleaned_sample
WHERE test_month IS NOT NULL
GROUP BY test_month
ORDER BY test_month;


-- 10. High-mileage and older vehicle risk profile
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
HAVING COUNT(*) >= 100
ORDER BY failure_rate_percent DESC
LIMIT 30;