
# Use the latest PostgreSQL image
FROM postgres:latest

# Unbuffered Python output for debugging
ENV PYTHONUNBUFFERED=1

# Install Python, pip, and venv
RUN apt-get update && apt-get install -y python3 python3-pip python3-venv

# Set working directory
WORKDIR /postgres

# Create and activate a Python virtual environment
RUN python3 -m venv venv
ENV PATH="/app/venv/bin:$PATH"

# Copy Python dependencies txt file to the working directory
COPY requirements.txt .

# Install python dependencies
RUN pip install --break-system-packages -r requirements.txt

# Copy database initialization scripts to the container
COPY db-init/db_init.py .
COPY db-init/supply_chain_schema.sql .
COPY db-init/run_db_init.sh /docker-entrypoint-initdb.d/

# Command passed to entrypoint script to initialize the database
CMD ["postgres"]
