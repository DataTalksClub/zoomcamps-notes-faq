---
title: Docker Compose FAQ
description: Frequently asked questions and troubleshooting guide for Docker Compose networking, volume mounting, hostname resolution, and service orchestration in the Data Engineering Zoomcamp
parent: Module 1 FAQ
nav_order: 5
has_children: false
---

# Docker Compose FAQ
{: .no_toc }

This guide covers common Docker Compose issues and their solutions for the Data Engineering Zoomcamp, focusing on multi-container applications, networking, volume management, and service orchestration.
{: .fs-6 .fw-300 }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## Volume & Mounting Issues

### PostgreSQL permissions error with volumes

**Problem:**
```
error: could not change permissions of directory "/var/lib/postgresql/data": Operation not permitted
```

**Root Cause:** Docker cannot set proper permissions on the PostgreSQL data directory when using volume mounting.

**Solution:**

1. **Define named volumes explicitly in docker-compose.yml:**
   ```yaml
   volumes:    
     dtc_postgres_volume_local:  # Define the named volume here

   services:  
     postgres:
       image: postgres:13
       volumes:
         - dtc_postgres_volume_local:/var/lib/postgresql/data
       # ... other configuration
   ```

2. **Troubleshooting steps:**
   
   **Check volume details:**
   ```bash
   docker volume inspect dtc_postgres_volume_local
   ```

   **Common issue:** Docker Compose may create volumes with different names:
   - Expected: `dtc_postgres_volume_local`
   - Actual: `docker_sql_dtc_postgres_volume_local`

   **Fix naming mismatch:**
   ```bash
   # Rename existing volume to match Docker Compose naming
   docker volume create docker_sql_dtc_postgres_volume_local
   
   # Remove incorrectly named volume (use caution)
   docker volume rm dtc_postgres_volume_local
   
   # Restart services
   docker-compose up
   ```

3. **Verify data accessibility:**
   - Connect to PostgreSQL and check if tables are accessible
   - Use `docker-compose logs postgres` to check for errors

---

## Network & Hostname Resolution Issues

### Cannot translate hostname to address

**Problem:**
```
Couldn't translate host name to address
```
Or:
```
could not translate host name "pg-database" to address: Name or service not known
```

**Root Cause:** DNS resolution failure within Docker network - containers cannot resolve each other's hostnames.

**Solution:**

1. **Ensure containers are running:**
   ```bash
   # Start services in detached mode
   docker-compose up -d
   
   # Verify containers are running
   docker ps
   ```

   **Expected output:**
   ```
   CONTAINER ID   IMAGE            COMMAND                  STATUS          PORTS                           NAMES
   faf05090972e   postgres:13      "docker-entrypoint.s…"   Up 37 seconds   0.0.0.0:5432->5432/tcp          pg-database
   6344dcecd58f   dpage/pgadmin4   "/entrypoint.sh"         Up 37 seconds   443/tcp, 0.0.0.0:8080->80/tcp   pg-admin
   ```

2. **If containers aren't visible:**
   ```bash
   # Check all containers (including stopped)
   docker ps -a
   
   # Check logs for specific container
   docker logs <container_id>
   ```

3. **Fix network configuration:**
   ```yaml
   services:
     pgdatabase:  # Use simple names without hyphens
       image: postgres:13
       environment:
         - POSTGRES_USER=root
         - POSTGRES_PASSWORD=root
         - POSTGRES_DB=ny_taxi
       volumes:
         - "./ny_taxi_postgres_data:/var/lib/postgresql/data:rw"
       ports:
         - "5432:5432"
       networks:
         - pg-network     

     pgadmin:
       image: dpage/pgadmin4
       environment:
         - PGADMIN_DEFAULT_EMAIL=admin@admin.com
         - PGADMIN_DEFAULT_PASSWORD=root
       ports:
         - "8080:80"
       networks:
         - pg-network

   networks:
     pg-network:
       name: pg-network
   ```

### Network not found error

**Problem:**
```
Error response from daemon: network 66ae65944d643fdebbc89bd0329f1409dec2c9e12248052f5f4c4be7d1bdc6a3 not found
```
```
Unable to connect to server: could not translate host name 'pg-database' to address: Name does not resolve
```

**Root Cause:** Docker network configuration issues or container naming conflicts with DNS resolution.

**Solution:**

1. **Clean up existing containers:**
   ```bash
   # Remove all containers
   docker rm -f $(docker ps -aq)
   
   # Remove dangling networks (optional)
   docker network prune
   ```

2. **Restart services:**
   ```bash
   docker-compose up -d
   ```

