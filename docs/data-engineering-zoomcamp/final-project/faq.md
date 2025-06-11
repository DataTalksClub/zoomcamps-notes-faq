---
title: FAQ
parent: Final Project
nav_order: 2
---

# Module 6 FAQ

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

## How is my capstone project going to be evaluated?

* Each submitted project will be evaluated by 3 (three) randomly assigned students that have also submitted the project. 

*  You will also be responsible for grading the projects from 3 fellow students yourself. Please be aware that: not complying to this rule also implies you failing to achieve the Certificate at the end of the course.

* The final grade you get will be the median score of the grades you get from the peer reviewers.

* And of course, the peer review criteria for evaluating or being evaluated must follow the guidelines defined [**here**](https://github.com/DataTalksClub/data-engineering-zoomcamp/tree/main/week_7_project#peer-review-criteria).

## Can I collaborate with others on the capstone project?

Collaboration is not allowed for the capstone submission. However, you can discuss ideas and get feedback from peers in the forums or Slack channels.

## Project 1 & Project 2 

There is only ONE project for this Zoomcamp. You do not need to submit or create two projects. 

There are simply TWO chances to pass the course. You can use the Second Attempt if you a) fail the first attempt b) do not have the time due to other engagements such as holiday or sickness etc. to enter your project into the first attempt. 

## Project evaluation - Reproducibility

The question is that sometimes even if you take plenty of effort to document every single step, and we can't even sure if the person doing the peer review will be able to follow-up, so how this criteria will be evaluated?

Alex clarifies: “Ideally yes, you should try to re-run everything. But I understand that not everyone has time to do it, so if you check the code by looking at it and try to spot errors, places with missing instructions and so on \- then it's already great”

## Certificates: how do I get it?

