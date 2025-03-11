import snowflake.connector
from util.util import SNOWFLAKE_CONFIG
from scripts.upload import uploadCSV
import os
from dotenv import load_dotenv
load_dotenv()


def connect_to_snowflake():
    """Establish connection to Snowflake"""
    try:
        conn = snowflake.connector.connect(**SNOWFLAKE_CONFIG)
        print("✅ Successfully connected to Snowflake")
        return conn
    except Exception as e:
        print(f"❌ Error connecting to Snowflake: {str(e)}")
        return None

def main(upload=False,):
    
    # Connect to Snowflake
    conn = connect_to_snowflake()
    if not conn:
        return
    else:
        cursor = conn.cursor()

    '''
    Step 1: Dataset Preparation and Upload (Snowflake)
    '''
    if upload:
        uploadCSV(
            cursor,
            os.getenv('stage_name'),
            os.getenv('sf-dbt-data'),
            os.getenv('warehouse'),
            os.getenv('warehouseSize'),
            os.getenv('database'),
            os.getenv('schema')
        )

if __name__ == "__main__":
    main(
        upload=True,
    )