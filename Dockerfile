# Stage 1: Builder
FROM python:3.14-slim AS builder

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

WORKDIR /app

# Install build dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    gcc \
    libssl-dev \
    libffi-dev \
    git \
    && rm -rf /var/lib/apt/lists/*

# Create virtual environment
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

COPY requirements.txt .

# Install dependencies into virtual environment
RUN pip install --upgrade pip setuptools wheel && \
    pip install --no-cache-dir -r requirements.txt && \
    # Cleanup to reduce size: strip binaries and remove build tools
    find /opt/venv -name "*.so" -exec strip --strip-debug {} \; && \
    pip uninstall -y pip setuptools wheel

# Stage 2: Final
FROM python:3.14-slim

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PATH="/opt/venv/bin:$PATH"

WORKDIR /app

# Create a non-root user first
RUN groupadd -g 1000 app && useradd -m -u 1000 -g app app

# Copy virtual environment from builder with correct ownership
COPY --from=builder --chown=app:app /opt/venv /opt/venv

# Copy application code with correct ownership
COPY --chown=app:app . /app

USER app

# Expose the port the app runs on
EXPOSE 8000

# Recommended production command: run uvicorn with multiple workers.
# Adjust workers according to available CPU and project needs.
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000", "--workers", "4"]
