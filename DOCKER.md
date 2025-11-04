# Docker Usage for Cards

This document describes how to build and run the Cards CLI application using Docker.

## Building the Image

Build the Docker image from the project root:

```bash
docker build -t cards:latest .
```

## Running the Application

### Basic Usage

Display help:
```bash
docker run --rm cards:latest --help
```

Show version:
```bash
docker run --rm cards:latest version
```

### Using with Persistent Data

To persist your cards database across container runs, use a Docker volume:

```bash
# Create and use a named volume
docker run --rm -v cards-data:/root/.cards cards:latest list
docker run --rm -v cards-data:/root/.cards cards:latest add "My first task"
docker run --rm -v cards-data:/root/.cards cards:latest add -o "John" "Another task"
docker run --rm -v cards-data:/root/.cards cards:latest list
```

### Using with Local Directory

Alternatively, mount a local directory:

```bash
# Use current directory's .cards folder
docker run --rm -v $(pwd)/.cards:/root/.cards cards:latest list
```

### Interactive Shell

To get an interactive shell inside the container:

```bash
docker run --rm -it -v cards-data:/root/.cards --entrypoint /bin/bash cards:latest
```

Inside the shell, you can run cards commands directly:
```bash
cards add "Task from inside container"
cards list
exit
```

## Using Docker Compose

The project includes a `docker-compose.yml` file for easier management.

### Run Commands

```bash
# Add a card
docker-compose run --rm cards add "My task"

# List cards
docker-compose run --rm cards list

# Show help
docker-compose run --rm cards --help

# Update a card
docker-compose run --rm cards update 1 -o "Alice"

# Mark a card as done
docker-compose run --rm cards finish 1

# Delete a card
docker-compose run --rm cards delete 1
```

### Clean Up

Remove the volume when you no longer need the data:
```bash
docker-compose down -v
```

Or manually:
```bash
docker volume rm cards-data
```

## Image Details

- Base image: `python:3.12-slim`
- Application installed via pip from source
- Database location: `/root/.cards` (configurable via volume mount)
- Entrypoint: `cards` CLI command
- Default CMD: `--help`

## Troubleshooting

### Database Not Persisting

Make sure you're using the same volume name across runs. The database is stored in `/root/.cards` inside the container.

### Permission Issues

If you encounter permission issues with local directory mounts, you may need to adjust file ownership or use a named volume instead.

## Examples

Complete workflow example:

```bash
# Initialize and add some cards
docker run --rm -v cards-data:/root/.cards cards:latest add "Learn Docker"
docker run --rm -v cards-data:/root/.cards cards:latest add "Build Cards image"
docker run --rm -v cards-data:/root/.cards cards:latest add -o "Bob" "Deploy to production"

# List all cards
docker run --rm -v cards-data:/root/.cards cards:latest list

# Start working on a card
docker run --rm -v cards-data:/root/.cards cards:latest start 1

# Finish a card
docker run --rm -v cards-data:/root/.cards cards:latest finish 1

# Check status
docker run --rm -v cards-data:/root/.cards cards:latest list
```

With docker-compose:

```bash
docker-compose run --rm cards add "Task 1"
docker-compose run --rm cards add "Task 2" -o "Alice"
docker-compose run --rm cards list
docker-compose run --rm cards start 1
docker-compose run --rm cards finish 1
docker-compose run --rm cards list
```
