# Use the official Python image
FROM python:3.9-slim

# Install Flask and Kubernetes client library
RUN pip install flask kubernetes

# Copy the Flask application
COPY app.py /app.py

# Set the working directory
WORKDIR /

# Define the command to run the application
CMD ["python", "/app.py"]

# Expose port 8080
EXPOSE 8080