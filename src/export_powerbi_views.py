from pathlib import Path
import sqlite3
import pandas as pd


# Define project paths
PROJECT_ROOT = Path(__file__).resolve().parents[1]
DATABASE_PATH = PROJECT_ROOT / "data" / "processed" / "fleet_mot_analysis.db"
EXPORT_PATH = PROJECT_ROOT / "data" / "processed" / "powerbi_views"


def export_view(connection, view_name: str, output_file_name: str):
    """
    Export a SQLite view into a CSV file for Power BI.
    """

    query = f"SELECT * FROM {view_name};"

    df = pd.read_sql_query(query, connection)

    output_path = EXPORT_PATH / output_file_name

    df.to_csv(output_path, index=False)

    print(f"Exported {view_name} to {output_path}")
    print(f"Rows: {len(df)} | Columns: {df.shape[1]}")
    print("-" * 60)


def main():
    """
    Export SQL views into CSV files for Power BI dashboard development.
    """

    if not DATABASE_PATH.exists():
        raise FileNotFoundError(
            f"Database not found: {DATABASE_PATH}. "
            "Run src/create_sqlite_database.py first."
        )

    EXPORT_PATH.mkdir(parents=True, exist_ok=True)

    connection = sqlite3.connect(DATABASE_PATH)

    views_to_export = {
        "v_mot_record_level_dashboard": "mot_record_level_dashboard.csv",
        "v_mot_kpi_summary": "mot_kpi_summary.csv",
        "v_mot_outcome_summary": "mot_outcome_summary.csv",
        "v_age_band_performance": "age_band_performance.csv",
        "v_mileage_band_performance": "mileage_band_performance.csv",
        "v_make_performance": "make_performance.csv",
        "v_fuel_type_performance": "fuel_type_performance.csv",
        "v_vehicle_class_performance": "vehicle_class_performance.csv",
        "v_monthly_outcome_trend": "monthly_outcome_trend.csv",
        "v_age_mileage_risk_matrix": "age_mileage_risk_matrix.csv"
    }

    for view_name, output_file_name in views_to_export.items():
        export_view(connection, view_name, output_file_name)

    connection.close()

    print("Power BI view exports completed successfully.")


if __name__ == "__main__":
    main()