import os
from dotenv import load_dotenv
load_dotenv()

# Snowflake connection parameters - replace with your actual credentials
SNOWFLAKE_CONFIG = {
    'account': os.getenv('your_account'),
    'user': os.getenv('your_username'),
    'password': os.getenv('your_password')
}