# Use the latest Airflow image
FROM apache/airflow:latest

# Set working directory
WORKDIR /opt/airflow/

# Copy Python dependencies file to the working directory
COPY requirements.txt .

# Install Python dependencies
RUN pip install -r requirements.txt

# Run the Airflow scheduler
CMD ["airflow", "scheduler"]