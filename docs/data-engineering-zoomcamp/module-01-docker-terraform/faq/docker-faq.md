---
title: Docker FAQ
description: Frequently asked questions and troubleshooting guide for Docker containers, volumes, networking, and platform-specific issues in the Data Engineering Zoomcamp
parent: Module 1 FAQ
nav_order: 4
has_children: false
---

# Docker FAQ
{: .no_toc }

This comprehensive guide covers common Docker issues and their solutions for the Data Engineering Zoomcamp, including installation, container management, volume mounting, and platform-specific troubleshooting.
{: .fs-6 .fw-300 }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## Installation & Setup Issues

### Docker daemon not running

**Problem:**
```
Cannot connect to Docker daemon at unix:///var/run/docker.sock. Is the docker daemon running?
```

**Root Cause:** Docker daemon service is not started or WSL needs updating.

**Solution:**
1. **Check Docker daemon status:**
   ```bash
   sudo systemctl status docker
   ```
2. **Start Docker daemon if stopped:**
   ```bash
   sudo systemctl start docker
   ```
3. **For WSL users, update WSL:**
   ```powershell
   wsl --update
   ```

### Docker connection error with elevated privileges (Windows)

**Problem:** Docker connection errors mentioning "elevated privileges" and "docker_engine".

**Root Cause:** Incorrect backend configuration for your Windows version.

**Solutions by Windows Edition:**

