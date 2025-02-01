from dotenv import load_dotenv, dotenv_values
import os

# Load environment variables from .env file
load_dotenv()

# Access variables
database_url = os.getenv("USER_EMAIL")
secret_key = os.getenv("USER_PASSWORD")

print(f"Database URL: {database_url}")
print(f"Secret Key: {secret_key}")
