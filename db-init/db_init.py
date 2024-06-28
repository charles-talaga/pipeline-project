import psycopg2
import random
import time
from os import getenv
from dotenv import load_dotenv

def main():
    print('Attempting to connect to supply chain database...')
    # Load environment variables
    load_dotenv()
    # Supply chain PostgreSQL database configuration
    db_config = {
        'user': getenv('POSTGRES_USER'),
        'dbname': getenv('POSTGRES_DB'),
    }

    print(f'Configuration details: \n{db_config}')
    # Connect to the database
    while True:
        try:
            conn = psycopg2.connect(**db_config)
            print('Connected to supply chain database')
            break
        except psycopg2.OperationalError as e:
            print(f'Connection attempt failed: \n{e}')
            print('Retrying connection in 5 seconds...')
            time.sleep(5)
   
if __name__ == '__main__':
    try:
        main()
    except Exception as e:
        print(f"Error in db_init.py: {e}")
        raise


'''
# number of warehouses: 5
# number of products: 108
# number of suppliers: 12 (each supplier supplies 9 products)
# lead times: 
#   depends on supplier reliability
#   assign reliability to each supplier, dictates lead time

insert_template = "INSERT INTO {} ({}) VALUES ({})"

warehouses = (f'warehouse {str(x)}' for x in range(1, 6))
suppliers = (f'supplier {str(x)}' for x in range(1, 13))

# Populate supply chain database with initial data
product_categories = ('televisions', 'laptops', 'smartphones', 
                      'tablets', 'smartwatches', 'headphones', 'cameras')
products = {
    'televisions': [f'tv model {str(x)}' for x in range(1, 8)],
    'laptops': [f'laptop model {str(x)}' for x in range(1, 14)],
    'smartphones': [f'smartphone model {str(x)}' for x in range(1, 25)],
    'tablets': [f'tablet model {str(x)}' for x in range(1, 16)],
    'smartwatches': [f'smartwatch model {str(x)}' for x in range(1, 12)],
    'headphones': [f'headphone model {str(x)}' for x in range(1, 22)],
    'cameras': [f'camera model {str(x)}' for x in range(1, 18)]
}

supplier_names = [f'supplier {str(x)}' for x in range(1, 13)]
'''