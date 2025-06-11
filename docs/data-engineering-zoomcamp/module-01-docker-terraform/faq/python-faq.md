---
title: Python FAQ
description: Frequently asked questions and troubleshooting guide for Python-related issues in the Data Engineering Zoomcamp
parent: Module 1 FAQ
nav_order: 10
has_children: false
---

# Python FAQ
{: .no_toc }

This guide covers common Python issues and their solutions for the Data Engineering Zoomcamp, including environment setup, data processing, and database connections.
{: .fs-6 .fw-300 }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## Environment & Dependencies

### ModuleNotFoundError for pysqlite2

**Problem:**
```
ImportError: DLL load failed while importing _sqlite3: The specified module could not be found. 
ModuleNotFoundError: No module named 'pysqlite2'
```

**Root Cause:** Missing `sqlite3.dll` in the Anaconda DLLs path.

**Solution:** Copy the missing DLL file:
1. Navigate to `\Anaconda3\Library\bin`
2. Copy `sqlite3.dll`
3. Paste it to `.\Anaconda\Dlls\`

### ModuleNotFoundError for psycopg2

**Problem:**
```
ModuleNotFoundError: No module named 'psycopg2'
```

**Root Cause:** The psycopg2 PostgreSQL adapter is not installed.

**Solution:** Install psycopg2:
```bash
# Using pip
pip install psycopg2-binary

# Using conda
conda install psycopg2
```

### TypeAliasType import error with SQLAlchemy

**Problem:**
```
ImportError: cannot import name 'TypeAliasType' from 'typing_extensions'
```

**Root Cause:** Outdated `typing_extensions` module (needs version >= 4.6.0).

**Solution:** Update typing_extensions:
```bash
# Using pip
pip install --upgrade typing_extensions

# Using conda
conda update typing_extensions
```

---

## Data Ingestion & Processing

### Missing 100,000 records in data ingestion

**Problem:** First chunk of 100,000 records missing when re-running the Jupyter notebook for NY Taxi Data ingestion.

**Root Cause:** There's a call to the iterator (`df=next(df_iter)`) before the while loop, causing the loop to start with the second chunk.

**Solution:** Remove the premature iterator call:
- Delete the cell containing `df=next(df_iter)` that appears before the while loop
- The first call to `next(df_iter)` should be **within** the while loop

**Note:** This notebook is for testing purposes and wasn't designed to run top-to-bottom. The logic is properly organized in the final `.py` pipeline file.

### Parsing dates when reading CSV files

**Problem:** Need to convert string columns to datetime after reading CSV.

**Solution:** Use the `parse_dates` parameter in `pd.read_csv()`:
```python
import pandas as pd

df = pd.read_csv(
    'yellow_tripdata_2021-01.csv', 
    nrows=100, 
    parse_dates=['tpep_pickup_datetime', 'tpep_dropoff_datetime']
)
```

The `parse_dates` parameter accepts:
- List of column names
- List of column indices
- Dictionary for custom parsing

---

## File Handling

### Reading gzipped CSV files

**Problem:** Unable to read `.csv.gz` files with Pandas.

**Solution:** Pandas can read gzipped CSV files directly:
```python
df = pd.read_csv(
    'file.csv.gz',
    compression='gzip',
    low_memory=False
)
```

**Alternative:** Let Pandas auto-detect compression:
```python
df = pd.read_csv('file.csv.gz')  # Auto-detects gzip compression
```

### Iterating through Parquet files

**Problem:** Parquet files don't have a `chunksize` parameter for batch processing.

**Root Cause:** Parquet format requires different iteration methods than CSV.

**Solution:** Use PyArrow for batch processing:
```python
import pyarrow.parquet as pq
from time import time

# Setup
output_name = "https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2021-01.parquet"
parquet_file = pq.ParquetFile(output_name)
parquet_size = parquet_file.metadata.num_rows
table_name = "yellow_taxi_schema"

# Clear table if exists (create schema)
pq.read_table(output_name).to_pandas().head(n=0).to_sql(
    name=table_name, 
    con=engine, 
    if_exists='replace'
)

# Process in batches (default/max batch size: 65536)
index = 65536
for i in parquet_file.iter_batches(use_threads=True):
    t_start = time()
    print(f'Ingesting {index} out of {parquet_size} rows ({index / parquet_size:.0%})')
    
    i.to_pandas().to_sql(
        name=table_name, 
        con=engine, 
        if_exists='append'
    )
    
    index += 65536
    t_end = time()
    print(f'\t- it took %.1f seconds' % (t_end - t_start))
```

### Downloading data with curl

**Problem:** Python failing to ingest data using curl commands.

**Solution:** Use the correct curl command format:
```python
import os

# Correct format with -L flag for redirects and -O for output
os.system(f"curl -LO {url} -o {csv_name}")
```

**Flags explained:**
- `-L`: Follow redirects
- `-O`: Write output to file with remote name
- `-o`: Specify output filename

---

## Database & SQLAlchemy Issues

### TypeError with SQLAlchemy create_engine

**Problem:**
```
TypeError: 'module' object is not callable
```

**Root Cause:** Incorrect connection string format or import issue.

**Solution:** Use the correct PostgreSQL connection string:
```python
from sqlalchemy import create_engine

# Correct format
conn_string = "postgresql+psycopg://root:root@localhost:5432/ny_taxi"
engine = create_engine(conn_string)
```

### NoSuchModuleError with PostgreSQL dialect

**Problem:**
```
NoSuchModuleError: Can't load plugin: sqlalchemy.dialects:postgresql.psycopg
```

**Root Cause:** Conflicting virtual environments or missing dependencies.

**Solution:** Clean environment setup:
1. Remove existing virtual environment:
   ```bash
   rm -rf .venv
   ```
2. Create new conda environment:
   ```bash
   conda create -n pyingest python=3.12
   conda activate pyingest
   ```
3. Install required dependencies:
   ```bash
   pip install pandas sqlalchemy psycopg2-binary jupyterlab
   ```
4. Use correct connection string:
   ```python
   connection_string = f"postgresql+psycopg2://{db_user}:{db_password}@{db_host}:{db_port}/{db_name}"
   ```

### OptionEngine error with read_sql_query

**Problem:**
```
'OptionEngine' object has no attribute 'execute'
```

**Root Cause:** SQLAlchemy version compatibility issue with Pandas.

**Solution:** Update packages and use `text()` wrapper:
```python
from sqlalchemy import text
import pandas as pd

# Update packages first
# pip install --upgrade sqlalchemy pandas

# Wrap queries with text()
query = text("""SELECT * FROM tbl""")
df = pd.read_sql_query(query, conn)
```