3. **Use proper container naming:**
   - **Avoid hyphens** in service names: `pgdatabase` instead of `pg-database`
   - **Use consistent naming** throughout your configuration
   - **Define explicit networks** as shown in the previous example

4. **Verify network creation:**
   ```bash
   # List networks
   docker network ls
   
   # Inspect specific network
   docker network inspect <network_name>
   ```

### SQLAlchemy connection error with volume path conflicts

**Problem:**
```
sqlalchemy.exc.OperationalError: (psycopg2.OperationalError) could not translate host name 
/data_pgadmin:/var/lib/pgadmin"pg-database" to address: Name or service not known
```

**Root Cause:** Complex error combining volume path conflicts with hostname resolution issues.

**Solution:**

1. **Identify the auto-created network:**
   ```bash
   # After running docker-compose up, check logs
   docker-compose up -d
   docker network ls
   ```

2. **Update connection parameters:**
   - **Network name:** Use the actual network created (e.g., `project_default`)
   - **Container name:** Use the actual container name (e.g., `project-pgdatabase-1`)

3. **Alternative database clients:**
   - If pgcli fails, try **HeidiSQL** as an alternative
   - Use explicit connection parameters:
     ```bash
     # Example connection string
     postgresql://root:root@pgdatabase:5432/ny_taxi?sslmode=disable
     ```

4. **Explicit network configuration:**
   ```yaml
   services:
     pgdatabase:
       image: postgres:13
       container_name: pgdatabase  # Explicit container name
       environment:
         - POSTGRES_USER=root
         - POSTGRES_PASSWORD=root
         - POSTGRES_DB=ny_taxi
       volumes:
         - postgres_data:/var/lib/postgresql/data
       ports:
         - "5432:5432"
       networks:
         - app-network

     pgadmin:
       image: dpage/pgadmin4
       container_name: pgadmin
       environment:
         - PGADMIN_DEFAULT_EMAIL=admin@admin.com
         - PGADMIN_DEFAULT_PASSWORD=root
       volumes:
         - pgadmin_data:/var/lib/pgadmin
       ports:
         - "8080:80"
       networks:
         - app-network

   volumes:
     postgres_data:
     pgadmin_data:

   networks:
     app-network:
       driver: bridge
   ```

---

## Service Management & Orchestration

### Container startup verification

**Problem:** Need to verify that Docker Compose services are running correctly.

**Solution:**

1. **Check service status:**
   ```bash
   # Start services
   docker-compose up -d
   
   # Verify startup
   [+] Running 2/2
    ⠿ Container pg-admin     Started                    0.6s
    ⠿ Container pg-database  Started                    0.8s
   ```

2. **Monitor container health:**
   ```bash
   # List running containers
   docker ps
   
   # Check specific container logs
   docker-compose logs <service_name>
   
   # Follow logs in real-time
   docker-compose logs -f <service_name>
   ```

3. **Common service issues:**
   - **Port conflicts:** Change port mappings if 5432 or 8080 are occupied
   - **Volume conflicts:** Ensure volume paths are correct and accessible
   - **Environment variables:** Verify all required environment variables are set

### Service restart and cleanup

**Problem:** Need to restart services or clean up Docker Compose environment.

**Solution:**

**Restart specific services:**
```bash
# Restart single service
docker-compose restart <service_name>

# Rebuild and restart
docker-compose up --build <service_name>
```

**Complete cleanup:**
```bash
# Stop and remove containers
docker-compose down

# Remove containers, networks, and volumes
docker-compose down -v

# Remove everything including images
docker-compose down --rmi all -v
```

**Selective cleanup:**
```bash
# Remove only containers
docker-compose rm

# Stop containers without removing
docker-compose stop
```

---

## Troubleshooting Tips

### Debugging network connectivity

1. **Test container connectivity:**
   ```bash
   # From one container to another
   docker exec -it <container_name> ping <other_container_name>
   
   # Check network details
   docker network inspect <network_name>
   ```

2. **Verify DNS resolution:**
   ```bash
   # Inside container
   docker exec -it <container_name> nslookup <other_container_name>
   ```

3. **Check port accessibility:**
   ```bash
   # Test from host
   telnet localhost 5432
   
   # Or use netcat
   nc -zv localhost 5432
   ```

### Common Docker Compose patterns

