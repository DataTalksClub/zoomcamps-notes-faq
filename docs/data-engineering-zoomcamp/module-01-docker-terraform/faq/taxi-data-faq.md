---
title: Taxi Data FAQ
description: Frequently asked questions and troubleshooting guide for NYC Taxi data handling in the Data Engineering Zoomcamp
parent: Module 1 FAQ
nav_order: 2
has_children: false
---

# Taxi Data FAQ
{: .no_toc }

This guide covers common issues and solutions when working with NYC Taxi data in the Data Engineering Zoomcamp, including download, format handling, and data processing.
{: .fs-6 .fw-300 }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## Data Download Issues

### 403 Forbidden error from TLC website

**Problem:** Getting a 403 Forbidden error when trying to download 2021 data from the official [TLC website](https://www1.nyc.gov/site/tlc/about/tlc-trip-record-data.page).

**Root Cause:** The official TLC website may have access restrictions or temporary issues.

**Solution:** Use our backup data source:
- **Backup URL:** [Yellow Taxi Data 2021-01](https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/yellow_tripdata_2021-01.csv.gz)
- **Important:** Make sure to [unzip the "gz" file](https://linuxize.com/post/how-to-unzip-gz-file/) properly
- **Note:** The standard `unzip` command won't work for `.gz` files - use `gunzip` instead

---

## Data Format Handling

### Handling CSV.GZ compressed files

**Problem:** Taxi data files are available as `*.csv.gz` format and need proper handling.

**Root Cause:** Compressed files require special handling in data processing scripts.

**Solution:** Use dynamic filename parsing from URL:

**Original approach (problematic):**
```python
csv_name = "output.csv"  # This won't work correctly with .csv.gz files
```

**Improved approach:**
```python
# Parse filename from URL
csv_name = url.split("/")[-1]  # Gets "yellow_tripdata_2021-01.csv.gz"
```

**Why this works:**
- The URL structure: `https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/yellow_tripdata_2021-01.csv.gz`
- Pandas `read_csv()` function can read `.csv.gz` files directly
- No manual decompression needed in the script

### Working with Parquet format data

**Problem:** Need to process taxi data available in Parquet format.

**Solutions:**

**Option 1: Convert to CSV first**
```bash
# Decompress parquet file
gunzip green_tripdata_2019-09.csv.gz
# Then use pandas normally
pd.read_csv('green_tripdata_2019-09.csv')
```

**Option 2: Handle Parquet directly in script**
Modify your `ingest_data.py` script:
```python
def main(params):
    # ... existing code ...
    
    parquet_name = 'output.parquet'
    
    # Download parquet file
    os.system(f"wget {url} -O {parquet_name}")
    
    # Convert parquet to CSV
    df = pd.read_parquet(parquet_name)
    df.to_csv(csv_name, index=False)
    
    # Continue with normal processing...
```

---

## Tools & Dependencies

### wget command not recognized

**Problem:** "wget is not recognized as an internal or external command" error.

**Root Cause:** wget is not installed or not in your system PATH.

**Solutions by Operating System:**

**Ubuntu/Debian:**
```bash
sudo apt-get install wget
```

**MacOS:**
```bash
brew install wget
```

**Windows (Multiple Options):**

**Option 1: Using Chocolatey**
```cmd
choco install wget
```

**Option 2: Manual Installation**
1. Download binary from [GnuWin32](https://gnuwin32.sourceforge.net/packages/wget.htm)
2. Add to your system PATH

**Option 3: EternallyBored.org**
1. Download the latest wget binary from eternallybored.org
2. Extract using 7-zip if Windows utility fails
3. Rename `wget64.exe` to `wget.exe` if necessary
4. Move to `Git\mingw64\bin\` directory

**Alternative Solutions:**

**Use Python wget library:**
```bash
pip install wget
python -m wget <url>
```

**Use Python requests library:**
```bash
pip install requests
# Then use requests in your Python script
```

**Manual download:**
- Download files directly through your web browser

### Certificate verification error on MacOS

**Problem:** "ERROR: cannot verify website certificate" when using wget on MacOS.

**Solutions:**

**Option 1: Use Python wget**
```bash
python -m wget <url>
```

**Option 2: Skip certificate check**
```bash
wget <website_url> --no-check-certificate
```

**For Jupyter Notebooks:**
```python
!wget <website_url> --no-check-certificate
```

---

## Data Reference & Documentation

### NYC Taxi data dictionaries

**Problem:** Need to understand the structure and meaning of taxi data columns.

**Solution:** Official data dictionaries are available:

**Yellow Taxi Trips:**
- [Yellow Taxi Data Dictionary (PDF)](https://www1.nyc.gov/assets/tlc/downloads/pdf/data_dictionary_trip_records_yellow.pdf)

**Green Taxi Trips:**
- [Green Taxi Data Dictionary (PDF)](https://www1.nyc.gov/assets/tlc/downloads/pdf/data_dictionary_trip_records_green.pdf)

These documents contain:
- Column definitions and descriptions  
- Data types and formats
- Valid value ranges
- Historical changes to the schema
