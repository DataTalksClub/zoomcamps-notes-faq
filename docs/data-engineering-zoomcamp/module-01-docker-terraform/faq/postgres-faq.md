---
title: PostgreSQL FAQ
description: Frequently asked questions and troubleshooting guide for PostgreSQL database issues in the Data Engineering Zoomcamp
parent: Module 1 FAQ
nav_order: 7
has_children: false
---

# PostgreSQL FAQ
{: .no_toc }

This guide covers common PostgreSQL database issues and their solutions for the Data Engineering Zoomcamp, including Docker setup, connection problems, and authentication errors.
{: .fs-6 .fw-300 }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## Connection & Port Issues

### Bind: address already in use error

**Problem:**
```
docker: Error response from daemon: driver failed programming external connectivity on endpoint jolly_chatterjee 
(9e21c5bf0aa3dcc711185bc6fb1dc7b2722fc568fa47655dab98ab55ff8c23f2): failed to bind port 0.0.0.0:5432/tcp: 
Error starting userland proxy: listen tcp4 0.0.0.0:5432: bind: address already in use.
```

**Root Cause:** Port 5432 is already being used by another PostgreSQL service or process.

**Solutions:**

**Option 1: Stop the conflicting service**
1. Identify the process using the port:
   ```bash
   sudo lsof -i :5432
   ```
2. Stop the PostgreSQL service:
   ```bash
   sudo service postgresql stop
   ```

**Option 2: Use a different port mapping**
- **Docker run:** Use different port mapping (e.g., `5433:5432`)
- **Docker Compose:** Update port mapping in your `docker-compose.yml`
- **VM users:** Ensure the new port (5433) is properly forwarded in your VM settings

**Example Docker Compose with different port:**
```yaml
services:
  postgres:
    image: postgres:15-alpine
    ports:
      - "5433:5432"  # Map local port 5433 to container port 5432
```

---

## Authentication Issues

### Password authentication failed

**Problem:**
```
psycopg2.OperationalError: connection to server at "localhost" (::1), port 5432 failed: 
FATAL: password authentication failed for user "root"
```

**Root Cause:** Connection is reaching a local PostgreSQL installation instead of your Docker container, or incorrect credentials.

**Common scenarios:**
- Port 5432 is used by existing PostgreSQL installation
- Connection string pointing to wrong instance
- Incorrect port mapping in Docker

**Solutions:**

**Check your connection string:**
```python
# If using different port mapping
engine = create_engine('postgresql://root:root@localhost:5433/ny_taxi')
```

**For Windows users:**
1. Check if pgAdmin4 is using port 5432
2. Stop PostgreSQL service through `services.msc`
3. Or use different port mapping

**Remove conflicting installation:**
- If you don't need the local PostgreSQL, consider removing it
- Or use different ports for Docker containers

### Role does not exist error

**Problem:**
```
psycopg2.OperationalError: connection to server at "localhost" (::1), port 5432 failed: 
FATAL: role "root" does not exist
```

**Root Cause:** Connecting to local PostgreSQL instead of Docker container, or incorrect user configuration.

**This error occurs with:**
```bash
# pgcli connection
pgcli -h localhost -p 5432 -U root -d ny_taxi
```

```python
# Python connection
engine = create_engine('postgresql://root:root@localhost:5432/ny_taxi')
```

**Solutions:**

**Option 1: Change port mapping**
```yaml
# docker-compose.yml
services:
  postgres:
    ports:
      - "5431:5432"  # Use different local port
```

**Option 2: Fix environment variables**
```yaml
# docker-compose.yml
services:
  postgres:
    environment:
      - POSTGRES_USER=root  # Ensure correct user
      - POSTGRES_PASSWORD=root
      - POSTGRES_DB=ny_taxi
```

**Option 3: Reset Docker setup**
```bash
docker compose down
# Remove postgres volume folder
docker volume rm your_postgres_volume
docker compose up
```

---

## Database Issues

### Database does not exist error

**Problem:**
```
psycopg2.OperationalError: connection to server at "localhost" (::1), port 5432 failed: 
FATAL: database "ny_taxi" does not exist
```

**Root Cause:** The specified database hasn't been created, or connecting to wrong PostgreSQL instance.

**Solutions:**

**Verify Docker container is running:**
```bash
docker ps
```

**Check container logs:**
```bash
docker logs <postgres_container_name>
```

**Create database manually:**
```bash
# Connect to postgres database first
pgcli -h localhost -p 5432 -U root -d postgres

# Create the database
CREATE DATABASE ny_taxi;
```

**For local PostgreSQL conflicts:**
- Use different port (e.g., 8080) instead of 5432
- Or stop local PostgreSQL service

---

## Dependencies & Environment

### ModuleNotFoundError for psycopg2

**Problem:**
```
ModuleNotFoundError: No module named 'psycopg2'
```

**Root Cause:** PostgreSQL adapter for Python is not installed.

**Solutions:**

**Primary solution:**
```bash
pip install psycopg2-binary
```

**If already installed, upgrade it:**
```bash
pip install psycopg2-binary --upgrade
```

**Alternative solutions if above fails:**

**Update conda:**
```bash
conda update -n base -c defaults conda
```

**Clean reinstall:**
```bash
pip uninstall psycopg2 psycopg2-binary
pip install psycopg2-binary
```

**For Mac users with pg_config issues:**
```bash
brew install postgresql
pip install psycopg2-binary
```

---

## Platform-Specific Issues

### MacBook Pro M2 column recognition issue

**Problem:** "Column does not exist" errors on MacBook Pro M2 when the column actually exists in the database.

**Root Cause:** Psycopg2 compatibility issue on M2 Macs where column names in JOIN queries aren't recognized with certain quote styles.

**Solution:** Use double quotes for column names in SQL queries:
```sql
-- Instead of single quotes or no quotes
SELECT 'column_name' FROM table;

-- Use double quotes
SELECT "column_name" FROM table;
```

**Example:**
```python
# Problematic query
query = """
SELECT t.trip_id, t.fare_amount 
FROM trips t 
JOIN zones z ON t.pickup_location_id = z.location_id
"""

# Fixed query for M2 Macs
query = """
SELECT t."trip_id", t."fare_amount" 
FROM trips t 
JOIN zones z ON t."pickup_location_id" = z."location_id"
"""
```