**Basic multi-service setup:**
```yaml
version: '3.8'

services:
  database:
    image: postgres:13
    environment:
      POSTGRES_DB: mydb
      POSTGRES_USER: user
      POSTGRES_PASSWORD: password
    volumes:
      - db_data:/var/lib/postgresql/data
    ports:
      - "5432:5432"

  app:
    build: .
    depends_on:
      - database
    environment:
      DATABASE_URL: postgresql://user:password@database:5432/mydb
    ports:
      - "8000:8000"

volumes:
  db_data:
```

**With explicit networking:**
```yaml
services:
  # ... services configuration

networks:
  default:
    name: my-app-network
    driver: bridge
```

## Database & Network Configuration

### Empty database in PgAdmin after Docker Compose setup

**Problem:** Database appears empty when logging into PgAdmin after setting up Docker Compose, despite running data ingestion.

**Root Cause:** Network configuration mismatch between containers - the data ingestion container cannot communicate with PostgreSQL container due to being on different Docker networks.

**Solution:**

1. **Ensure proper container setup:**
   ```bash
   docker-compose up
   ```

2. **Configure data ingestion with correct network:**
   ```bash
   # Build the ingestion image
   docker build -t taxi_ingest:v001 .

   # Run with proper network configuration
   docker run -it \
     --network=pg-network \  # MUST match Docker Compose network
     taxi_ingest:v001 \
     --user=postgres \
     --password=postgres \
     --host=db \
     --port=5432 \
     --db=ny_taxi \
     --table_name=green_tripdata \
     --url=${URL}
   ```

3. **Network configuration options:**

   **Option 1: Explicit network definition**
   ```yaml
   services:
     db:
       container_name: postgres
       image: postgres:17-alpine
       networks:
         - pg-network
       # ... other configurations

     pgadmin:
       container_name: pgadmin
       image: dpage/pgadmin4:latest
       networks:
         - pg-network
       # ... other configurations

   networks:
     pg-network:
       driver: bridge
   ```

   **Option 2: Auto-generated network**
   ```yaml
   services:
     db:
       container_name: postgres
       image: postgres:17-alpine
       # No explicit network - uses default

     pgadmin:
       container_name: pgadmin
       image: dpage/pgadmin4:latest
       # No explicit network - uses default

   volumes:
     vol-pgdata:
       name: vol-pgdata
     vol-pgadmin_data:
       name: vol-pgadmin_data
   ```

4. **Identify auto-generated network name:**
   - **Format:** `<directory_name_lowercase>_default`
   - **Find in docker-compose output:**
     ```
     pg-database Pulling
     pg-database Pulled
     Network week_1_default  Creating  <-- THIS IS YOUR NETWORK NAME
     Network week_1_default  Created
     ```

### Docker Compose setup checklist

**Problem:** Multiple configuration issues preventing proper Docker Compose operation.

**Root Cause:** Incorrect execution order or misconfigured components.

**Solution - Follow this exact sequence:**

1. **Volume setup:**
   - Create Docker volume via command line or Docker Desktop app

2. **Data ingestion configuration:**
   ```python
   # Set low_memory=False when importing CSV files
   df = pd.read_csv('yellow_tripdata_2021-01.csv', 
                    nrows=1000, 
                    low_memory=False)
   ```

3. **Correct execution order:**
   ```bash
   # 1. Navigate to project directory
   cd 2_docker_sql
   
   # 2. Start containers
   docker-compose up
   
   # 3. Verify containers are running
   docker ps
   # Should show only pgadmin and pgdatabase containers
   
   # 4. Start Jupyter notebook for data ingestion
   jupyter notebook
   ```

4. **PgAdmin server configuration:**
   - **Container name:** Must match `pgdatabase`
   - **Port number:** Must match configured port
   - **Database name:** Must match `ny_taxi`

---


## Docker Engine & Credential Issues

### Docker engine crashes with extension fetch errors

**Problem:**
```
docker engine stopped
failed to fetch extensions
```
Docker engine keeps crashing with continuous extension fetch failure popups, persisting after system restart.

**Root Cause:** Corrupted Docker installation or incompatible extensions causing engine system failures.

**Solution:**

1. **First attempt - Update Docker:**
   ```bash
   # Check current version
   docker --version
   
   # Update to latest version
   # (method depends on your installation)
   ```

2. **If problem persists - Complete reinstallation:**
   ```bash
   # Uninstall Docker completely
   # Download and install latest Docker
   # Note: You'll need to re-pull Docker images
   ```

**Important:** All Docker configurations and data remain intact after reinstallation, but images need to be re-pulled.

### Docker socket permission denied error

**Problem:**
```
dial unix /var/run/docker.sock: connect: permission denied
```

**Root Cause:** Current user lacks access rights to the Docker daemon socket file.

