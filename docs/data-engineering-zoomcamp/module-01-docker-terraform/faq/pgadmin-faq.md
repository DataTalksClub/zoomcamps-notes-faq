---
title: pgAdmin FAQ
description: Frequently asked questions and troubleshooting guide for pgAdmin web interface in the Data Engineering Zoomcamp
parent: Module 1 FAQ
nav_order: 9
has_children: false
---

# pgAdmin FAQ
{: .no_toc }

This guide covers common pgAdmin issues and their solutions for the Data Engineering Zoomcamp, including interface problems, connection issues, and configuration management.
{: .fs-6 .fw-300 }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---
## PgAdmin Configuration & Persistence

### PgAdmin data persistence on Google Cloud Platform

**Problem:** PgAdmin data persistence fails when running Docker Compose on GCP with bind mounts.

**Root Cause:** GCP's filesystem handling doesn't properly support bind mounts for Docker containers.

**Solution:**

**Problematic approach (avoid):**
```yaml
services:
  pgadmin:
    volumes:
      - "./pgadmin:/var/lib/pgadmin:wr"  # Fails on GCP
```

**Correct approach (use named volumes):**
```yaml
services:
  pgadmin:
    volumes:
      - pgadmin:/var/lib/pgadmin  # Use named volume

volumes:
  pgadmin:  # Define the named volume
```

### PgAdmin configuration persistence between restarts

**Problem:** PgAdmin loses server connections and configuration settings after container restarts.

**Root Cause:** PgAdmin cannot write to its sessions directory due to permission issues, causing configuration loss.

**Solution:**

1. **Configure volume mounting in docker-compose.yml:**
   ```yaml
   services:
     pgdatabase:
       # ... database configuration
     
     pgadmin:
       image: dpage/pgadmin4
       environment:
         - PGADMIN_DEFAULT_EMAIL=admin@admin.com
         - PGADMIN_DEFAULT_PASSWORD=root
       volumes:
         - "./pgAdmin_data:/var/lib/pgadmin/sessions:rw"  # Mount sessions
       ports:
         - "8080:80"
   ```

2. **Set proper permissions before starting:**
   ```bash
   # Create directory
   mkdir pgAdmin_data
   
   # Set ownership for PgAdmin container (runs as UID/GID 5050)
   sudo chown -R 5050:5050 pgAdmin_data
   ```

3. **Start containers:**
   ```bash
   docker-compose up
   ```

### PgAdmin volume configuration alternative

**Problem:** Need alternative PgAdmin volume configuration for better persistence.

**Solution:**
```yaml
services:
  pgadmin:
    volumes:
      - type: volume
        source: pgadmin_data
        target: /var/lib/pgadmin

volumes:
  pgadmin_data:
```

---

## Interface & UI Issues

### Create server dialog missing

**Problem:** The Create server dialog doesn't appear in pgAdmin.

**Root Cause:** Newer versions of pgAdmin have changed the interface layout.

**Solution:** Use the alternative navigation path:
- Go to **Register** → **Server** instead of looking for the Create server dialog

### Blank/white screen after login

**Problem:** Seeing a blank or white screen after logging into pgAdmin in the browser.

**Error message:**
```
CSRFError: 400 Bad Request: The referrer does not match the host.
```

**Root Cause:** CSRF protection conflicts, particularly common when using GitHub Codespaces in the browser.

**Solutions:**

**Option 1: Disable CSRF protection**
Set the environment variable `PGADMIN_CONFIG_WTF_CSRF_ENABLED="False"`:

```bash
docker run --rm -it \
    -e PGADMIN_DEFAULT_EMAIL="admin@admin.com" \
    -e PGADMIN_DEFAULT_PASSWORD="root" \
    -e PGADMIN_CONFIG_WTF_CSRF_ENABLED="False" \
    -p "8080:80" \
    --name pgadmin \
    --network=pg-network \
    dpage/pgadmin4:8.2
```

**Option 2: Use local VS Code**
- Use locally installed VS Code to display GitHub Codespaces
- Open or create/start a Codespace in local VS Code instead of browser
- This issue doesn't occur when using local VS Code interface