A: [See the certificate.mdx file](#certificate---generating,-receiving-after-projects-graded)

## Does anyone know nice and relatively large datasets?

See a list of datasets here: [https://github.com/DataTalksClub/data-engineering-zoomcamp/blob/main/projects/datasets.md](https://github.com/DataTalksClub/data-engineering-zoomcamp/blob/main/projects/datasets.md) 

## How to run python as start up script?

You need to redefine the python environment variable to that of your user account

## Spark Streaming - How do I read from multiple topics in the same Spark Session

Initiate a Spark Session

`spark = (SparkSession`  
         `.builder`  
         `.appName(app_name)`  
         `.master(master=master)`  
         `.getOrCreate())`

`spark.streams.resetTerminated()`

`query1 = spark`  
		`.readStream`  
		`…`  
		`…`  
		`.load()`

`query2 = spark`  
		`.readStream`  
		`…`  
		`…`  
		`.load()`

`query3 = spark`  
		`.readStream`  
		`…`  
		`…`  
		`.load()`

`query1.start()`  
`query2.start()`  
`query3.start()`

`spark.streams.awaitAnyTermination() #waits for any one of the query to receive kill signal or error failure. This is asynchronous`

`# On the contrary query3.start().awaitTermination() is a blocking ex call. Works well when we are reading only from one topic.`

## Data Transformation from Databricks to Azure SQL DB

Transformed data can be moved in to azure blob storage and then it can be moved in to azure SQL DB, instead of moving directly from databricks to Azure SQL DB.

## Orchestrating dbt with Airflow

The trial dbt account provides access to dbt API. Job will still be needed to be added manually. Airflow will run the job using a python operator calling the API. You will need to provide api key, job id, etc. (be careful not committing it to Github).

Detailed explanation here: [https://docs.getdbt.com/blog/dbt-airflow-spiritual-alignment](https://docs.getdbt.com/blog/dbt-airflow-spiritual-alignment)

Source code example here: [https://github.com/sungchun12/airflow-toolkit/blob/95d40ac76122de337e1b1cdc8eed35ba1c3051ed/dags/examples/dbt_cloud_example.py](https://github.com/sungchun12/airflow-toolkit/blob/95d40ac76122de337e1b1cdc8eed35ba1c3051ed/dags/examples/dbt_cloud_example.py)

## Orchestrating DataProc with Airflow

[https://airflow.apache.org/docs/apache-airflow-providers-google/stable/_api/airflow/providers/google/cloud/operators/dataproc/index.html](https://airflow.apache.org/docs/apache-airflow-providers-google/stable/_api/airflow/providers/google/cloud/operators/dataproc/index.html)

[https://airflow.apache.org/docs/apache-airflow-providers-google/stable/_modules/airflow/providers/google/cloud/operators/dataproc.html](https://airflow.apache.org/docs/apache-airflow-providers-google/stable/_modules/airflow/providers/google/cloud/operators/dataproc.html)

Give the following roles to you service account:

- DataProc Administrator

- Service Account User (explanation [here](https://stackoverflow.com/questions/63941429/user-not-authorized-to-act-as-service-account-when-using-workload-identity))

Use DataprocSubmitPySparkJobOperator, DataprocDeleteClusterOperator and  DataprocCreateClusterOperator.

When using  DataprocSubmitPySparkJobOperator, do not forget to add:

`dataproc_jars = ["gs://spark-lib/bigquery/spark-bigquery-with-dependencies_2.12-0.24.0.jar"]`

Because DataProc does not already have the BigQuery Connector.

## Orchestrating dbt cloud with Mage

You can trigger your dbt job in Mage pipeline. For this get your dbt cloud api key under settings/Api tokens/personal tokens. Add it safely to  your .env 

For example:

```
dbt_api_trigger=dbt_**
```

Navigate to job page and find api trigger link

Then create a custom mage Python block with a simple http request like [here](https://github.com/Nogromi/ukraine-vaccinations/blob/master/2_mage/vaccination/custom/trigger_dbt_cloud.py)

```python
from dotenv import load_dotenv  
from pathlib import Path  
dotenv_path = Path('/home/src/.env')  
load_dotenv(dotenv_path=dotenv_path)  
dbt_api_trigger = os.getenv('dbt_api_trigger') 

url = f"https://cloud.getdbt.com/api/v2/accounts/{dbt_account_id}/jobs/<job_id>/run/"

headers = {  
    "Authorization": f"Token {dbt_api_trigger}",  
    "Content-Type": "application/json" 
}

body = {  
    "cause": "Triggered via API"  
}  
response = requests.post(url, headers=headers, json=body)
```

Voila! You triggered dbt job from your mage pipeline.

## Key Vault in Azure cloud stack

The key valut in Azure cloud is used to store credentials or passwords or secrets of different tech stack used in Azure. For example if u do not want to expose the password in SQL database, then we can save the password under a given name and use them in other Azure stack.

## How to connect Pyspark with BigQuery?

The following line should be included in pyspark configuration

```python
# Example initialization of SparkSession variable  
spark = (SparkSession.builder  
         .master(...)  
         .appName(...)  
         # Add the following configuration  
         .config("spark.jars.packages", "com.google.cloud.spark:spark-3.5-bigquery:0.37.0")  
)
```

## How to run a dbt-core project as an Airflow Task Group on Google Cloud Composer using a service account JSON key

1. [Install](https://cloud.google.com/composer/docs/composer-2/install-python-dependencies#install_custom_packages_in_a_environment) the [***astronomer-cosmos***](https://github.com/astronomer/astronomer-cosmos) package as a dependency. (see Terraform [example](https://github.com/wndrlxx/ca-trademarks-data-pipeline/blob/4e6a0e757495a99e01ff6c8b981a23d6dc421046/terraform/main.tf#L100)).  
2. Make a new folder, **dbt/**, inside the **dags/** folder of your Composer GCP bucket and copy paste your dbt-core project there. (see [example](https://github.com/wndrlxx/ca-trademarks-data-pipeline/tree/4e6a0e757495a99e01ff6c8b981a23d6dc421046/dags/dbt/ca_trademarks_dp))  
3. Ensure your *profiles.yml* is configured to authenticate with a service account key. (see BigQuery [example](https://docs.getdbt.com/docs/core/connect-data-platform/bigquery-setup#service-account-file))  
4. Create a new DAG using the **DbtTaskGroup** class and a **ProfileConfig** specifying a *profiles\_yml\_filepath* that points to the location of your JSON key file. (see [example](https://github.com/wndrlxx/ca-trademarks-data-pipeline/blob/4e6a0e757495a99e01ff6c8b981a23d6dc421046/dags/6_dbt_cosmos_task_group.py#L47))  
5. Your dbt lineage graph should now appear as tasks inside a task group.

## How can I run UV in Kestra without installing it on every flow execution?

To avoid reinstalling uv on each flow run, you can create a custom Docker image based on the official Kestra image with uv pre-installed. Here's how:

- Create a Dockerfile (e.g., Dockerfile) with the following content:

| FROM kestra/kestra:latestUSER rootRUN pip install uvCMD \["server", "standalone"\] |
| :---- |


- Update your docker-compose.yml to build this custom image instead of pulling the default one:

| *\# image: kestra/kestra:latest*   build:     context: .     dockerfile: Dockerfile |
| :---- |

This approach ensures that uv is available in the container at runtime without requiring installation during each flow execution.

## Is it possible to create external tables in BigQuery using URLs, such as those from the NY Taxi data website?

Answer: Not really, only Bigtable, Cloud Storage, and Google Drive are supported data stores.

## Is it ok to use NY\_Taxi data for the project?

No

## How to use dbt-core with Athena?

If you don’t have access to dbt Cloud which is already natively being supported by AWS, refer here: [1](https://aws.amazon.com/blogs/big-data/from-data-lakes-to-insights-dbt-adapter-for-amazon-athena-now-supported-in-dbt-cloud/), [2](https://youtu.be/JEizJAaaBkg?si=niTYdWoeiyC_w3h7), [3](https://docs.getdbt.com/guides/athena?step=1), & [4](https://docs.getdbt.com/docs/core/connect-data-platform/athena-setup), you can use the community built [dbt-Athena Adapter](https://dbt-athena.github.io/) for dbt-Core.

### Key Features

* Enables dbt to work with AWS Athena using dbt Core  
* Allows data transformation using CREATE TABLE AS or CREATE VIEW SQL queries  
* Not yet supported features:  
  1. Python models  
  2. Persisting documentation for views

This adapter can be a valuable resource for those who need to work with Athena using dbt Core, and I hope this entry can help others discover it.

## Solving dbt-Athena library conflicts

When working on a dbt-Athena project, do not install dbt-athena-adapter. Instead, always use the dbt-athena-community package, ensuring it matches the version of dbt-core to avoid compatibility conflicts.

### Best Practice

* Always pin the versions of dbt-core and dbt-athena-community to the same version.

* Example:

   dbt-core\~=1.9.3

   dbt-athena-community\~=1.9.3

### Why?

* dbt-athena-adapter is outdated and no longer maintained.  
* dbt-athena-community is the actively maintained package and is compatible with the latest versions of dbt-core.

### Steps to Avoid Conflicts

1. Always check the compatibility matrix in the [dbt-athena-community](https://github.com/dbt-labs/dbt-adapters/tree/main/dbt-athena-community) GitHub repository.  
2. Update requirements.txt to use the latest compatible versions of dbt-core and dbt-athena-community.  
3. Avoid mixing dbt-athena-adapter with dbt-athena-community in the same environment.

By following this practice, you can avoid the conflicts we faced previously and ensure a smooth development experience.
