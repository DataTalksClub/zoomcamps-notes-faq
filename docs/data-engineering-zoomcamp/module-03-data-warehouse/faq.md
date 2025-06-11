---
title: FAQ
parent: Module 3
nav_order: 2
---

# Module 3: Data Warehousing

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

## Docker-compose takes infinitely long to install zip unzip packages for linux, which are required to unpack datasets

A:

1 solution) Add `-Y` flag, so that apt-get automatically agrees to install additional packages

2\) Use python ZipFile package, which is included in all modern python distributions

## GCS Bucket \- error when writing data from web to GCS:

Make sure to use **Nullable** dataTypes, such as [**Int64**](https://pandas.pydata.org/docs/user_guide/integer_na.html) when appliable.

## GCS Bucket \- te table: Error while reading data, error message: Parquet column 'XYZ' has type INT which does not match the target cpp\_type DOUBLE. File: gs://path/to/some/blob.parquet

Ultimately, when trying to ingest data into a BigQuery table, all files within a given directory must have the same schema. 

When dealing for example with the FHV Datasets from 2019, however (see image below), one can see that the files for '2019-05', and 2019-06, have the columns "PUlocationID" and "DOlocationID" as Integers, while for the period of '2019-01' through '2019-04', the same column is defined as FLOAT.parquet

So while importing these files as parquet to BigQuery, the first one will be used to define the schema of the table, while all files following that will be used to append data on the existing table. Which means, they must all follow the very same schema of the file that created the table. 

![][image25] 

So, in order to prevent errors like that, make sure to enforce the data types for the columns on the DataFrame before you serialize/upload them to BigQuery. Like this:

pd.read\_csv("path\_or\_url").astype({  
	"col1\_name": "datatype",	  
	"col2\_name": "datatype",	  
	...					  
	"colN\_name": "datatype" 	  
})

## GCS Bucket \- Fix Error when importing FHV data to GCS

If you receive the error gzip.BadGzipFile: Not a gzipped file (b'\\n\\n'), this is because you have specified the wrong URL to the FHV dataset. Make sure to use [https://github.com/DataTalksClub/nyc-tlc-data/releases/download/fhv/{dataset\_file}.csv.gz](https://github.com/DataTalksClub/nyc-tlc-data/releases/download/fhv/{dataset_file}.csv.gz)  
Emphasising the ‘/releases/download’ part of the URL.

## GCS Bucket \- Load Data From URL list in to GCP Bucket

![][image26]

Krishna Anand

## GCS Bucket \- I query my dataset and get a Bad character (ASCII 0\) error?

- Check the Schema

- You might have a wrong formatting

- Try to upload the CSV.GZ files without formatting or going through pandas via wget

- [See this Slack conversation for helpful tips](https://datatalks-club.slack.com/archives/C01FABYF2RG/p1676034803779649)

## GCP BQ \- “bq: command not found” 

Run the following command to check if “BigQuery Command Line Tool” is installed or not: `gcloud components list`

You can also use `bq.cmd` instead of `bq` to make it work.

## GCP BQ \- Caution in using bigquery:no 

Use big queries carefully,

I created by bigquery dataset on an account where my free trial was exhausted, and got a bill of $80.

Use big query in free credits and destroy all the datasets after creation.

Check your Billing daily\! Especially if you’ve spinned up a VM.

## GCP BQ \- Cannot read and write in different locations: source: EU, destination: US \- Loading data from GCS into BigQuery (different Region):

Be careful when you create your resources on GCP, all of them have to share the same Region in order to allow load data from GCS Bucket to BigQuery. If you forgot it when you created them, you can create a new dataset on BigQuery using the same Region which you used on your GCS Bucket.

![][image27]

![][image28]

This means that your GCS Bucket and the BigQuery dataset are placed in different regions. You have to create a new dataset inside BigQuery in the same region with your GCS bucket and store the data in the newly created dataset.

## GCP BQ \- Cannot read and write in different locations: source: \<REGION\_HERE\>, destination: \<ANOTHER\_REGION\_HERE\>

Make sure to create the BigQuery dataset in the very same location that you've created the GCS Bucket. For instance, **if your GCS Bucket was created in \`**us-central1**\`, then BigQuery dataset** **must be created in the same region** (us-central1, in this example)

![][image29]

![][image30]

## GCP BQ \- Remember to save your queries

By the way, this isn’t a problem/solution, but a useful hint:

* Please, remember to save your progress in BigQuery SQL Editor.

* I was almost finishing the homework, when my Chrome Tab froze and I had to reload it. Then I lost my entire SQL script.

* Save your script from time to time. Just click on the button at the top bar. Your saved file will be available on the left panel.

![][image31]

Alternatively, you can copy paste your queries into an .sql file in your preferred editor (Notepad++, VS Code, etc.). Using the .sql extension will provide convenient color formatting.

## GCP BQ \- Can I use BigQuery for real-time analytics in this project?

Ans :  While real-time analytics might not be explicitly mentioned, BigQuery has real-time data streaming capabilities, allowing for potential integration in future project iterations.

## GCP BQ \- Unable to load data from external tables into a materialized table in BigQuery due to an invalid timestamp error that are added while appending data to the file in Google Cloud Storage

could not parse 'pickup\_datetime' as timestamp for field pickup\_datetime (position 2\)

This error is caused by invalid data in the timestamp column. A way to identify the problem is to define the schema from the external table using string datatype. This enables the queries to work at which point we can filter out the invalid rows from the import to the materialised table and insert the fields with the timestamp data type.

## GCP BQ \- Error Message in BigQuery: annotated as a valid Timestamp, please annotate it as TimestampType(MICROS) or TimestampType(MILLIS) 

**Background**:

- \`pd.read\_parquet\`  
- \`pd.to\_datetime\`  
- \`pq.write\_to\_dataset\`

**Reference**: 

- [https://stackoverflow.com/questions/48314880/are-parquet-file-created-with-pyarrow-vs-pyspark-compatible](https://stackoverflow.com/questions/48314880/are-parquet-file-created-with-pyarrow-vs-pyspark-compatible)  
- [https://stackoverflow.com/questions/57798479/editing-parquet-files-with-python-causes-errors-to-datetime-format](https://stackoverflow.com/questions/57798479/editing-parquet-files-with-python-causes-errors-to-datetime-format)  
- [https://www.reddit.com/r/bigquery/comments/16aoq0u/parquet\_timestamp\_to\_bq\_coming\_across\_as\_int/?share\_id=YXqCs5Jl6hQcw-kg6-VgF\&utm\_content=1\&utm\_medium=ios\_app\&utm\_name=ioscss\&utm\_source=share\&utm\_term=1](https://www.reddit.com/r/bigquery/comments/16aoq0u/parquet_timestamp_to_bq_coming_across_as_int/?share_id=YXqCs5Jl6hQcw-kg6-VgF&utm_content=1&utm_medium=ios_app&utm_name=ioscss&utm_source=share&utm_term=1)

**Solution**:

Add \`use\_deprecated\_int96\_timestamps=True\` to \`pq.write\_to\_dataset\` function, like below

pq.write\_to\_dataset(  
        table,  
        root\_path=root\_path,  
        filesystem=gcs,  
        use\_deprecated\_int96\_timestamps=True    
\# Write timestamps to INT96 Parquet format  
)

## GCP BQ \- Datetime columns in Parquet files created from Pandas show up as integer columns in BigQuery

**Solution:**

If you’re using Mage, in the last Data Exporter that writes to Google Cloud Storage use PyArrow to generate the Parquet file with the correct logical type for the datetime columns, otherwise they won't be converted to timestamp when loaded by BigQuery later on.

import pyarrow as pa  
import pyarrow.parquet as pq  
import os

if 'data\_exporter' not in globals():  
    from mage\_ai.data\_preparation.decorators import data\_exporter

\# Replace with the location of your service account key JSON file.  
os.environ\['GOOGLE\_APPLICATION\_CREDENTIALS'\] \= '/home/src/personal-gcp.json' 

bucket\_name \= "\<YOUR\_BUCKET\_NAME\>"  
object\_key \= 'nyc\_taxi\_data\_2022.parquet'  
where \= f'{bucket\_name}/{object\_key}'

@data\_exporter  
def export\_data(data, \*args, \*\*kwargs):  
    table \= pa.Table.from\_pandas(data, preserve\_index=False)  
    gcs \= pa.fs.GcsFileSystem()

    pq.write\_table(  
        table,  
        where,

        \# Convert integer columns in Epoch milliseconds  
        \# to Timestamp columns in microseconds ('us') so  
        \# they can be loaded into BigQuery with the right  
        \# data type  
        coerce\_timestamps='us',

        filesystem=gcs  
    )

**Solution 2:**

If you’re using Mage, in the last Data Exporter that writes to Google Cloud Storage, provide PyArrow with explicit schema to generate the Parquet file with the correct logical type for the datetime columns, otherwise they won't be converted to timestamp when loaded by BigQuery later on.

   schema \= pa.schema(\[  
       ('vendor\_id', pa.int64()),  
       ('lpep\_pickup\_datetime', pa.timestamp('ns')),  
       ('lpep\_dropoff\_datetime', pa.timestamp('ns')),  
       ('store\_and\_fwd\_flag', pa.string()),  
       ('ratecode\_id', pa.int64()),  
       ('pu\_location\_id', pa.int64()),  
       ('do\_location\_id', pa.int64()),  
       ('passenger\_count', pa.int64()),  
       ('trip\_distance', pa.float64()),  
       ('fare\_amount', pa.float64()),  
       ('extra', pa.float64()),  
       ('mta\_tax', pa.float64()),  
       ('tip\_amount', pa.float64()),  
       ('tolls\_amount', pa.float64()),  
       ('improvement\_surcharge', pa.float64()),  
       ('total\_amount', pa.float64()),  
       ('payment\_type', pa.int64()),  
       ('trip\_type', pa.int64()),  
       ('congestion\_surcharge', pa.float64()),  
       ('lpep\_pickup\_month', pa.int64())  
   \])  
    
   table \= pa.Table.from\_pandas(data, schema=schema)

## GCP BQ \- Create External Table using Python

**Reference**: 

[https://cloud.google.com/bigquery/docs/external-data-cloud-storage](https://cloud.google.com/bigquery/docs/external-data-cloud-storage)

**Solution:**

from google.cloud import bigquery

    \# Set table\_id to the ID of the table to create  
    table\_id \= f"{project\_id}.{dataset\_name}.{table\_name}"

    \# Construct a BigQuery client object  
    client \= bigquery.Client()

    \# Set the external source format of your table  
    external\_source\_format \= "PARQUET"

    \# Set the source\_uris to point to your data in Google Cloud  
    source\_uris \= \[ f'gs://{bucket\_name}/{object\_key}/\*'\]

    \# Create ExternalConfig object with external source format  
    external\_config \= bigquery.ExternalConfig(external\_source\_format)  
    \# Set source\_uris that point to your data in Google Cloud  
    external\_config.source\_uris \= source\_uris  
    external\_config.autodetect \= True  
      
    table \= bigquery.Table(table\_id)  
    \# Set the external data configuration of the table  
    table.external\_data\_configuration \= external\_config

    table \= client.create\_table(table)  \# Make an API request.

    print(f'Created table with external source: {table\_id}')  
    print(f'Format: {table.external\_data\_configuration.source\_format}')

## GCP BQ \- Check BigQuery Table Exist And Delete

**Reference:**

[https://stackoverflow.com/questions/60941726/can-bigquery-api-overwrite-existing-table-view-with-create-table-tables-inser](https://stackoverflow.com/questions/60941726/can-bigquery-api-overwrite-existing-table-view-with-create-table-tables-inser)

**Solution:**

Combine with “Create External Table using Python”, use it before “client.create\_table” function.

def tableExists(tableID, client):  
    """  
    Check if a table already exists using the tableID.  
    return : (Boolean)  
    """  
    try:  
        table \= client.get\_table(tableID)  
        return True  
    except Exception as e: \# NotFound:  
        return False

## GCP BQ \- Error: Missing close double quote (") character

To avoid this error you can upload data from Google Cloud Storage to BigQuery through BigQuery Cloud Shell using the command:

`$ bq load  --autodetect --allow_quoted_newlines --source_format=CSV dataset_name.table_name "gs://dtc-data-lake-bucketname/fhv/fhv_tripdata_2019-*.csv.gz"`

## GCP BQ \- Cannot read and write in different locations: source: asia-south2, destination: US

Solution: This problem arises if your gcs and bigquery storage is in different regions. 

One potential way to solve it: 

1. Go to your google cloud bucket and check the region in field named “Location”

   ![][image32]

2. Now in bigquery, click on three dot icon near your project name and select create dataset.

   ![][image33]

3. In region filed choose the same regions as you saw in your google cloud bucket

   ![][image34]

## GCP BQ \- Tip: Using Cloud Function to read csv.gz files from github directly to BigQuery in Google Cloud:

There are multiple benefits of using Cloud Functions to automate tasks in Google Cloud. 

Use below Cloud Function python script to load files directly to BigQuery. Use your project id, dataset id & table id as defined by you.

import tempfile  
import requests  
import logging  
from google.cloud import bigquery

def hello\_world(request):

    \# table\_id \= \<project\_id.dataset\_id.table\_id\>  
    table\_id \= 'de-zoomcap-project.dezoomcamp.fhv-2019'

    \# Create a new BigQuery client  
    client \= bigquery.Client()

    for month in range(4, 13):  
        \# Define the schema for the data in the CSV.gz files  
        url \= 'https://github.com/DataTalksClub/nyc-tlc-data/releases/download/fhv/fhv\_tripdata\_2019-{:02d}.csv.gz'.format(month)

        \# Download the CSV.gz file from Github  
        response \= requests.get(url)

        \# Create new table if loading first month data else append  
        write\_disposition\_string \= "WRITE\_APPEND" if month \> 1 else "WRITE\_TRUNCATE"

        \# Defining LoadJobConfig with schema of table to prevent it from changing with every table  
        job\_config \= bigquery.LoadJobConfig(  
                schema=\[  
                    bigquery.SchemaField("dispatching\_base\_num", "STRING"),  
                    bigquery.SchemaField("pickup\_datetime", "TIMESTAMP"),  
                    bigquery.SchemaField("dropOff\_datetime", "TIMESTAMP"),  
                    bigquery.SchemaField("PUlocationID", "STRING"),  
                    bigquery.SchemaField("DOlocationID", "STRING"),  
                    bigquery.SchemaField("SR\_Flag", "STRING"),  
                    bigquery.SchemaField("Affiliated\_base\_number", "STRING"),  
                \],  
                    skip\_leading\_rows=1,  
                    write\_disposition=write\_disposition\_string,  
                    autodetect=True,  
                    source\_format="CSV",  
                )

        \# Load the data into BigQuery   
        \# Create a temporary file to prevent the exception- AttributeError: 'bytes' object has no attribute 'tell'"  
        with tempfile.NamedTemporaryFile() as f:  
            f.write(response.content)  
            f.seek(0)  
            job \= client.load\_table\_from\_file(  
                f,  
                table\_id,  
                location="US",  
                job\_config=job\_config,  
            )  
            job.result()  
            logging.info("Data for month %d successfully loaded into table %s.", month, table\_id)  
    return 'Data loaded into table {}.'.format(table\_id)

## GCP BQ \- When querying two different tables external and materialized you get the same result when count(distinct(\*))

You need to uncheck cache preferences in query settings

![][image35]

![][image36]

## GCP BQ \- How to handle type error from big query and parquet data?

Problem: When you inject data into GCS using Pandas, there is a chance that some dataset has missing values on  DOlocationID and PUlocationID. Pandas by default will cast these columns as float data type, causing inconsistent data type between parquet in GCS and schema defined in big query. You will see something like this: 

# *error: Error while reading table: trips\_data\_all.external\_fhv\_tripdata, error message: Parquet column 'DOlocationID' has type INT64 which does not match the target cpp\_type DOUBLE.* 

Solution: 

- Fix the data type issue in data pipeline 

- Before injecting data into GCS, use astype and Int64 (which is different from int64 and accept both missing value and integer exist in the column) to cast the columns.

Something like:

    df\["PUlocationID"\] \= df.PUlocationID.astype("Int64")

    df\["DOlocationID"\] \= df.DOlocationID.astype("Int64")

NOTE: It is best to define the data type of all the columns in the Transformation section of the ETL pipeline before loading to BigQuery

## GCP BQ \- Invalid project ID . Project IDs must contain 6-63 lowercase letters, digits, or dashes. Some project

Problem occurs when misplacing content after fro\`\`m clause in BigQuery SQLs.  
Check to remove any extra apaces or any other symbols, keep in lowercases, digits and dashes only

## GCP BQ \- Does BigQuery support multiple columns partition?

No. Based on the documentation for Bigquery, it does not support more than 1 column to be partitioned.

\[[source](https://cloud.google.com/bigquery/docs/partitioned-tables#limitations)\]

## GCP BQ \- DATE() Error in BigQuery

**Error Message:** 

`PARTITION BY expression must be DATE(<timestamp_column>), DATE(<datetime_column>), DATETIME_TRUNC(<datetime_column>, DAY/HOUR/MONTH/YEAR), a DATE column, TIMESTAMP_TRUNC(<timestamp_column>, DAY/HOUR/MONTH/YEAR), DATE_TRUNC(<date_column>, MONTH/YEAR), or RANGE_BUCKET(<int64_column>, GENERATE_ARRAY(<int64_value>, <int64_value>[, <int64_value>]))`

**Solution:** 

Convert the column to datetime first.

df\["pickup\_datetime"\] \= pd.to\_datetime(df\["pickup\_datetime"\])  
df\["dropOff\_datetime"\] \= pd.to\_datetime(df\["dropOff\_datetime"\])

## GCP BQ \- When trying to cluster by DATE(tpep\_pickup\_datetime) it gives an error: Entries in the CLUSTER BY clause must be column names

No need to convert as you can cluster by a TIMESTAMP column directly in BigQuery. BigQuery supports clustering on TIMESTAMP, DATE, DATETIME, STRING, INT64, and BOOL types.

clustering sorts data based on the timestamp to optimize queries with filters like WHERE tpep\_pickup\_datetime BETWEEN ..., rather than creating discrete partitions.

If your goal is to improve performance for time-based queries, combining partitioning by DATE(event\_time) and clustering by tpep\_pickup\_datetime is a good approach.

## GCP BQ \- Native tables vs External tables in BigQuery?

Native tables are tables where the data is stored in BigQuery.  External tables store the data outside BigQuery, with BigQuery storing metadata about that external table.

External tables: They are not stored directly in big query tables but pulled in from a data lake such as Google Cloud Storage or S3.

Materialized table: Copy of this external table. Now the data is stored in the bigquery table and consumes the space.

Resources:

* [https://cloud.google.com/bigquery/docs/external-tables](https://cloud.google.com/bigquery/docs/external-tables)

* [https://cloud.google.com/bigquery/docs/tables-intro](https://cloud.google.com/bigquery/docs/tables-intro)

### Why does my partitioned table in BigQuery show as non-partitioned even though BigQuery says it's partitioned?

If your partitioned table in BigQuery shows as non-partitioned, it may be due to a delay in updating the table's details in the UI. The table is likely partitioned, but it may not show the updated information immediately.

Here’s what you can do:

1. Refresh your BigQuery UI:  
   If you're already inspecting the table in the BigQuery UI, try refreshing the page after a few minutes to ensure the table details are updated correctly.

2. Open a new tab:  
   Alternatively, try opening a new tab in BigQuery and inspect the table details again. This can sometimes help to load the most up-to-date information.

3. Be patient:  
   In some cases, there might be a slight delay in reflecting changes, but the table is very likely partitioned.

## GCP BQ ML \- Unable to run command (shown in video) to export ML model from BQ to GCS

Issue: Tried running command to export ML model from BQ to GCS from Week 3

bq \--project\_id taxi-rides-ny extract \-m nytaxi.tip\_model gs://taxi\_ml\_model/tip\_model

It is failing on following error:

BigQuery error in extract operation: Error processing job Not found: Dataset was not found in location US

I verified the BQ data set and gcs bucket are in the same region- us-west1. Not sure how it gets location US. I couldn’t find the solution yet.

Solution:  Please enter correct project\_id and gcs\_bucket folder address. My gcs\_bucket folder address is 

gs://dtc\_data\_lake\_optimum-airfoil-376815/tip\_model 

## Dim\_zones.sql Dataset was not found in location US When Running fact\_trips.sql

To solve this error mention the location \= US when creating the dim\_zones table 

{{ config(

    materialized='table',

    location='US'

) }}

Just Update this part to solve the issue and run the dim\_zones again and then run the fact\_trips

## GCP BQ ML \- Export ML model to make predictions does not work for MacBook with Apple M1 chip (arm architecture).

Solution: proceed with setting up serving\_dir on your computer as in the extract\_model.md file. Then instead of 

docker pull tensorflow/serving

use

docker pull emacski/tensorflow-serving

Then

docker run \-p 8500:8500 \-p 8501:8501 \--mount type=bind,source=\`pwd\`/serving\_dir/tip\_model,target=/models/tip\_model \-e MODEL\_NAME=tip\_model \-t emacski/tensorflow-serving

Then run the curl command as written, and you should get a prediction.

Or new since Oct 2024:

Beta release of Docker VMM \- the more performant alternative to Apple Virtualization Framework on macOS (requires Apple Silicon and macOS 12.5 or later). [https://docs.docker.com/desktop/features/vmm/](https://docs.docker.com/desktop/features/vmm/)

![][image37]

## VMs \- What do I do if my VM runs out of space?

- Try deleting data you’ve saved to your VM locally during ETLs

- Kill processes related to deleted files

- Download ncdu and look for large files (pay particular attention to files related to Prefect)

- If you delete any files related to Prefect, eliminate caching from your flow code

# GCP BQ \- External and regular table

**External Table** (data remains in GCS bucket)

**Regular Table** (data is copied into BigQuery storage)

Example of creating external table:

 CREATE OR REPLACE EXTERNAL TABLE \`your\_project.your\_dataset.tablenamel\`

OPTIONS (

  format \= 'PARQUET',

  uris \= \['gs://your-bucket-name/yellow\_tripdata\_2024-\*.parquet'\]

);

Example of creating regular table from extermal table

CREATE OR REPLACE TABLE \`your\_project.your\_dataset.tablename\`

AS

SELECT \* FROM \`your\_project.your\_dataset.yellow\_taxi\_external\`;

Or directly load data form GCS into a regular BigQuery table without creating an external table using:

CREATE OR REPLACE TABLE \`your\_project.your\_dataset.yellow\_taxi\_table\`

OPTIONS (

  format \= 'PARQUET'

) AS

SELECT \* FROM \`your\_project.your\_dataset.external\_table\_placeholder\`

FROM EXTERNAL\_QUERY(

  'your\_project.region-us.gcs\_external',

  'SELECT \* FROM \`gs://your-bucket-name/yellow\_tripdata\_2024-\*.parquet\`'

);

## Can BigQuery work with parquet files directly?

Yes, you can load your Parquet files directly into your GCP (Google Cloud Platform) Bucket first, then via BigQuery, you can create an external table of these Parquet files with a query statement like this:

CREATE OR REPLACE EXTERNAL TABLE \`module-3-data-warehouse.taxi\_data.external\_yellow\_tripdata\_2024\`  
OPTIONS (  
  format \= 'PARQUET',  
  uris \= \['gs://module3-dez/yellow\_tripdata\_2024-\*.parquet'\]  
);

Make sure to adjust the sql statement to your own situation and directories.  
The \* symbol can be used as a wildcard, which you will need to target Parquet files of all the months of 2024\.

## Homework \- What does it mean “Stop with loading the files into a bucket.' Stop with loading the files into a bucket?”

Ans: What they mean is that they don't want you to do anything more than that. You should load the files into the bucket and create an external table based on those files (but nothing like cleaning the data and putting it in parquet format)

## Homework \- Reading parquets from nyc.gov directly into pandas returns Out of bounds error

If for whatever reason you try to read parquets directly from nyc.gov’s cloudfront into pandas, you might run into this error:

pyarrow.lib.ArrowInvalid: Casting from timestamp\[us\] to timestamp\[ns\] would result in out of bounds

Cause:

1. there is one errant data record where the dropOff\_datetime was set to year 3019 instead of 2019\. 

2. pandas uses “timestamp\[ns\]” (as noted above), and int64 only allows a \~580 year range, centered on 2000\. See \`pd.Timestamp.max\` and \`pd.Timestamp.min\`

3. This becomes out of bounds when pandas tries to read it because 3019 \> 2300 (approx value of pd.Timestamp.Max

Fix:

1. Use pyarrow to read it:  
   import pyarrow.parquet as pq df \= pq.read\_table('fhv\_tripdata\_2019-02.parquet').to\_pandas(safe=False)  
   However this results in weird timestamps for the offending record

2. Read the datetime columns separately using pq.read\_table

   table \= pq.read\_table(‘taxi.parquet’)  
   datetimes \= \[‘list of datetime column names’\]  
   df\_dts \= pd.DataFrame()  
       for col in datetimes:  
           df\_dts\[col\] \= pd.to\_datetime(table .column(col), errors='coerce')

   The \`errors=’coerce’\` parameter will convert the out of bounds timestamps into either the max or the min

3. Use parquet.compute.filter to remove the offending rows

   import pyarrow.compute as pc  
   table \= pq.read\_table("‘taxi.parquet")  
   df \= table.filter(  
       pc.less\_equal(table\["dropOff\_datetime"\], pa.scalar(pd.Timestamp.max))  
   ).to\_pandas()

## Homework \- Uploading files to GCS via GUI

This can help avoid schema issues in the homework.   
Download files locally and use the ‘upload files’ button in GCS at the desired path. You can upload many files at once. You can also choose to upload a folder.

## Homework \- Qn 5: The partitioned/clustered table isn’t giving me the prediction I expected

Ans: Take a careful look at the format of the dates in the question.

## Homework \- Qn 6: Did anyone get an exact match for one of the options given in Module 3 homework Q6?

Many people aren’t getting an exact match, but are very close to one of the options. As per **Alexey said to choose the closest option**.

## Python \- invalid start byte Error Message

UnicodeDecodeError: 'utf-8' codec can't decode byte 0xa0 in position 41721: invalid start byte

Solution:

Step 1: When reading the data from the web into the pandas dataframe mention the encoding as follows:

pd.read\_csv(dataset\_url, low\_memory=False, encoding='latin1') 

Step 2: When writing the dataframe from the local system to GCS as a csv mention the encoding as follows:

df.to\_csv(path\_on\_gsc, compression="gzip", encoding='utf-8')

Alternative: use pd.read\_parquet(url)

## Python \- Generators in python

A generator is a function in python that returns an iterator using the yield keyword.

A generator is a special type of iterable, similar to a list or a tuple, but with a crucial difference. Instead of creating and storing all the values in memory at once, a generator generates values on-the-fly as you iterate over it. This makes generators memory-efficient, particularly when dealing with large datasets.  

## Python \- Easiest way to read multiple files at the same time?

The read\_parquet function supports a list of files as an argument. The list of files will be merged into a single result table.

## Python \- These won't work. You need to make sure you use Int64: 

**Incorrect:**

`df['DOlocationID'] = pd.to_numeric(df['DOlocationID'], downcast=integer) or`

`df['DOlocationID'] = df['DOlocationID'].astype(int)`

**Correct:**

`df['DOlocationID'] = df['DOlocationID'].astype('Int64')`

## Warning when run load\_yellow\_data python script 

RuntimeWarning: As the c extension couldn't be imported, google-crc32c is using a pure python implementation that is significantly slower. If possible, please configure a c build environment and compile extention warnings.warn(\_SLOW\_CRC32C\_WARNING, RuntimeWarning)

Failed to upload ./yellow\_tripdata\_2024-01.parquet to GCS: Timeout of 120.0s exceeded, last exception: ('Connection aborted.', timeout('The write operation timed out'))

Failed to upload ./yellow\_tripdata\_2024-03.parquet to GCS: Timeout of 120.0s exceeded, last exception: ('Connection aborted.', timeout('The write operation timed out'))

Im facing two separate issues in my script:

1. google-crc32c Warning: The Google Cloud Storage library is using a slow Python implementation instead of the optimized C version.

2. Upload Timeout Error: Your file uploads are timing out after 120 seconds.

✅ Solution: Install the C-optimized google-crc32c

pip install \--upgrade google-crc32c

2\. Fix Google Cloud Storage Upload Timeout

✅ Solution 1: Increase Timeout

blob.upload\_from\_filename(file\_path, timeout=300) \# Set timeout to 5 minutes
