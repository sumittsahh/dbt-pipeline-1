import snowflake.connector
from util import SNOWFLAKE_CONFIG
from uploadFiles import uploadCSV


def connect_to_snowflake():
    """Establish connection to Snowflake"""
    try:
        conn = snowflake.connector.connect(**SNOWFLAKE_CONFIG)
        print("✅ Successfully connected to Snowflake")
        return conn
    except Exception as e:
        print(f"❌ Error connecting to Snowflake: {str(e)}")
        return None

def main():
    
    # Connect to Snowflake
    conn = connect_to_snowflake()
    if not conn:
        return
    else:
        cursor = conn.cursor()

    '''
    Step 1: Dataset Preparation and Upload (Snowflake)

    1. Understand the Dataset: Familiarize yourself with the provided datasets, which include tables for Customers, Products, Sales, and more.
    2. Prepare CSV Files: Ensure all data files are correctly formatted as CSVs.
    3. Upload to Snowflake: Create an internal stage in Snowflake and upload each CSV file to this stage. The goal is to have all raw data accessible within Snowflake for further processing.

    Outcome: All raw data files are successfully uploaded to Snowflake internal stage, ready for initial processing.
    '''


    
    # Internal stage name - adjust as needed
    stage_name = 'my_stage'
    warehouse = 'my_warehouse'
    warehouseSize = 'x-small'
    database= 'my_db'
    role= 'my_role'
    schema= 'my_schema'

    uploadCSV(
        cursor,
        stage_name,
        "dbt-practice-project/sf/sf-dbt-data/",
        warehouse,
        warehouseSize,
        database,
        role,
        schema
    )
    
    
    
    # try:
    #     # Create and load each table
    #     for table_name, columns in TABLES.items():
    #         # Create landing table
    #         full_table_name = f"{SNOWFLAKE_CONFIG['schema']}.{table_name}"
    #         create_landing_table(conn, full_table_name, columns)
            
    #         # Load data from stage
    #         load_data_from_stage(conn, full_table_name, stage_name)
            
    #     print("Data loading process completed successfully")
        
    # except Exception as e:
    #     print(f"Error in main process: {str(e)}")
    # finally:
    #     conn.close()
    #     print("Snowflake connection closed")

if __name__ == "__main__":
    main()