---
title: PGCLI FAQ
description: Frequently asked questions and troubleshooting guide for PGCLI PostgreSQL command-line interface in the Data Engineering Zoomcamp
parent: Module 1 FAQ
nav_order: 6
has_children: false
---

# PGCLI FAQ
{: .no_toc }

This guide covers common PGCLI issues and their solutions for the Data Engineering Zoomcamp, including connection problems, authentication, and installation issues.
{: .fs-6 .fw-300 }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## Connection Issues

### Connection failed error

**Problem:**
```
connection failed: :1), port 5432 failed: could not receive data from server: 
Connection refused could not send SSL negotiation packet: Connection refused
```

**Root Cause:** Connection attempting to use socket instead of TCP/IP.

**Solution:** Specify the IP address directly instead of using localhost:
```bash
pgcli -h 127.0.0.1 -p 5432 -u root -d ny_taxi
```

### Running PGCLI in Docker vs locally

**Problem:** Uncertainty about whether to run PGCLI inside a Docker container.

**Solution:** **No**, you don't need to run PGCLI inside another Docker container. Since PostgreSQL port 5432 is mapped to your computer's port 5432, you can access the database via PGCLI directly from your local system.

**Alternative - Docker container approach:**
If you prefer to run PGCLI in a container or have local installation issues:
```bash
docker run -it --rm --network pg-network ai2ys/dockerized-pgcli:4.0.1 
# Inside container:
pgcli -h pg-database -U root -p 5432 -d ny_taxi
```

This connects to:
- Network: `pg-network`
- Host: `pg-database` 
- User: `root`
- Port: `5432`
- Database: `ny_taxi`

---

## Authentication & Permissions

### Password authentication failed with existing Postgres

**Problem:**
```
FATAL: password authentication failed for user "root"
```

**Root Cause:** Local PostgreSQL installation conflicting with Docker container.

**Solutions for macOS:**

**Diagnose the issue:**
```bash
# Check applications using port 5432
lsof -i :5432

# List running postgres services
launchctl list | grep postgres
```

**Stop local PostgreSQL service:**
```bash
launchctl unload -w ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist
```

**Start local PostgreSQL service:**
```bash
launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist
```

**Alternative solution:** Change Docker port mapping from `5432:5432` to `5431:5432` to avoid conflicts.

**Reference:** Course video "1.4.2 - Port Mapping and Networks in Docker"

### Permission denied error

**Problem:**
```
PermissionError: [Errno 13] Permission denied: '/Users/vray/.config/pgcli'

Traceback (most recent call last):
  File "/opt/anaconda3/bin/pgcli", line 8, in <module>
    sys.exit(cli())
  [... detailed traceback ...]
  File "/opt/anaconda3/lib/python3.9/code", line 225, in makedirs
    mkdir(name, mode)
PermissionError: [Errno 13] Permission denied: '/Users/vray/.config/pgcli'
```

**Root Cause:** User lacks permissions to access/modify PGCLI configuration directory.

**Solutions:**

**Option 1: Fix permissions**
```bash
# Check current permissions
ls -l /Users/your_username/.config/pgcli

# Change ownership (replace 'your_username' with your actual username)
sudo chown -R your_username /Users/your_username/.config
   ```

**Option 2: Clean installation**
- Install PGCLI without sudo, preferably using conda/anaconda
- If conda install gets stuck at "Solving environment", see: [Stack Overflow solution](https://stackoverflow.com/questions/63734508/stuck-at-solving-environment-on-anaconda)

---

## Installation & Environment Issues

### Command not found error

**Problem:**
```bash
# Git Bash
bash: pgcli: command not found

# Windows Terminal  
pgcli: The term 'pgcli' is not recognized...
```

**Root Cause:** Python Scripts directory containing PGCLI isn't in your system PATH.

**Solution:**

1. **Find installation location:**
   ```bash
   pip list -v
   ```

2. **Locate the base path** from output (example):
   ```
   C:\Users\...\AppData\Roaming\Python\Python39\site-packages
   ```

3. **Convert to Scripts path** by replacing `site-packages` with `Scripts`:
   ```
   C:\Users\...\AppData\Roaming\Python\Python39\Scripts
   ```

4. **Add to system PATH:**
   - Open System Properties → Environment Variables
   - Find "Path" in System Variables
   - Add the Scripts directory path

**Note:** Python might be in different locations (e.g., `c:\python310\lib\site-packages` → `c:\python310\lib\Scripts`)

**Reference:** [Stack Overflow solution](https://stackoverflow.com/a/68233660)

### No pq wrapper available error

**Problem:**
```
ImportError: no pq wrapper available
```

**Additional symptoms:**
- Couldn't import `\dt`
- `No module named 'psycopg_c'`
- `No module named 'psycopg_binary'`
- `libpq library not found`

**Root Cause:** Missing or incompatible Python/PostgreSQL dependencies.

**Solution:**

1. **Check Python version** (must be 3.9+):
   ```bash
   python -V  # Capital V required
   ```

2. **Create new environment if Python < 3.9:**
   ```bash
   conda create --name de-zoomcamp python=3.9
   conda activate de-zoomcamp
   ```

3. **Install PostgreSQL libraries:**
   ```bash
   pip install psycopg2-binary
   pip install psycopg_binary
   ```

4. **If issues persist:**
   ```bash
   pip install --upgrade pgcli
   ```

5. **Alternative - conda installation:**
   ```bash
   conda install pgcli
   ```

### Persistent authentication issues on Windows/WSL

**Problem:** Password authentication continues to fail despite correct credentials.

**Root Cause:** Conflicting local PostgreSQL installations.

**Solutions:**

**For Windows:**
- Stop the PostgreSQL service through Services management console

**For WSL users:**
1. Completely uninstall PostgreSQL 12 from Windows
2. Install PostgreSQL client on WSL:
   ```bash
     sudo apt install postgresql-client-common postgresql-client libpq-dev
     ```

---

## Usage & Commands

### Password prompt issues

**Problem:** PGCLI stuck on password prompt in Bash.

**Solutions:**

**Option 1: Use winpty (Windows)**
```bash
winpty pgcli -h localhost -p 5432 -u root -d ny_taxi
```

**Option 2: Use Windows Terminal**
- Switch from Git Bash to Windows Terminal

**Option 3: Use VS Code integrated terminal**
- Use VS Code's built-in terminal instead

### Column names with capital letters not recognized

**Problem:** Column names like `PULocationID` are not being recognized.

**Root Cause:** PostgreSQL treats unquoted identifiers as case-insensitive.

**Solution:** Use double quotes for case-sensitive column names:
```sql
-- Won't work
SELECT PULocationID FROM trips;

-- Will work  
SELECT "PULocationID" FROM trips;
```

**Reference:** [PostgreSQL Documentation - Identifiers](https://www.postgresql.org/docs/current/sql-syntax-lexical.html#SQL-SYNTAX-IDENTIFIERS)

---

## Version & Compatibility Issues

### Column relhasoids does not exist error

**Problem:**
```
c.relhasoids does not exist
```
When running `\d <database_name>` command.

**Root Cause:** Version incompatibility between PGCLI and PostgreSQL.

**Solution:**
1. Uninstall PGCLI:
   ```bash
   pip uninstall pgcli
   ```
2. Reinstall PGCLI:
   ```bash
   pip install pgcli
   ```
3. Restart your system

**Alternative:** Update to latest PGCLI version:
```bash
pip install --upgrade pgcli
```
