---
title: WSL FAQ
description: Frequently asked questions and troubleshooting guide for Windows Subsystem for Linux (WSL) issues in the Data Engineering Zoomcamp
parent: Module 1 FAQ
nav_order: 8
has_children: false
---

# WSL FAQ
{: .no_toc }

This guide covers common WSL (Windows Subsystem for Linux) issues and their solutions for the Data Engineering Zoomcamp.
{: .fs-6 .fw-300 }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}


## Docker-Related Issues

### WSL Docker directory permissions error with initdb

**Problem:** Permission conflicts when running Docker containers with databases like PostgreSQL.

**Root Cause:** WSL and Windows manage permissions differently, causing conflicts when using the Windows file system rather than the WSL file system.

**Solution:** Use Docker volumes instead of bind mounts. This approach:
- Stores persistent data properly without file transfer conflicts
- Eliminates permission issues between WSL and Windows
- Provides better volume management
- Note: The `user:` parameter is not necessary when using Docker volumes, but is required for local drive mounts

**Example docker-compose.yaml:**

```yaml
services:
  postgres:
    image: postgres:15-alpine
    container_name: postgres
    user: "0:0"
    environment:
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=postgres
      - POSTGRES_DB=ny_taxi
    volumes:
      - "pg-data:/var/lib/postgresql/data"
    ports:
      - "5432:5432"
    networks:
      - pg-network

  pgadmin:
    image: dpage/pgadmin4
    container_name: pgadmin
    user: "${UID}:${GID}"
    environment:
      - PGADMIN_DEFAULT_EMAIL=email@some-site.com
      - PGADMIN_DEFAULT_PASSWORD=pgadmin
    volumes:
      - "pg-admin:/var/lib/pgadmin"
    ports:
      - "8080:80"
    networks:
      - pg-network

networks:
  pg-network:
    name: pg-network

volumes:
  pg-data:
    name: ingest_pgdata
  pg-admin:
    name: ingest_pgadmin
```

## System & Resource Issues

### WSL integration error with exit code 1

**Problem:** "WSL integration with distro Ubuntu unexpectedly stopped with exit code 1" appears after system restart.

**Solutions:**

**Option 1: Fix DNS Issue**
1. Disable DNS cache service:
   ```cmd
   reg add "HKLM\System\CurrentControlSet\Services\Dnscache" /v "Start" /t REG_DWORD /d "4" /f
   ```
2. Restart your computer
3. Re-enable DNS cache service:
   ```cmd
   reg add "HKLM\System\CurrentControlSet\Services\Dnscache" /v "Start" /t REG_DWORD /d "2" /f
   ```
4. Restart your system again

**Option 2: Switch Docker Container Mode**
- Right-click on the Docker Desktop icon (system tray)
- Select "Switch to Linux containers"

### Insufficient system resources error

**Problem:** "Insufficient system resources exist to complete the requested service" error in WSL.

**Root Cause:** Outdated system components.

**Solution:**

**Update Windows Terminal:**
1. Open Microsoft Store
2. Go to your library of installed apps
3. Find and update Windows Terminal
4. Restart your system

**Update Windows Security:**
1. Go to Windows Update settings
2. Check for pending updates, especially security updates
3. Install all available updates
4. Restart your system after installation completes

## SSH & Networking Issues

### WSL SSH permissions too open

**Problem:** SSH key permissions errors when connecting to GCP VM through WSL2.

**Root Cause:** WSL2 may not be looking for SSH keys in the correct directory or permissions are not set properly.

**Solutions:**

**Option 1: Use sudo**
```bash
sudo ssh -i gcp [username]@[external-ip]
```

**Option 2: Fix key permissions**
```bash
chmod 600 gcp
```

**Option 3: Copy SSH configuration to WSL2**
```bash
cd ~
mkdir .ssh
cp -r /mnt/c/Users/YourUsername/.ssh/* ~/.ssh/
chmod 700 ~/.ssh
chmod 600 ~/.ssh/*
```

### Could not resolve host name error

**Problem:** SSH cannot resolve hostnames when connecting from WSL2.

**Root Cause:** WSL2 is not referencing the correct SSH config path from Windows.

**Solution:**

1. Create SSH directory in WSL2 home:
   ```bash
   cd ~
   mkdir .ssh
   ```

2. Create SSH config file:
   ```bash
   nano ~/.ssh/config
   ```

3. Add the following configuration:
   ```
   Host your-vm-name
       HostName [GCP-VM-external-IP]
       User [username]
       IdentityFile ~/.ssh/[private-key-filename]
   ```

4. Set proper permissions:
   ```bash
   chmod 600 ~/.ssh/config
   chmod 600 ~/.ssh/[private-key-filename]
   ```