---
title: Miscellaneous FAQ
description: Frequently asked questions covering various topics and general troubleshooting for the Data Engineering Zoomcamp
parent: Module 1 FAQ
nav_order: 14
has_children: false
---

# Miscellaneous FAQ
{: .no_toc }

This guide covers various common issues and their solutions for the Data Engineering Zoomcamp, including database queries, environment setup, development tools, and general troubleshooting.
{: .fs-6 .fw-300 }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## Database & SQL Issues

### Column not found error with uppercase names

**Problem:**
```sql
SELECT * FROM zones_taxi WHERE Zone='Astoria Zone';
-- Error: Column Zone doesn't exist
```

**Root Cause:** PostgreSQL requires quotes around column names that contain uppercase letters.

**Solutions:**

**Option 1: Use quotes around column names**
```sql
SELECT * FROM zones AS z WHERE z."Zone" = 'Astoria';
```

**Option 2: Convert columns to lowercase during data loading**
```python
df = pd.read_csv('taxi_zone_lookup.csv')
df.columns = df.columns.str.lower()
```

**Note:** In the actual dataset, the zone is named 'Astoria' not 'Astoria Zone'.

---

## Network & Connectivity Issues

### curl host resolution error

**Problem:**
```bash
curl: (6) Could not resolve host: output.csv
```

**Root Cause:** Incorrect curl syntax, particularly common on macOS.

**Solution:** Use the correct curl syntax:
```python
os.system(f"curl {url} --output {csv_name}")
```

### SSH connection failures

**Problem:**
```bash
ssh: Could not resolve hostname linux: Name or service not known
```

**Root Cause:** SSH can't find your host configuration file.

**Solution:** Ensure your SSH config file is properly located at:
- **Linux/macOS:** `~/.ssh/config`
- **Windows:** `C:\Users\Username\.ssh\config`

### VS Code SSH permission denied

**Problem:**
```
Could not establish connection to "de-zoomcamp": Permission denied (publickey).
```

**Root Cause:** SSH key path issues on Windows when using VS Code.

**Solution for Windows users:**

1. **Copy SSH folder:** Copy the `.ssh` folder from Linux path to Windows
2. **Update config file:** Use Windows path format:
   ```
   IdentityFile C:\Users\<username>\.ssh\gcp
   ```
   Instead of:
   ```
   IdentityFile ~/.ssh/gcp
   ```
3. **Check key format:** Ensure the private key file has an extra newline at the end

---

## Python & Environment Setup

### pip command not recognized

**Problem:**
```
'pip' is not recognized as an internal or external command, operable program or batch file.
```

**Root Cause:** Anaconda's Python is not in your system PATH.

**Solutions by Operating System:**

**Linux and macOS:**
```bash
# Find Anaconda path (typically ~/anaconda3 or ~/opt/anaconda3)
export PATH="/path/to/anaconda3/bin:$PATH"

# Make permanent by adding to shell profile
echo 'export PATH="/path/to/anaconda3/bin:$PATH"' >> ~/.bashrc  # Linux
echo 'export PATH="/path/to/anaconda3/bin:$PATH"' >> ~/.bash_profile  # macOS
```

**Windows with Git Bash:**
```bash
# Add to PATH (adjust username as needed)
export PATH="/c/Users/[YourUsername]/Anaconda3/:/c/Users/[YourUsername]/Anaconda3/Scripts/:$PATH"

# Add to .bashrc and refresh
echo 'export PATH="/c/Users/[YourUsername]/Anaconda3/:/c/Users/[YourUsername]/Anaconda3/Scripts/:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

**Windows (System Settings):**
1. Right-click 'This PC' → 'Properties'
2. Click 'Advanced system settings'
3. Click 'Environment Variables'
4. Edit 'Path' in 'System variables'
5. Add these paths:
   - `C:\Users\[YourUsername]\Anaconda3`
   - `C:\Users\[YourUsername]\Anaconda3\Scripts`
6. Click 'OK' to apply changes

### Generating pip requirements from Anaconda

**Problem:** Need to create a `requirements.txt` file from Anaconda environment.

**Solution:**
```bash
# Install pip in conda environment
conda install pip

# Generate requirements file
pip list --format=freeze > requirements.txt
```

**Note:** 
- Don't use `conda list -e > requirements.txt` (won't work with pip)
- Don't use `pip freeze > requirements.txt` (may include incorrect paths)

---

## Docker Issues

### Address already in use error

**Problem:**
```
Error: error starting userland proxy: listen tcp4 0.0.0.0:8080: bind: address already in use
```

**Root Cause:** Port 8080 is already being used by another process.

**Solution:** Kill the process using the port:
```bash
sudo kill -9 `sudo lsof -t -i:8080`
```

**General format for any port:**
```bash
sudo kill -9 `sudo lsof -t -i:<port_number>`
```

### Docker permission denied errors

**Problem:**
```
Error: error response from daemon: cannot stop container: 
permission denied
```

**Root Cause:** Docker service permissions issue.

**Solution:** Restart Docker services:
```bash
sudo systemctl restart docker.socket docker.service
```

### Docker build context errors

**Problem:**
```
Error checking context: 'can't stat '<path-to-file>'
```

**Root Cause:** Docker build context includes files with permission issues.

**Solutions:**

**Option 1: Use .dockerignore**
Create a `.dockerignore` file to exclude problematic files:
```
# .dockerignore
*.log
temp/
.git/
```

**Option 2: Reorganize files**
- Move Dockerfile and related scripts to a subfolder
- Run `docker build` from that subfolder

### Docker Compose environment variable formatting

**Problem:** Environment variables not working in `docker-compose.yml`.

**Root Cause:** Incorrect formatting with spaces around equals sign.

**Incorrect formats:**
```yaml
environment:
  - PGADMIN_DEFAULT_EMAIL = admin@admin.com  # Spaces around =
  - PGADMIN_DEFAULT_PASSWORD = root
```

```yaml
environment:
  - PGADMIN_DEFAULT_EMAIL= admin@admin.com  # Space after =
  - PGADMIN_DEFAULT_PASSWORD=root
```

**Correct format:**
```yaml
environment:
  - PGADMIN_DEFAULT_EMAIL=admin@admin.com
  - PGADMIN_DEFAULT_PASSWORD=root
```

---

## Development Tools

### Jupyter Notebook installation and usage

**Problem:** Need to install and use Jupyter Notebook.

**Solution:**

**Install and launch:**
```bash
pip install jupyter
python3 -m notebook
```

**Convert notebook to Python script:**
```bash
pip install nbconvert --upgrade
python3 -m jupyter nbconvert --to=script upload-data.ipynb
```

### Alternative notebook conversion with jupytext

**Problem:** `nbconvert` giving errors during notebook conversion.

**Solution:** Use jupytext as an alternative:

**Install:**
```bash
pip install jupytext
```

**Convert:**
```bash
jupytext --to py <your_notebook.ipynb>
```

**Advantages of jupytext:**
- More reliable conversion
- Better handling of markdown cells
- Preserves notebook structure in comments

