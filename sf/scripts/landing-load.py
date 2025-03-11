from datetime import datetime

# List of tables and their column definitions
TABLES = {
    'CUSTOMERS': """
        customer_id VARCHAR,
        first_name VARCHAR,
        last_name VARCHAR,
        email VARCHAR,
        phone VARCHAR,
        filename VARCHAR,
        fileloadtime TIMESTAMP
    """,
    'PRODUCTS': """
        product_id VARCHAR,
        product_name VARCHAR,
        category VARCHAR,
        price FLOAT,
        filename VARCHAR,
        fileloadtime TIMESTAMP
    """,
    'SALES': """
        sale_id VARCHAR,
        customer_id VARCHAR,
        product_id VARCHAR,
        sale_date DATE,
        quantity INT,
        total_amount FLOAT,
        filename VARCHAR,
        fileloadtime TIMESTAMP
    """
}

def create_landing_table(conn, table_name, columns):
    """Create landing table if it doesn't exist"""
    try:
        cursor = conn.cursor()
        create_table_sql = f"""
            CREATE OR REPLACE TABLE {table_name} (
                {columns}
            )
        """
        cursor.execute(create_table_sql)
        print(f"Created table {table_name}")
    except Exception as e:
        print(f"Error creating table {table_name}: {str(e)}")
    finally:
        cursor.close()

def load_data_from_stage(conn, table_name, stage_name):
    """Load data from stage to landing table with additional columns"""
    try:
        cursor = conn.cursor()
        current_time = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        
        copy_into_sql = f"""
            COPY INTO {table_name}
            FROM @{stage_name}
            FILE_FORMAT = (TYPE = CSV SKIP_HEADER = 1)
            ON_ERROR = 'CONTINUE'
            PATTERN = '.*[.]csv'
            WITH (
                SELECT 
                    $1, $2, $3, $4, $5,  -- Adjust number of columns based on your CSV
                    METADATA$FILENAME as filename,
                    '{current_time}' as fileloadtime
                FROM @{stage_name}
            )
        """
        
        cursor.execute(copy_into_sql)
        print(f"Data loaded into {table_name}")
    except Exception as e:
        print(f"Error loading data into {table_name}: {str(e)}")
    finally:
        cursor.close()