**Windows 10/11 Pro:**
- **Must enable Hyper-V** as the backend
- Follow tutorial: [Enable Hyper-V Option on Windows 10/11](https://www.c-sharpcorner.com/article/install-and-configured-docker-desktop-in-windows-10/)

**Windows 10/11 Home:**
- **Use WSL2** (Hyper-V not available in Home edition)
- Follow installation: [WSL Installation Guide](https://pureinfotech.com/install-wsl-windows-11/)

**Additional troubleshooting:**
If you encounter `WslRegisterDistribution failed with error: 0x800701bc`:
- Update WSL2 Linux Kernel
- Follow guidelines: [WSL GitHub Issue #5393](https://github.com/microsoft/WSL/issues/5393)

### Docker stuck on startup (Windows)

**Problem:** Docker won't start or gets stuck in settings on Windows 10/11.

**Root Cause:** Outdated Docker version, backend configuration issues, or corrupted installation.

**Solutions:**

1. **Update Docker Desktop:**
   - Download latest version from [official page](https://docs.docker.com/desktop/install/windows-install/)
   - Don't rely on in-app "Upgrade" option

2. **Switch container types:**
   - Right-click Docker icon in system tray
   - Switch between Windows and Linux containers

3. **Backend configuration:**
   - **Pro Edition:** Can use Hyper-V or WSL2
   - **Home Edition:** Use WSL2 only

4. **Reset if still stuck:**
   - Use "Reset to Factory Defaults" option
   - Or perform fresh installation

### Docker installation on Ubuntu

**Problem:** Standard Docker installation method doesn't work on some Ubuntu versions.

**Solution:** Use snap installation:
```bash
sudo snap install docker
```

**Note:** If you encounter errors with snap-installed Docker, uninstall and use the [official Docker installation method](https://docs.docker.com/engine/install/ubuntu/).

---

## Platform-Specific Issues

### TTY error on Windows

**Problem:**
```
The input device is not a TTY
```
When running `docker run -it ubuntu bash`.

**Root Cause:** Windows terminal doesn't support TTY by default.

**Solutions:**

**Option 1: Use winpty prefix**
```bash
winpty docker run -it ubuntu bash
```

**Option 2: Create alias**
```bash
# Add to ~/.bashrc or ~/.bash_profile
echo "alias docker='winpty docker'" >> ~/.bashrc
```

### Pip install failures in Docker on Windows

**Problem:**
```
Retrying (Retry(total=4, connect=None, read=None, redirect=None, status=None)) after connection broken by 'NewConnectionError'
```

**Root Cause:** DNS resolution issues in Windows Docker environment.

**Solution:** Use specific DNS setting:
```bash
winpty docker run -it --dns=8.8.8.8 --entrypoint=bash python:3.9
```

### Docker setup on macOS

**Problem:** Need to install Docker on macOS with proper configuration.

**Solutions:**

**Recommended method:**
```bash
# Install Docker Desktop first, then CLI tools
brew install --cask docker
brew install docker docker-compose
```

**Alternative:** Download DMG file directly from Docker website

**Reference:** [Setting up Docker in macOS](https://medium.com/@vivekslair/setting-up-docker-in-macos-ee36d37b3be2)

### Docker on macOS/Windows VM with nested virtualization

**Problem:** Running Docker on macOS/Windows 11 VM on top of Linux with nested virtualization issues.

**Solution:** Enable nested virtualization before starting VM:

**Intel CPU:**
```bash
modprobe -r kvm_intel
modprobe kvm_intel nested=1
```

**AMD CPU:**
```bash
modprobe -r kvm_amd
modprobe kvm_amd nested=1
```

---

## Volume & Mounting Issues

### Permission denied with PostgreSQL volumes on macOS M1

**Problem:**
```
docker: Error response from daemon: error while creating mount source path '/path/to/ny_taxi_postgres_data': 
chown /path/to/ny_taxi_postgres_data: permission denied
```

**Root Cause:** Compatibility issues with Rancher Desktop on macOS M1.

**Solution:**
1. **Stop Rancher Desktop** if currently using it
2. **Install Docker Desktop** with proper configurations
3. **Retry Docker command** with Docker Desktop

### Cannot delete mounted volume folder

**Problem:** Cannot delete folder that was mounted to Docker volume due to write/read protection.

**Root Cause:** Docker creates folders owned by user 999 with strict permissions.

**Solution:** Force removal with sudo:
```bash
sudo rm -rf docker_test/
```

**Command explanation:**
- `rm`: remove command
- `-r`: recursive removal
- `-f`: force removal
- `docker_test/`: folder name

### PostgreSQL permissions error

**Problem:**
```
Could not change permissions of directory '/var/lib/postgresql/data': Operation not permitted
```

**Root Cause:** Permission conflicts with mounted local directory.

**Solution:** Use Docker volumes instead of local directory mounting:

1. **Create Docker volume:**
   ```bash
   docker volume create --name dtc_postgres_volume_local -d local
   ```

2. **Use volume in container:**
   ```bash
   docker run -it \
     -e POSTGRES_USER="root" \
     -e POSTGRES_PASSWORD="root" \
     -e POSTGRES_DB="ny_taxi" \
     -v dtc_postgres_volume_local:/var/lib/postgresql/data \
     -p 5432:5432 \
     postgres:13
   ```

### Invalid reference format on Windows

**Problem:**
```
invalid reference format: repository name must be lowercase
```

**Root Cause:** Windows path formatting issues with spaces or incorrect volume syntax.

**Solutions:**

1. **Move data to path without spaces:**
   - From: `C:/Users/Alexey Grigorev/git/...`
   - To: `C:/git/...`

2. **Try different volume formats:**
   ```bash
   # Various Windows path formats to try
   -v /c/some/path/ny_taxi_postgres_data:/var/lib/postgresql/data
   -v //c/some/path/ny_taxi_postgres_data:/var/lib/postgresql/data
   -v "/c/some/path/ny_taxi_postgres_data:/var/lib/postgresql/data"
   -v "c:\some\path\ny_taxi_postgres_data":/var/lib/postgresql/data
   ```

3. **Use dynamic path (Windows):**
   ```bash
   -v /"$(pwd)"/ny_taxi_postgres_data:/var/lib/postgresql/data
   ```

4. **Use quoted dynamic path (macOS):**
   ```bash
   -v "$(pwd)"/ny_taxi_postgres_data:/var/lib/postgresql/data
   ```

### Empty folder in VS Code (Windows)

**Problem:** `ny_taxi_postgres_data` folder appears empty in VS Code despite containing data.

**Solutions:**

**Option 1: Quote absolute path**
```bash
winpty docker run -it \
  -e POSTGRES_USER="root" \
  -e POSTGRES_PASSWORD="root" \
  -e POSTGRES_DB="ny_taxi" \
  -v "C:\Users\username\path\ny_taxi_postgres_data:/var/lib/postgresql/data" \
  -p 5432:5432 \
  postgres:13
```

**Option 2: Use forward slash at end**
```bash
-v /"$(pwd)"/ny_taxi_postgres_data/:/var/lib/postgresql/data/
```

### Build context permission errors

**Problem:**
```
Error checking context: 'can't stat '<path-to-file>'
```

**Root Cause:** Docker build context includes files with permission issues.

**Solutions:**

**Option 1: Use .dockerignore**
```bash
# Create .dockerignore file
echo "*.log" >> .dockerignore
echo "temp/" >> .dockerignore
echo ".git/" >> .dockerignore
```

**Option 2: Fix permissions**
```bash
# Ubuntu/Linux
sudo chown -R $USER <directory_path>

# Or grant broader permissions
sudo chmod -R 777 <path_to_folder>
```

**Option 3: Reorganize files**
- Move Dockerfile and scripts to subfolder
- Run `docker build` from that subfolder

---

## Container Management

### Container name already in use

**Problem:**
```
Error response from daemon: Conflict. The container name 'pg-database' is already in use by container 'xxx'
```

**Root Cause:** Attempting to create container with name that's already taken.

**Solutions:**

**Option 1: Remove existing container**
```bash
# Stop container if running
docker stop pg-database

# Remove container
docker rm pg-database
```

**Option 2: Start existing container**
```bash
# Instead of docker run, use docker start
docker start pg-database
```

### Stop Docker container

**Problem:** Need to stop a running Docker container.

**Solution:**
```bash
docker stop <container_id>
```

**Find container ID:**
```bash
docker ps
```

---

## Network & Connectivity Issues

### Cannot find Docker network

**Problem:** Need to identify Docker network name for container connectivity.

**Solution:** List all networks:
```bash
docker network ls
```

**Reference:** [Docker network ls documentation](https://docs.docker.com/engine/reference/commandline/network_ls/)

### Hostname translation error with docker-compose

**Problem:**
```
psycopg2.OperationalError: could not translate host name "pgdatabase" to address: Name or service not known
```

**Root Cause:** Network name or container name mismatch in docker-compose setup.

**Solution:**

1. **Check created network:**
   ```bash
   docker-compose up -d
   docker network ls
   ```

2. **Update connection parameters:**
   - Network: `pg-network` → `2docker_default`
   - Container: `pgdatabase` → `2docker-pgdatabase-1`

3. **Use correct names in your scripts**

### Docker image access denied

**Problem:**
```
denied: requested access to the resource is denied
```

**Root Cause:** Typo in image name or attempting to access private repository.

**Solution:**

1. **Check image name spelling:**
   - Incorrect: `dbpage/pgadmin4`
   - Correct: `dpage/pgadmin4`

2. **For private repositories:**
   ```bash
   docker login
   # Enter username and password
   docker pull <private_image>
   ```

**Note:** All Data Engineering Zoomcamp images are public unless explicitly stated.

---

## PostgreSQL Database Issues

### Database directory contains existing database

**Problem:**
```
Database directory appears to contain a database. Database system is shut down
```
And connection fails with:
```
connection failed: server closed the connection unexpectedly
```

**Root Cause:** PostgreSQL container shutdown abnormally, leaving corrupted state.

**Solutions:**

**Option 1: Fresh start (data loss)**
```bash
# Delete data directory
rm -rf ny_taxi_postgres_data/

# Restart container
docker run -it [your_postgres_command]
```

**Option 2: Preserve data**
```bash
# Reset write-ahead log
docker run -it \
  -e POSTGRES_USER="root" \
  -e POSTGRES_PASSWORD="root" \
  -e POSTGRES_DB="ny_taxi" \
  -v $(pwd)/ny_taxi_postgres_data:/var/lib/postgresql/data \
  -p 5432:5432 \
  --network pg-network \
  postgres:13 \
  /bin/bash -c 'gosu postgres pg_resetwal /var/lib/postgresql/data'
```

---

## Build & Development Issues

### Docker build with volume mount errors

**Problem:**
```
Error response from daemon: error while creating buildmount source path '/run/desktop/mnt/host/c/<your path>': 
mkdir /run/desktop/mnt/host/c: file exists
```

**Root Cause:** Running docker command second time with volume mounting.

**Solution:** Remove volume mounting (-v parameter) on subsequent runs:

**First run (with volume):**
```bash
docker run -it \
  -e POSTGRES_USER="root" \
  -e POSTGRES_PASSWORD="root" \
  -e POSTGRES_DB="ny_taxi" \
  -v <your path>:/var/lib/postgresql/data \
  -p 5432:5432 \
  postgres:13
```

**Subsequent runs (without volume):**
```bash
docker run -it \
  -e POSTGRES_USER="root" \
  -e POSTGRES_PASSWORD="root" \
  -e POSTGRES_DB="ny_taxi" \
  -p 5432:5432 \
  postgres:13
```

### Docker build context errors

**Problem:**
```
build error: error checking context: 'can't stat '/home/user/repos/.../ny_taxi_postgres_data'
```

**Root Cause:** PostgreSQL changes directory ownership to user ID 999, preventing access.

**Solutions:**

1. **Build in clean directory:**
   - Create new directory with only Dockerfile and required files
   - Run `docker build` from there

2. **Fix permissions:**
   ```bash
   # Ubuntu/Linux
   sudo chown -R $USER ny_taxi_postgres_data/
   
   # Or broader permissions
sudo chmod -R 777 ny_taxi_postgres_data/
```

**Reference:** [Stack Overflow - Docker build context error](https://stackoverflow.com/questions/41286028/docker-build-error-checking-context-cant-stat-c-users-username-appdata)

### Container error with snap installation

**Problem:**
```
ERRO[0000] error waiting for container: context canceled
```

**Root Cause:** Docker installed via snap may have compatibility issues.

**Solution:**
1. **Check installation method:**
   ```bash
   sudo snap status docker
   ```
2. **If installed via snap:**
   - Uninstall Docker: `sudo snap remove docker`
   - Install via [official method](https://docs.docker.com/engine/install/ubuntu/)

---

## VS Code Integration

### Managing Docker from VS Code

**Problem:** Want to manage Docker containers, images, and networks from VS Code.

**Solution:** Use the official Docker extension:

1. **Install extension:** [Docker Extension for VS Code](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-docker)
2. **Access from left sidebar:** Docker icon
3. **Works with WSL2:** VS Code automatically connects to Linux environment

**Features:**
- Manage containers, images, networks
- Docker Compose project management
- Works seamlessly with WSL2 Docker
