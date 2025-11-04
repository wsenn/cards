# Dockerfile for the Cards CLI application
# A Python-based command line task tracking application
#
# Build:
#   docker build -t cards:latest .
#
# Run:
#   docker run --rm cards:latest --help
#   docker run --rm -v cards-data:/root/.cards cards:latest list
#   docker run --rm -v cards-data:/root/.cards cards:latest add "My task"
#
# Interactive shell:
#   docker run --rm -it -v cards-data:/root/.cards cards:latest /bin/bash

FROM python:3.12-slim

# Add metadata labels
LABEL maintainer="Cards Project"
LABEL description="Cards CLI - A command line task tracking application"
LABEL version="2.0.0"

# Set working directory
WORKDIR /app

# Copy only dependency files first for better layer caching
COPY pyproject.toml README.md ./

# Copy source code
COPY src/ ./src/

# Install the application and its dependencies
# pip will use pyproject.toml to determine dependencies
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir .

# Create a directory for the cards database
RUN mkdir -p /root/.cards

# Set the cards database directory as a volume for persistence
VOLUME ["/root/.cards"]

# Set the entrypoint to the cards CLI
ENTRYPOINT ["cards"]

# Default command shows help
CMD ["--help"]
