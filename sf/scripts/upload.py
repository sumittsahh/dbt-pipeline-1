import os
from tabulate import tabulate
from dotenv import load_dotenv
load_dotenv()


def get_file_type_counts(directory):
    """
    Scans a given directory and its subdirectories to count the number of CSV and non-CSV files.
    Returns a dictionary with the counts.
    """
    file_counts = {"csv": 0, "non_csv": 0, "file_types": {}}
    
    for root, _, files in os.walk(directory):
        for file in files:
            file_ext = os.path.splitext(file)[1].lower()
            
            if file_ext == ".csv":
                file_counts["csv"] += 1
            else:
                file_counts["non_csv"] += 1
                file_counts["file_types"].setdefault(file_ext, 0)
                file_counts["other_file_types"][file_ext] += 1
    
    return file_counts


def uploadCSV(cursor, stage, filePath, warehouse, warehouseSize, database, schema):
    '''
    1. Understand the Dataset: Familiarize yourself with the provided datasets, which include tables for Customers, Products, Sales, and more.
    2. Prepare CSV Files: Ensure all data files are correctly formatted as CSVs.
    3. Upload to Snowflake: Create an internal stage in Snowflake and upload each CSV file to this stage. The goal is to have all raw data accessible within Snowflake for further processing.
    Outcome: All raw data files are successfully uploaded to Snowflake internal stage, ready for initial processing.
    '''

    try:
        cursor.execute(f"use role accountadmin;")
        print(f"✅ Using role 'accountadmin'")
    except Exception as e:
        print(f"❌ Failed to use role 'accountadmin: {e}")

    
    try:
        cursor.execute(f"create warehouse if not exists {warehouse} with warehouse_size='{warehouseSize}';")
        print(f"✅ Warehouse {warehouse} created with size {warehouseSize}")
    except Exception as e:
        print(f"❌ failed to create {warehouse} with size {warehouseSize} : {e}")


    try:
        cursor.execute(f"create database if not exists {database};")
        cursor.execute(f"USE DATABASE {database};")
        print(f"✅ Using database {database}")
    except Exception as e:
        print(f"❌ Failed to use {database}: {e}")
    
    try:
        cursor.execute(f"create schema if not exists {database}.{schema};")
        cursor.execute(f"USE SCHEMA {database}.{schema};")
        print(f"✅ Using schema {database}.{schema}")
    except Exception as e:
        print(f"❌ Failed to use schema {database}.{schema}: {e}")
    

    try:
        # Create internal stage
        cursor.execute(f"CREATE STAGE IF NOT EXISTS {stage} DIRECTORY = (ENABLE = TRUE);")
        print(f"✅ Stage '{stage}' created with directory support")
    except Exception as e:
        print(f"❌ Failed to create stage '{stage}': {e}")

    try:
        print("🔍 Checking subfolder for file formats...")
        filePath = os.path.abspath(filePath)
        file_counts = get_file_type_counts(filePath)
        print(f"📊 File counts:")
        print(tabulate(file_counts.items(), headers=["File Type", "Count"], tablefmt="grid"))
        
        if not file_counts["file_types"]:
            print("👍 No other file types found.")
        else:
            print("⚠️ Other file types detected:")

    except Exception as e:
        print(f"❌ Error while checking file formats: {e}")


    try:
        print("🔍 Checking existing files in stage...")
        cursor.execute(f"LIST @{database}.{schema}.{stage}")
        existing_files = {row[0].split('/')[-1] for row in cursor.fetchall()}
        
        new_files = []
        skipped_files = []
        for root, _, files in os.walk(filePath):
            for file in files:
                if file.endswith(".csv"):
                    if file in existing_files:
                        skipped_files.append(file)
                    else:
                        new_files.append(os.path.join(root, file))
        
        if skipped_files:
            print(f"⏩ Skipped existing files:")
            print(tabulate([[f] for f in skipped_files], headers=["Skipped Files"], tablefmt="grid"))

        if new_files:
            put_command = f"PUT file://{filePath}/*.csv @{database}.{schema}.{stage} auto_compress=false"
            print(f"Executing PUT command: {put_command}")
            cursor.execute(put_command)
            result = cursor.fetchall()
            print(tabulate(result))
            print(f"✅ New files uploaded without compression")
        else:
            print(f"👍 No new files to upload")

    except Exception as e:
        print(f"❌ Files failed to upload: {e}")