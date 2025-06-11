---
title: FAQ
parent: Workshop dltHub
nav_order: 2
---

# Data Ingestion with dlt FAQ

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

## Workshop 1 \- dlthub   Which set-up should I use for my dlt homework?

Technically you can use any code editor or Jupyter Notebook, as long as you can run dbt and answer the homework questions. A lot of code is provided by the instructor, on the homework page to give you a headstart in the right direction: [https://github.com/DataTalksClub/data-engineering-zoomcamp/blob/main/cohorts/2025/workshops/dlt/dlt\_homework.md](https://github.com/DataTalksClub/data-engineering-zoomcamp/blob/main/cohorts/2025/workshops/dlt/dlt_homework.md)

The most practical way is to use the provided Colabs Jupyter notebook called ‘dlt \- Homework.ipynb’ which you can find here below, since all of the provided code is applicable in the Colabs set-up: [https://colab.research.google.com/drive/1plqdl33K\_HkVx0E0nGJrrkEUssStQsW7\#scrollTo=BtsSxtFfXQs3](https://colab.research.google.com/drive/1plqdl33K_HkVx0E0nGJrrkEUssStQsW7#scrollTo=BtsSxtFfXQs3)

## How do I install the necessary dependencies to run the code?

	Answer: To run the provided code, ensure that the 'dlt\[duckdb\]' package is installed. You can do this by executing the provided installation command in a jupyter notebook: \!pip install dlt\[duckdb\]. If you’re doing it locally, be sure to also have duckdb pip installed (even before the duckdb package is loaded).

in zsh try:  
**pip install “dlt\[duckdb\]”**

## Other packages needed but not listed

	If you are running Jupyter Notebook on a fresh new Codespace or in local machine with a new Virtual Environment, you will need this package to run the starter Jupyter Notebook offered by the teacher. Execute this:

Install all the necessary dependencies

pip install duckdb pandas numpy pyarrow

Or save it into a requirements.txt file:

dlt\[duckdb\]

duckdb

pandas

numpy

pyarrow  \# Optional, needed for Parquet support

Then run pip install \-r requirements.txt

## How can I use DuckDB In-Memory database with dlt ?

| import dlt import duckdbconn \= duckdb.connect() def my\_generator\_fn():    \# implement your generator function    pass pipeline \= dlt.pipeline(    pipeline\_name='my\_pipeline',    destination=dlt.destinations.duckdb(conn),    dataset\_name='dlt', ) pipeline.run(    my\_generator\_fn,     table\_name='my\_table',    write\_disposition='replace', ) print(conn.sql("SELECT \* FROM dlt.my\_table")) conn.close() |
| :---- |

Alternatively, you can switch to in-file storage with:

| \# In-Memory database storageconn \= duckdb.connect() \# File database storage conn \= duckdb.connect("/path/to/your/db.duckdb") |
| :---- |

## Homework \- dlt Exercise 3 \- Merge a generator concerns

*After loading, you should have a total of 8 records, and ID 3 should have age 33*

*Question: **Calculate the sum of ages of all the people loaded as described above***

The sum of all eight records' respective ages is too big to be in the choices. You need to first filter out the people whose occupation is equal to *None* in order to get an answer that is close to or present in the given choices. 😃

\----------------------------------------------------------------------------------------

![:white\_check\_mark:][image72] **FIXED \= use a raw string and keep the file:/// at the start of your file path ![:slightly\_smiling\_face:][image73]**

**![:bangbang:][image74]**I'm having an issue with the dlt workshop notebook. The 'Load to Parquet file' section specifically. No matter what I change the file path to, it's still saving the dlt files directly to my C drive. 

\# Set the bucket\_url. We can also use a local folder  
os.environ\['DESTINATION\_\_FILESYSTEM\_\_BUCKET\_URL'\] \= r'file:///content/.dlt/my\_folder'  
url \= "[https://storage.googleapis.com/dtc\_zoomcamp\_api/yellow\_tripdata\_2009-06.jsonl](https://storage.googleapis.com/dtc_zoomcamp_api/yellow_tripdata_2009-06.jsonl)"  
\# Define your pipeline  
pipeline \= dlt.pipeline(  
    pipeline\_name='my\_pipeline',  
    destination='filesystem',  
    dataset\_name='mydata'  
)  
\# Run the pipeline with the generator we created earlier.  
load\_info \= pipeline.run(stream\_download\_jsonl(url), table\_name="users", loader\_file\_format="parquet")

print(load\_info)

\# Get a list of all Parquet files in the specified folder  
parquet\_files \= glob.glob('/content/.dlt/my\_folder/mydata/users/\*.parquet')

\# show parquet files  
for file in parquet\_files:  
  print(file)

## Problem with importing the dlt or dlt.sources module

Make sure you don’t have a dlt.py file saved in the same directory as your working file.

## How to set credentials in Google Colab notebook to connect to BigQuery

In the secrets sidebar, create a secret ‘BIGQUERY\_CRENTIALS’ with value being your Google Cloud service account key. Then load it with:  
import os

from google.colab import userdata

os.environ\["DESTINATION\_\_BIGQUERY\_\_CREDENTIALS"\] \= userdata.get('BIGQUERY\_CREDENTIALS')

## How do I set up credentials to run dlt in my environment (not Google Colab)?

You can set up credentials for \`dlt\` in several ways. Here are the two most common methods:  

1. Environment Variables (Easiest)

* Set credentials via environment variables. For example, to configure Google Cloud credentials:       

| export GOOGLE\_SECRETS\_\_CREDENTIALS="/path/to/your/service\_account\_key.json" |
| :---- |

* This method avoids hardcoding secrets in your code and works seamlessly with most environments.  

2. Configuration Files (Recommended for Local Use) 

* Use \`.dlt/secrets.toml\` for sensitive credentials and \`.dlt/config.toml\` for non-sensitive configurations.  

* Example for Google Cloud in \`secrets.toml\`:  

     

     

| \[google\_secrets.credentials\]  project\_id \= "\<your-project-id\>"  private\_key \= "-----BEGIN PRIVATE KEY-----\\n...\\n-----END PRIVATE KEY-----\\n"  client\_email \= "\<your-service-account\>@\<project-id\>.iam.gserviceaccount.com"   |
| :---- |

*    Place these files in the .dlt folder of your project.  

Additional Notes:  

* Never commit secrets.toml to version control (add it to .gitignore).  

* Credentials can also be loaded via vaults, AWS Parameter Store, or custom setups.  

For additional methods and detailed information, refer to the [official dlt documentation](https://dlthub.com/docs/general-usage/credentials/)

## Make DLT comply with the XDG Base Dir Specification

You can set the environment variable in your shell init script (for Bash or ZSH):

*export DLT\_DATA\_DIR=$XDG\_DATA\_HOME/dlt*

Or for Fish (in config.fish):

*set \-x DLT\_DATA\_DIR “$XDG\_DATA\_HOME/dlt”*

## Embedding dlt into Apache Airflow

from airflow import DAG

from airflow.operators.python import PythonOperator

from datetime import datetime, timedelta

import dlt

from my\_dlt\_pipeline import load\_data  \# Import your dlt pipeline function

default\_args \= {

    "owner": "airflow",

    "depends\_on\_past": False,

    "start\_date": datetime(2024, 2, 16),

    "retries": 1,

    "retry\_delay": timedelta(minutes=5),

}

def run\_dlt\_pipeline():

    pipeline \= dlt.pipeline(

        pipeline\_name="my\_pipeline",

        destination="duckdb",  \# Change this based on your database

        dataset\_name="my\_dataset"

    )

    info \= pipeline.run(load\_data())

    print(info)  \# Logs for debugging

with DAG(

    "dlt\_airflow\_pipeline",

    default\_args=default\_args,

    schedule\_interval="@daily",

    catchup=False,

) as dag:

    run\_dlt\_task \= PythonOperator(

        task\_id="run\_dlt\_pipeline",

        python\_callable=run\_dlt\_pipeline,

    )

    run\_dlt\_task

## Embedding dlt into Kestra

id: dlt\_ingestion

namespace: my.dlt

description: "Run dlt pipeline with Kestra"

tasks:

  \- id: run\_dlt

    type: io.kestra.plugin.scripts.python.Commands

    commands:

      \- |

        import dlt

        from my\_dlt\_pipeline import load\_data  \# Import your dlt function

        pipeline \= dlt.pipeline(

            pipeline\_name="kestra\_pipeline",

            destination="duckdb",

            dataset\_name="kestra\_dataset"

        )

        info \= pipeline.run(load\_data())

        print(info)

## Loading Dlt Exports from GCS Filesystems

When using the filesystem destination, you may have issues reading the files exported because dlt will by default compress the files. 

If you are using loader\_file\_format="parquet" then BigQuery should cope with this compression OK. If you want to use jsonl or csv format however, then you may need to disable file compression to avoid issues with reading the files directly in BigQuery. To do this set the following config:

\[normalize.data\_writer\]

disable\_compression \= true   There is further information at [https://dlthub.com/docs/dlt-ecosystem/destinations/filesystem\#file-compression](https://dlthub.com/docs/dlt-ecosystem/destinations/filesystem#file-compression) 

\[WARNING\]: Test 'test.taxi\_rides\_ny.relationships\_stg\_yellow\_tripdata\_dropoff\_locationid\_\_locationid\_\_ref\_taxi\_zone\_lookup\_csv\_.085c4830e7' (models/staging/schema.yml) depends on a node named 'taxi\_zone\_lookup.csv' in package '' which was not found  
solve: This warning indicates that dbt is trying to reference a model or source named taxi\_zone\_lookup.csv, but it cannot find it. We might have a typo in our ref() function.  
tests:

  \- name: relationships\_stg\_yellow\_tripdata\_dropoff\_locationid

    description: "Ensure dropoff\_location\_id exists in taxi\_zone\_lookup.csv"

    relationships:

      to: ref('taxi\_zone\_lookup.csv')  \# ❌ Wrong reference

      field: locationid  
to:  
 to: ref('taxi\_zone\_lookup')  \# ✅ Correct reference

When I ran `df_spark = spark.createDataFrame(df_pandas)`, I encountered an error indicating a version mismatch between Pandas and Spark. To resolve this, I had two options: either downgrade Pandas to a version below 2 or upgrade Spark to version 3.5.5. I chose to upgrade Spark to 3.5.5, and it worked.

### **Avoiding Backpressure in Flink**

* **What’s Backpressure?**

  * It happens when **Flink processes data slower** than Kafka produces it.  
  * This leads to **increased memory usage** and can **slow down or crash the job**.  
* **How to Fix It?**

  * Adjust Kafka’s **consumer parallelism** to **match the producer rate**.  
  * **Increase partitions** in Kafka to allow more parallel processing.  
  * Monitor **Flink metrics** to detect backpressure.  
* python  
  CopyEdit  
  `env.set_parallelism(4)  # Adjust parallelism to avoid bottlenecks`
