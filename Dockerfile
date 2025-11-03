FROM python:3.10-slim

# Keep image small but install build deps required for scientific packages
ENV PYTHONDONTWRITEBYTECODE=1 PYTHONUNBUFFERED=1

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       build-essential \
       gfortran \
       libopenblas-dev \
       liblapack-dev \
       git \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Upgrade pip and install requirements (uses wheels when available)
COPY requirements.txt ./
RUN python -m pip install --upgrade pip setuptools wheel
RUN pip install -r requirements.txt

# Copy project files
COPY . .

# Expose the port your app binds to (Flask/gunicorn default 8000 here)
EXPOSE 8000

# Use gunicorn to run the Flask app
CMD ["gunicorn", "app:app", "--bind", "0.0.0.0:8000"]
