#!/bin/bash
set -e

until pg_isready -U $POSTGRES_USER -d $POSTGRES_DB; do
    echo "Waiting for supply chain db to be ready..."
    sleep 2
done 

echo "Running supply chain db initialization scripts..."
echo "Creating supply chain schema..."
psql -U $POSTGRES_USER -d $POSTGRES_DB -f supply_chain_schema.sql
echo "Loading initial supply chain data..."
python3 db_init.py
echo "Supply chain db initialization scripts ran successfully"