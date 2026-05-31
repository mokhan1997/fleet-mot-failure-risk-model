from pathlib import Path
import pandas as pd


# Define project paths
PROJECT_ROOT = Path(__file__).resolve().parents[1]
RAW_DATA_PATH = PROJECT_ROOT / "data" / "raw"
SAMPLE_DATA_PATH = PROJECT_ROOT / "data" / "sample"

OUTPUT_FILE = SAMPLE_DATA_PATH / "mot_2024_sample.csv"


def main():
    """
    Create a manageable sample from the 2024 MOT monthly result files.
    """

    SAMPLE_DATA_PATH.mkdir(parents=True, exist_ok=True)

    raw_files = sorted(RAW_DATA_PATH.glob("test_result_2024*.csv"))

    if not raw_files:
        raise FileNotFoundError("No 2024 MOT result CSV files found in data/raw.")

    print(f"Found {len(raw_files)} raw MOT result files.")

    monthly_samples = []

    for file_path in raw_files:
        print(f"Reading sample from: {file_path.name}")

        # Read only the first 50,000 rows from each monthly file
        df = pd.read_csv(file_path, nrows=50000, low_memory=False)

        # Add source file column so we know which month the data came from
        df["source_file"] = file_path.name

        monthly_samples.append(df)

        print(f"Sample rows loaded: {len(df)}")

    sample_df = pd.concat(monthly_samples, ignore_index=True)

    sample_df.to_csv(OUTPUT_FILE, index=False)

    print("\nSample dataset created successfully.")
    print(f"Output file: {OUTPUT_FILE}")
    print(f"Rows: {sample_df.shape[0]}")
    print(f"Columns: {sample_df.shape[1]}")


if __name__ == "__main__":
    main()