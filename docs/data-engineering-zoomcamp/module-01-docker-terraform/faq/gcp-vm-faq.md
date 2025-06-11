---
title: GCP VM FAQ
description: Frequently asked questions and troubleshooting guide for Google Cloud Platform Virtual Machines in the Data Engineering Zoomcamp
parent: Module 1 FAQ
nav_order: 12
has_children: false
---

# GCP VM FAQ
{: .no_toc }

This guide covers common Google Cloud Platform Virtual Machine issues and their solutions for the Data Engineering Zoomcamp, including performance optimization, connection problems, and configuration management.
{: .fs-6 .fw-300 }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## VM Performance & Diagnostics

### Diagnosing and fixing slow VM performance

**Problem:** VM becomes slow during course work, affecting productivity.

**Root Cause:** Insufficient resources, processes consuming excessive CPU/memory, or disk space issues.

**Solution:** Use diagnostic commands to identify and resolve performance issues.

**Recommended VM specs:** Start with a 60GB machine instead of 30GB to avoid space constraints.

**Diagnostic Commands:**

**System Resource Usage:**
```bash
# Real-time system monitoring
top
htop  # More user-friendly alternative

# Memory usage
free -h

# Disk space by filesystem
df -h

# Directory-specific disk usage
du -h <directory>
```

**Running Processes:**
```bash
# All process information
ps aux
```

**Network Information:**
```bash
# Network interface details
ifconfig
ip addr show

# Active network connections
netstat -tuln
```

**Hardware Information:**
```bash
# CPU information
lscpu

# Block devices info
lsblk

# Complete hardware configuration
lshw
```

**User and Permissions:**
```bash
# Logged-in user activities
who

# User process information
w
```

**Package Management:**
```bash
# List all installed packages
apt list --installed
```

---

## VM Management & Resources

### GCP no resources available for VM

**Problem:** GCP shows no resources available to start your Virtual Machine.

**Root Cause:** Resource constraints in the current zone/region.

**Solution:** Create VM from image in different location:

1. **Create VM image:**
   - Click on your VM in GCP Console
   - Create an image of your current VM

2. **Create new VM instance:**
   - Use the created image as base
   - Change the location/zone in settings
   - Select a region with available resources

3. **Update configurations:**
   - Update SSH config with new IP address
   - Verify all services work correctly

### VM necessity and limitations

**Problem:** Uncertainty about whether to use GCP VM or local environment.

**Solution:** GCP VM is **not mandatory** but highly recommended.

**Why GCP VM exists:**
- Many students encounter environment configuration issues
- Provides consistent, clean environment for all students
- Avoids local dependency conflicts

**You can use local environment if:**
- You're comfortable with troubleshooting
- Your local setup works reliably
- You prefer working locally

**Limitation of GCP VM:**
- GitHub repos are cloned via HTTPS
- Cannot directly commit changes even if you're the repo owner
- Need to configure Git authentication separately

---

## SSH & Connection Issues

### SSH directory permission denied

**Problem:**
```bash
User1@DESKTOP-PD6UM8A MINGW64 /
$ mkdir .ssh
mkdir: cannot create directory '.ssh': Permission denied
```

**Root Cause:** Attempting to create directory in root folder (/) instead of home directory.

**Solution:** Create the `.ssh` directory in your home directory:
```bash
# Navigate to home directory first
cd ~

# Then create .ssh directory
mkdir .ssh

# Set proper permissions
chmod 700 ~/.ssh
```

**Note:** This is a Permission Denied (EACCES) error - always use `~` for home directory operations.

### VM connection timeout

**Problem:** VM connection times out after working fine previously.

**Root Cause:** VM was restarted and may have received a new IP address.

**Solution:** Update SSH configuration with current IP:

1. **Start your VM** in GCP Console
2. **Copy the External IP** from VM details
3. **Update SSH config file:**
   ```bash
   cd ~/.ssh
   code config  # or nano config
   ```
4. **Update HostName** with the new IP address
5. **Test connection:**
   ```bash
   ssh vm-name  # Replace with your host alias
   ```

### "No route to host" error

**Problem:**
```
connect to host port 22 no route to host
```

**Root Cause:** Firewall blocking SSH connections on port 22.

**Solution:** Configure VM firewall to allow SSH:

1. **Edit your VM** in GCP Console
2. **Go to Automation section**
3. **Add startup script:**
   ```bash
   #!/bin/bash
   sudo ufw allow ssh
   ```
4. **Stop and restart your VM**
5. **Wait for startup script to complete** (2-3 minutes)
6. **Test SSH connection**

---

## File Permissions & Access

### VS Code file save permission error

**Problem:**
```
Failed to save '<file>': Unable to write file 'vscode-remote://ssh-remote+de-zoomcamp/home/<user>/...' 
(NoPermissions (FileSystemError): Error: EACCES: permission denied, open '/home/<user>/...')
```

**Root Cause:** File ownership issues - files may be owned by root or another user.

**Solution:** Change file ownership to your user:
```bash
# Change ownership of specific directory
sudo chown -R <username> <path_to_directory>

# Example for typical course directory
sudo chown -R $USER ~/data_engineering_course

# Alternatively, use your username explicitly
sudo chown -R myusername ~/data_engineering_course
```

**Prevention:** Avoid using `sudo` when creating files unless absolutely necessary.

---

## Port Forwarding & Network Access

### Port forwarding without VS Code

**Problem:** Need to access services (Jupyter, pgAdmin, PostgreSQL) running on VM without using VS Code's built-in port forwarding.

**Solution:** Use SSH port forwarding with command line.

**Setup services on VM:**
```bash
# Start services on VM
docker-compose up -d
jupyter notebook --ip=0.0.0.0 --port=8888 --allow-root
```

**Port forwarding commands:**

**Single service forwarding:**
```bash
# PostgreSQL only
ssh -i ~/.ssh/gcp -L 5432:localhost:5432 username@external_ip_of_vm

# pgAdmin only  
ssh -i ~/.ssh/gcp -L 8080:localhost:8080 username@external_ip_of_vm

# Jupyter only
ssh -i ~/.ssh/gcp -L 8888:localhost:8888 username@external_ip_of_vm
```

**Multiple services forwarding:**
```bash
# PostgreSQL + pgAdmin
ssh -i ~/.ssh/gcp -L 5432:localhost:5432 -L 8080:localhost:8080 username@external_ip_of_vm

# All services (PostgreSQL + pgAdmin + Jupyter)
ssh -i ~/.ssh/gcp -L 5432:localhost:5432 -L 8080:localhost:8080 -L 8888:localhost:8888 username@external_ip_of_vm
```

**Access services locally:**
- **pgAdmin:** `http://localhost:8080`
- **Jupyter:** `http://localhost:8888` (may require token from VM logs)
- **PostgreSQL:** Connect to `localhost:5432` from local database clients

**Getting Jupyter token (if needed):**
```bash
# On VM, check Jupyter logs for token
docker logs <jupyter_container_name>
# Or check terminal output where Jupyter was started
```

