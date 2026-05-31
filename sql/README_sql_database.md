# SQL Database Notes

## Database Name

fleet_mot_analysis.db

## Database Type

SQLite

## Purpose

This database was created from the cleaned 2024 MOT sample dataset and EDA summary tables.

The purpose of the database is to support SQL-based analysis of:

- MOT pass/fail outcomes
- MOT failure rate
- Vehicle age risk
- Mileage risk
- Make-level MOT failure patterns
- Fuel type differences
- Vehicle class differences
- Monthly MOT outcome trends

## Tables Created

| Table                     | Purpose                                        |
| ------------------------- | ---------------------------------------------- |
| mot_cleaned_sample        | 100,000-row sample of cleaned MOT test records |
| mot_outcome_summary       | Overall MOT outcome summary                    |
| mot_kpi_summary           | High-level KPI summary                         |
| mot_age_band_summary      | Failure rate by vehicle age band               |
| mot_mileage_band_summary  | Failure rate by mileage band                   |
| mot_make_summary          | Failure rate by vehicle make                   |
| mot_fuel_summary          | Failure rate by fuel type                      |
| mot_vehicle_class_summary | Failure rate by vehicle class                  |
| mot_monthly_summary       | Monthly MOT outcome summary                    |

## How the Database Was Created

The database was created using:

```text
src/create_sqlite_database.py
```
