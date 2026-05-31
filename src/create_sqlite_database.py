from pathlib import Path
import sqlite3
import pandas as pd


# Define project paths
PROJECT_ROOT = Path(__file__).resolve().parents[1]
PROCESSED_DATA_PATH = PROJECT_ROOT / "data" / "processed"
DATABASE_PATH = PROCESSED_DATA_PATH / "fleet_mot_analysis.db"

CLEANED_FILE = PROCESSED_DATA_PATH / "mot_2024_cleaned_sample.csv"


def load_csv_if_exists(file_name: str) -> pd.DataFrame | None:
    """
    Load a CSV file from the processed data folder if it exists.
    """
    file_path = PROCESSED_DATA_PATH / file_name

    if not file_path.exists():
        print(f"Skipping missing file: {file_name}")
        return None

    return pd.read_csv(file_path, low_memory=False)


def main():
    """
    Create a SQLite database for MOT analysis.
    """

    if not CLEANED_FILE.exists():
        raise FileNotFoundError(
            f"Cleaned MOT file not found: {CLEANED_FILE}. "
            "Run notebook 02_data_cleaning.ipynb first."
        )

    print("Creating SQLite database...")
    print(f"Database path: {DATABASE_PATH}")

    connection = sqlite3.connect(DATABASE_PATH)

    # Load a manageable sample of the cleaned MOT data
    print("\nLoading cleaned MOT sample for SQL database...")

    mot_cleaned = pd.read_csv(CLEANED_FILE, low_memory=False)

    if len(mot_cleaned) > 100000:
        mot_sql_sample = mot_cleaned.sample(
            n=100000,
            random_state=42
        )
    else:
        mot_sql_sample = mot_cleaned.copy()

    print(f"Rows loaded into mot_cleaned_sample: {len(mot_sql_sample)}")

    mot_sql_sample.to_sql(
        "mot_cleaned_sample",
        connection,
        if_exists="replace",
        index=False
    )

    # Load and save summary tables if available
    summary_files = {
        "mot_outcome_summary": "mot_outcome_summary.csv",
        "mot_kpi_summary": "mot_kpi_summary.csv",
        "mot_age_band_summary": "mot_age_band_summary.csv",
        "mot_mileage_band_summary": "mot_mileage_band_summary.csv",
        "mot_make_summary": "mot_make_summary.csv",
        "mot_fuel_summary": "mot_fuel_summary.csv",
        "mot_vehicle_class_summary": "mot_vehicle_class_summary.csv",
        "mot_monthly_summary": "mot_monthly_summary.csv"
    }

    for table_name, file_name in summary_files.items():
        df = load_csv_if_exists(file_name)

        if df is not None:
            df.to_sql(
                table_name,
                connection,
                if_exists="replace",
                index=False
            )
            print(f"Created table: {table_name} | Rows: {len(df)}")

    # Check tables created
    tables = pd.read_sql_query(
        "SELECT name FROM sqlite_master WHERE type='table' ORDER BY name;",
        connection
    )

    print("\nTables created:")
    print(tables)

    print("\nRow counts:")
    for table_name in tables["name"]:
        row_count = pd.read_sql_query(
            f"SELECT COUNT(*) AS row_count FROM {table_name};",
            connection
        )
        print(f"{table_name}: {row_count.loc[0, 'row_count']} rows")

    connection.close()

    print("\nSQLite database created successfully.")


if __name__ == "__main__":
    main()