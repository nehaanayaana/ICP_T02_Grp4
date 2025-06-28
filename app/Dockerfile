# Use Python 3.9 image as base
FROM python:3.11

# Set working directory in container
WORKDIR /app

# Copy requirements file
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Expose port 8000
EXPOSE 8000

# Command to run the application
CMD ["fastapi", "run", "main.py", "--host", "0.0.0.0", "--port", "8000"]
