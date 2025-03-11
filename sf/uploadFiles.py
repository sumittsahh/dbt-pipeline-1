import os
from tabulate import tabulate
from dotenv import load_dotenv
load_dotenv()

def uploadCSV(cursor, stage, filePath, warehouse, warehouseSize, database, role, schema):

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
        # Upload all CSV files (adjust path as needed)
        filePath = os.path.abspath("dbt-practice-project/sf/sf-dbt-data/")
        put_command = f"PUT file://{filePath}/*.csv @{database}.{schema}.{stage} auto_compress=false"
        print(f"Executing PUT command: {put_command}")
        cursor.execute(put_command)
        print(tabulate(cursor.fetchall()))
        print(f"✅ Files uploaded without compress")
    except Exception as e:
        print(f"❌ Files failed to upload: {e}")