**Reference:** [pgAdmin GitHub Issue #5432](https://github.com/pgadmin-org/pgadmin4/issues/5432)

---

## Access & Connection Issues

### Cannot access pgAdmin via browser (Mac Pro + GCP + Remote SSH)

**Problem:** Can't access/open the pgAdmin address via browser when using Mac Pro with GCP Compute Engine via Remote SSH in VS Code.

**Root Cause:** Network binding and port configuration issues in remote environments.

**Solutions:**

**Option 1: Docker run with custom configuration**
```bash
docker run --rm -it \
    -e PGADMIN_DEFAULT_EMAIL="admin@admin.com" \
    -e PGADMIN_DEFAULT_PASSWORD="pgadmin" \
    -e PGADMIN_CONFIG_WTF_CSRF_ENABLED="False" \
    -e PGADMIN_LISTEN_ADDRESS=0.0.0.0 \
    -e PGADMIN_LISTEN_PORT=5050 \
    -p 5050:5050 \
    --network=de-zoomcamp-network \
    --name pgadmin-container \
    --link postgres-container \
    -t dpage/pgadmin4
```

**Option 2: Docker Compose configuration**
```yaml
services:
  pgadmin:
    image: dpage/pgadmin4
    container_name: pgadmin-container
    environment:
      - PGADMIN_DEFAULT_EMAIL=admin@admin.com
      - PGADMIN_DEFAULT_PASSWORD=pgadmin
      - PGADMIN_CONFIG_WTF_CSRF_ENABLED=False
      - PGADMIN_LISTEN_ADDRESS=0.0.0.0
      - PGADMIN_LISTEN_PORT=5050
    volumes:
      - "./pgadmin_data:/var/lib/pgadmin/data"
    ports:
      - "5050:5050"
    networks:
      - de-zoomcamp-network
    depends_on:
      - postgres-container
```

**Key configuration changes:**
- `PGADMIN_LISTEN_ADDRESS=0.0.0.0` - Allows external connections
- `PGADMIN_LISTEN_PORT=5050` - Uses custom port
- `PGADMIN_CONFIG_WTF_CSRF_ENABLED=False` - Disables CSRF protection

### Unable to connect to server error

**Problem:**
```
Unable to connect to server: [Errno -3] Try again
```

**Root Cause:** Network connectivity issues between pgAdmin and PostgreSQL containers.

**Solution:**

**Step 1: Verify network connectivity**
```bash
docker network inspect pg-network
```

**Step 2: Connect PostgreSQL container to network (if needed)**
```bash
docker network connect pg-network <postgres_container_name>
```

**Step 3: Use container IP if hostname fails**
- If using `pg-database` as hostname doesn't work
- Find PostgreSQL container IP address from network inspection
- Use the IP address (e.g., `172.19.0.3`) instead of `pg-database` in pgAdmin's **Connection** → **Host name/address** field

**Troubleshooting steps:**
1. Ensure both containers are on the same network
2. Check container logs for connection errors
3. Verify PostgreSQL is accepting connections
4. Use IP address as fallback if hostname resolution fails

---

## Configuration & Persistence

### Persisting pgAdmin configurations

**Problem:** pgAdmin configurations are lost after restarting the container.

**Root Cause:** pgAdmin data is stored inside the container and gets lost when container is removed.

**Solution:** Create persistent volume mapping with proper permissions:

**Step 1: Create data directory**
```bash
mkdir -p /path/to/pgadmin-data
```

**Step 2: Set proper permissions**
```bash
# Assign ownership to pgAdmin's user (ID 5050)
sudo chown -R 5050:5050 /path/to/pgadmin-data
sudo chmod -R 755 /path/to/pgadmin-data
```

**Step 3: Use volume mapping in Docker commands**
```bash
docker run --rm -it \
    -e PGADMIN_DEFAULT_EMAIL="admin@admin.com" \
    -e PGADMIN_DEFAULT_PASSWORD="root" \
    -v /path/to/pgadmin-data:/var/lib/pgadmin \
    -p "8080:80" \
    --name pgadmin \
    --network=pg-network \
    dpage/pgadmin4:8.2
```

**Docker Compose example:**
```yaml
services:
  pgadmin:
    image: dpage/pgadmin4
    volumes:
      - "./pgadmin_data:/var/lib/pgadmin"
    # ... other configuration
```

**Important notes:**
- pgAdmin runs as user ID 5050 inside the container
- Proper permissions are crucial for data persistence
- Use relative paths in Docker Compose for portability