**Solution:**

1. **Add user to docker group:**
   ```bash
   # Create docker group (if it doesn't exist)
   sudo groupadd docker
   
   # Add current user to docker group
   sudo usermod -aG docker $USER
   
   # Log out and log back in
   # Or use: newgrp docker
   ```

2. **Alternative - Follow official guide:**
   - See: [Docker without sudo guide](https://github.com/sindresorhus/guides/blob/main/docker-without-sudo.md)
   - After setup, log out with `ctrl+D` and log back in

### Credential helper not found error

**Problem:**
```
err: exec: "docker-credential-desktop": executable file not found in %PATH%
```

**Root Cause:** Docker's credential management system cannot find the necessary credential helper executable.

**Solution:**

**Option 1: Install credential helper**
```bash
sudo apt install pass
```

**Option 2: Fix Docker config (WSL specific)**
```bash
# Edit Docker config file
nano ~/.docker/config.json

# Change "credsStore" to "credStore"
{
  "credStore": "desktop"  # Changed from "credsStore"
}
```

**Reference:** [GitHub Issue - moby/buildkit#1078](https://github.com/moby/buildkit/issues/1078)

---

## Volume & Permission Issues

### Undefined volume error

**Problem:**
```
service "pgdatabase" refers to undefined volume dtc_postgres_volume_local: invalid compose project
```

**Root Cause:** Service references a named volume that hasn't been defined in the volumes section.

**Solution:**

**Add volume definition to docker-compose.yml:**
```yaml
services:
  pgdatabase:
    volumes:
      - dtc_postgres_volume_local:/var/lib/postgresql/data
    # ... other configuration

volumes:
  dtc_postgres_volume_local:  # Define the named volume
```

---

## Binary & Compatibility Issues

### Docker Compose binary execution format error

**Problem:**
```
cannot execute binary file: Exec format error
```

**Root Cause:** Docker Compose binary doesn't match system's CPU architecture.

**Solution:**

1. **Check system architecture:**
   ```bash
   uname -s   # Should return "Linux"
   uname -m   # Returns architecture (x86_64, aarch64, etc.)
   ```

2. **Download correct binary:**
   ```bash
   # Automatic download for your architecture
   sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
   
   # Make executable
   sudo chmod +x /usr/local/bin/docker-compose
   ```

3. **Specific version recommendations (as of 2025/1/17):**
   - **Use:** docker-compose v2.32.3 `docker-compose-linux-x86_64`
   - **Avoid:** docker-compose v2.32.4 `docker-compose-linux-aarch64`
   - **Download link:** [docker-compose-linux-x86_64 v2.32.3](https://github.com/docker/compose/releases/download/v2.32.3/docker-compose-linux-x86_64)

### Docker Compose command not available after bashrc update

**Problem:** Docker Compose command not found after updating .bashrc.

**Root Cause:** Binary filename doesn't match expected command name.

**Solution:**

1. **Check downloaded filename:**
   ```bash
   ls -la docker-compose*
   # May show: docker-compose-linux-x86_64
   ```

2. **Rename for convenience:**
   ```bash
   mv docker-compose-linux-x86_64 docker-compose
   ```

3. **Make executable and move to PATH:**
   ```bash
   chmod +x docker-compose
   sudo mv docker-compose /usr/local/bin/
   ```

---

## Container Initialization Issues

### PostgreSQL container exit code (1) failure

**Problem:** PostgreSQL container fails to launch and exits with code (1) in Docker Compose.

**Root Cause:** PostgreSQL database isn't properly initialized before Docker Compose attempts to start the service.

**Solution:**

1. **Initialize database manually first:**
   ```bash
   docker run -it \
     -e POSTGRES_USER="root" \
     -e POSTGRES_PASSWORD="root" \
     -e POSTGRES_DB="ny_taxi" \
     -v $(pwd)/ny_taxi_data:/var/lib/postgresql/data \
     -p 5432:5432 \
     --network=pg-network \
     --name=pg_database \
     postgres:13
   ```

2. **Stop the manual container:**
   ```bash
   docker stop pg_database
   docker rm pg_database
   ```

3. **Then run Docker Compose:**
   ```bash
   docker-compose up
   ```

4. **Alternative - Check volume permissions:**
   ```bash
   # Ensure data directory has proper permissions
   sudo chown -R 999:999 ny_taxi_data/
   ```

**Reference:** [PostgreSQL Container Discussion](https://forums.docker.com/t/one-of-the-postgres-containers-stops-as-soon-as-it-starts/74714/3)