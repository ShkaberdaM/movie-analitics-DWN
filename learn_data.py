import os
import zipfile
import pandas as pd
from sqlalchemy import create_engine
import logging

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
DB_URI = "postgresql://postgres:postgrespassword@localhost:5433/netflix_data_analitics"
engine = create_engine(DB_URI)

BRONZE_DIR = "data/bronze"


def extract_bronze_data():
    logging.info("Reading Bronze Movie Data from ZIP archive")
    os.makedirs(BRONZE_DIR, exist_ok=True)

    zip_path = "archive.zip"

    if not os.path.exists(zip_path):
        raise FileNotFoundError(f"Архив не найден по пути {zip_path}")

    with zipfile.ZipFile(zip_path, 'r') as z:
        csv_filename = [name for name in z.namelist() if name.endswith('.csv')][0]
        with z.open(csv_filename) as f:
            df_raw = pd.read_csv(f)

    logging.info(f"Bronze Movie Data Loaded Successfully ({len(df_raw)} records)")
    return df_raw


def clean_and_transform(df):
    logging.info("Cleaning and Transforming Data")

    columns_map = {
        'Series_Title': 'title',
        'Released_Year': 'release_year',
        'Runtime': 'runtime_mins',
        'Genre': 'genres',
        'IMDB_Rating': 'rating',
        'Director': 'director',
        'Star1': 'star_main',
        'Star2': 'star_co',
        'No_of_Votes': 'votes_count',
        'Gross': 'gross_revenue_usd'
    }
    df = df[list(columns_map.keys())].rename(columns=columns_map)

    df['release_year'] = pd.to_numeric(df['release_year'], errors='coerce')
    df = df.dropna(subset=['release_year'])
    df['release_year'] = df['release_year'].astype(int)
    df['runtime_mins'] = df['runtime_mins'].astype(str).str.replace(' min', '').astype(float)
    df['gross_revenue_usd'] = df['gross_revenue_usd'].astype(str).str.replace(',', '').astype(float)
    df['gross_revenue_usd'] = df['gross_revenue_usd'].fillna(0)

    logging.info("Transforming Data is Complete")
    return df


def load_to_process(df):
    logging.info("Loading Data")
    df.to_sql('stg_movies', con=engine, if_exists='replace', index=False)
    logging.info("Data Loaded in table 'stg_movies'")


if __name__ == "__main__":
    try:
        raw_df = extract_bronze_data()
        clean_df = clean_and_transform(raw_df)
        load_to_process(clean_df)
        logging.info("Successfully ETL-process Complete")
    except Exception as e:
        logging.error(f"Mistake with ETL: {e}")