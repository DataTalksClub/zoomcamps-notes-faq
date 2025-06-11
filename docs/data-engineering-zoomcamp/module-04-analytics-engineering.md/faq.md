---
title: FAQ
parent: Module 4
nav_order: 2
---

# Module 4: Analytics Engineering

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

## dbt cloud Developer 

Please be aware that the demos are done using **dbt cloud Developer** licensing. Although Team license is available to you upon creation of dbt cloud account for 14 days, **the interface won't fully match the demo-ed experience.** 

## DBT-Config ERROR on CLOUD IDE: No dbt\_project.yml found at expected path

 (Lower left Corner after setting all connections to BQ and Github)

14:48:39 Running dbt...

14:48:39 Encountered an error:

Runtime Error

  No dbt\_project.yml found at expected path /usr/src/develop/user-70471823426120/environment-70471823422561/repository-70471823410839/dbt\_project.yml

  Verify that each entry within packages.yml (and their transitive dependencies) contains a file named dbt\_project.yml

Solution: Initialize a project through UI. 

Importing git repo of an existing dbt project:

Please read through these details for doing it: [https://docs.getdbt.com/docs/cloud/git/import-a-project-by-git-url](https://docs.getdbt.com/docs/cloud/git/import-a-project-by-git-url)

## DBT Cloud production error: prod dataset not available in location EU 

Problem: I am trying to deploy my DBT  models to production, using DBT Cloud. The data should live in BigQuery.  The dataset location is EU.  However, when I am running the model in production, a prod dataset is being create in BigQuery with a location US and the dbt invoke build is failing giving me "ERROR 404: porject.dataset:prod not available in location EU". I tried different ways to fix this. I am not sure if there is a more simple solution then creating my project or buckets in location US. Hope anyone can help here.

Note: Everything is working fine in development mode, the issue is just happening when scheduling and running job in production

Solution: I created the prod dataset manually in BQ and specified EU, then I ran the job.

## How do I solve the Dbt Cloud error: prod was not found in location?

You might get this error while trying to run dbt in production aftering following the instructions in the video ‘DE Zoomcamp 4.4.1 \- Deployment Using dbt Cloud (Alternative A’):  
Database Error in model stg\_yellow\_tripdata (models/staging/stg\_yellow\_tripdata.sql)  
Not found: Dataset module-4-analytics-eng:prod was not found in location europe-west10

This error is easily solved. There are two solutions  to solve this issue:

Solution \#1: Matching the dataset's data location with the source dataset

Set your ‘prod’ dataset's data location to match the data location of your ‘trips\_data\_all’ dataset's data location (in BigQuery). Running dbt in production works for the  instructor, because her ‘ prod’ is in the same region as her source data. Since your ‘trips\_data\_all’ is in europe-west10 (or anything else besides US), your prod needs to be there too; not US (which is a default setting when dbt creates a dataset for you in BigQuery).

Solution \#2: Changing the dataset to \<development dataset\>

Go into your dbt production environment settings:  
1\. Go to: Deploy / Environments / Production (your production environment) / Settings  
2\. Now look at the Deployment credentials. There is an input field here called Dataset. The input of ‘prod’ is likely in here.  
3\. Replace ‘prod’ with the name of the Dataset that you worked with while in development (before moving to Production). This is the Dataset name inside your BigQuery where you successfully ran ‘dbt debug’ and ‘dbt build’ with.  
4\. After saving, you are ready to rerun your Job\!

## 

## Setup \- No development environment 

Error: This project does not have a development environment configured. Please create a development environment and configure your development credentials to use the dbt IDE.

The error itself tells us how to solve this issue, the guide is [here](https://github.com/DataTalksClub/data-engineering-zoomcamp/blob/main/04-analytics-engineering/dbt_cloud_setup.md). And from [videos @1:42](https://youtu.be/J0XCDyKiU64?si=2CTg3H63wyJTf5Vy&t=102) and also [slack chat](https://datatalks-club.slack.com/archives/C01FABYF2RG/p1708030955851629)

## Setup \- Connecting dbt Cloud with BigQuery Error

Runtime Error

dbt was unable to connect to the specified database.

  The database returned the following error:

 \>Database Error

Access Denied: Project \<project\_name\>: User does not have bigquery.jobs.create permission in project \<project\_name\>.

Check your database credentials and try again. For more information, visit:

https://docs.getdbt.com/docs/configure-your-profile

Steps to resolve error in Google Cloud:

1\. Navigate to **IAM & Admin** and select **IAM**

2\. Click **Grant Access** if your newly created dbt service account isn't listed

3\. In ***New principals*** field, add your service account

4\. Select a **Role** and search for **BigQuery Job User** to add

5\. Go back to *dbt cloud project setup* and Test your connection

6\. ***Note***: Also add **BigQuery Data Owner**, **Storage Object Admin**, & **Storage Admin** to prevent permission issues later in the course

## Setup \- Failed to clone repository.

Error: Failed to clone repository.  
git clone git@github.com:DataTalksClub/data-engineering-zoomcamp.git /usr/src/develop/…  
Cloning into '/usr/src/develop/...  
Warning: Permanently added '[github.com](http://github.com/),140.82.114.4' (ECDSA) to the list of known hosts.  
git@github.com: Permission denied (publickey).  
fatal: Could not read from remote repository.

Issue: You don’t have permissions to write to DataTalksClub/data-engineering-zoomcamp.git

Solution 1: Clone the repository and use this forked repo, which contains your github username. Then, proceed to specify the path, as in:

\[your github username\]/data-engineering-zoomcamp.git

Solution 2: create a fresh repo for dbt-lessons. We’d need to do branching and PRs in this lesson, so it might be a good idea to also not mess up your whole other repo. Then you don’t have to create a subfolder for the **dbt** project files

Solution 3: Use https link

## Errors when I start the server in dbt cloud: Failed to start server. Permission denied (publickey)

Failed to start server. Permission denied (publickey). fatal: Could not read from remote repository. Please make sure you have the correct access rights and the repository exists.

Use the deploy keys in dbt repo details to create a public key in your repo, the issue will be solved.

Steps in details:

1. **Find dbt Cloud’s SSH Key**

   * In dbt Cloud, go to **Settings \> Account Settings \> SSH Keys**

   * Copy the **public SSH key** displayed there.

2. **Add It to GitHub**

   * Go to **GitHub \> Settings \> SSH and GPG Keys**

   * Click **"New SSH Key"**, name it "dbt Cloud", and paste the key.

   * Click **"Add SSH Key"**.

3. **Try Restarting dbt Cloud**

## dbt job \- Triggered by pull requests is disabled prerequisites when I try to create a new Continuous Integration job in dbt cloud. 

**Solution:**

Check if you’re on the Developer Plan. As per the [prerequisites](https://docs.getdbt.com/docs/deploy/ci-jobs#prerequisites), you'll need to be enrolled in the Team Plan or Enterprise Plan to set up a CI Job in dbt Cloud.

So If you're on the Developer Plan, you'll need to upgrade to utilise CI Jobs.

*Note from another user:* I’m in the Team Plan (trial period) but the option is still disabled. What worked for me instead was [this](#dbt-deploy-+-git-ci---cannot-create-ci-checks-job-for-deployment-to-production.-see-more-discussion-in-slack-chat). It works for the Developer (free) plan.

## Setup \- Your IDE session was unable to start. Please contact support.

**Issue:** If the DBT cloud IDE loading indefinitely then giving you this error

**Solution:** check the dbt\_cloud\_setup.md  file and make a SSH Key and use gitclone to import repo into dbt project, copy and paste deploy key back in your repo setting.

## DBT \- I am having problems with columns datatype while running DBT/BigQuery

**Issue:** If you don’t define the column format while converting from csv to parquet Python will “choose” based on the first rows.

**✅Solution:** Defined the schema while running `web_to_gcp.py` pipeline.

Sebastian adapted the script:

[https://github.com/sebastian2296/data-engineering-zoomcamp/blob/main/week\_4\_analytics\_engineering/web\_to\_gcs.py](https://github.com/sebastian2296/data-engineering-zoomcamp/blob/main/week_4_analytics_engineering/web_to_gcs.py) 

Need a quick change to make the file work with gz files, added the following lines (and don’t forget to delete the file at the end of each iteration of the loop to avoid any problem of disk space) 

file\_name\_gz \= f"{service}\_tripdata\_{year}-{month}.[csv.gz](http://csv.gz)"

open(file\_name\_gz, 'wb').write(r.content)

os.system(f"gzip \-d {file\_name\_gz}")

os.system(f"rm {file\_name\_init}.\*")

## “Parquet column 'ehail\_fee' has type DOUBLE which does not match the target cpp\_type INT64”

**Reason:** Parquet files have their own schema. Some parquet files for green data have records with decimals in ehail\_fee column.

There are some possible fixes:

Drop ehail\_feel column since it is not really used. For instance when creating a partitioned table from the external table in BigQuery 

`SELECT * EXCEPT (ehail_fee) FROM…` 

Modify stg\_green\_tripdata.sql model using this line cast(0 as numeric) as ehail\_fee.

Modify Airflow dag to make the conversion and avoid the error. 

`pv.read_csv(src_file, convert_options=pv.ConvertOptions(column_types = {'ehail_fee': 'float64'}))`

**Same type of ERROR \- parquet files with different data types \- Fix it with pandas**

Here is another possibility that could be interesting:

You can specify the dtypes when importing the file from csv to a dataframe with pandas 

pd.from\_csv(..., dtype=type\_dict)

One obstacle is that the regular int64 pandas use (I think this is from the numpy library) does not accept null values (NaN, not a number). But you can use the pandas Int64 instead, notice capital ‘I’. The type\_dict is a python dictionary mapping the column names to the dtypes.

Sources:

[https://pandas.pydata.org/docs/reference/api/pandas.read\_csv.html](https://pandas.pydata.org/docs/reference/api/pandas.read_csv.html)

[Nullable integer data type — pandas 1.5.3 documentation](https://pandas.pydata.org/docs/user_guide/integer_na.html)

## Ingestion: When attempting to use the provided quick script to load trip data into GCS, you receive error Access Denied from the S3 bucket

If the provided URL isn’t working for you (https://nyc-tlc.s3.amazonaws.com/trip+data/):

We can use the GitHub CLI to easily download the needed trip data from https://github.com/DataTalksClub/nyc-tlc-data, and manually upload to a GCS bucket.

Instructions on how to download the CLI here: https://github.com/cli/cli

Commands to use:

gh auth login

gh release list \-R DataTalksClub/nyc-tlc-data

gh release download yellow \-R DataTalksClub/nyc-tlc-data

gh release download green \-R DataTalksClub/nyc-tlc-data

etc.

Now you can upload the files to a GCS bucket using the GUI.

## Hack to load yellow and green trip data for 2019 and 2020

I initially followed [data-engineering-zoomcamp/03-data-warehouse/extras/web\_to\_gcs.py at main · DataTalksClub/data-engineering-bootcamp (github.com)](https://github.com/DataTalksClub/data-engineering-zoomcamp/blob/main/03-data-warehouse/extras/web_to_gcs.py)

But it was taking forever for the yellow trip data and when I tried to download and upload the parquet files directly to GCS, that works fine but when creating the Bigquery table, there was a schema inconsistency issue

Then I found another hack shared in the slack which was suggested by Victoria. 

[\[Optional\] Hack for loading data to BigQuery for Week 4 \- YouTube](https://www.youtube.com/watch?v=Mork172sK_c&t=22s&ab_channel=Victoria)

Please watch until the end as there is few schema changes required to be done

## GCP VM \- All of sudden ssh stopped working for my VM after my last restart

One common cause experienced is lack of space after running prefect several times. When running prefect, check the folder ‘.prefect/storage’ and delete the logs now and then to avoid the problem. 

## GCP FREE TRIAL ACCOUNT ERROR

If you're encountering an error when trying to create a GCP free trial account, the issue isn’t related to country restrictions, credit/debit card problems, or IP issues, it's a random problem with no clear logical reason behind it. Here’s a simple workaround that worked for me:

I asked a few friends in my country to try signing up for the free trial using their Gmail accounts and their debit/credit cards. One of them was able to successfully create the account, and I’m temporarily using their Gmail to access the trial.

If you're still running into the issue, this method could help you bypass the problem\!

## GCP VM \- If you have lost SSH access to your machine due to lack of space. Permission denied (publickey)

You can try to do this steps:

![][image38]

## DBT \- When running your first dbt model, if it fails with an error: 

* 404 Not found: Dataset was not found in location US  
* 404 Not found: Dataset eighth-zenith-372015:trip\_data\_all was not found in location us-west1

**R:** Go to BigQuery, and check the location of BOTH

1. The source dataset (trips\_data\_all), and

2. The schema you’re trying to write to (name should be 	dbt\_\<first initial\>\<last name\> (if you didn’t change the default settings at the end when setting up your project))

Likely, your source data will be in your region, but the write location will be a multi-regional location (US in this example). Delete these datasets, and recreate them with your specified region and the correct naming format.

Alternatively, instead of removing datasets, you can specify the single-region location you are using. E.g. instead of `‘location: US`’, specify the region, so `‘location: US-east1`’. See [this Github comment](https://github.com/dbt-labs/dbt-bigquery/issues/19#issuecomment-635545315) for more detail. Additionally please see [this post of Sandy](https://learningdataengineering540969211.wordpress.com/dbt-cloud-and-bigquery-an-effort-to-try-and-resolve-location-issues/)

 In ***DBT cloud*** you can actually specify the location using the following steps:

1. **GPo** to your profile page (top right drop-down \--\> profile)

2. Then **go** to under Credentials \--\> Analytics (you may have customised this name)

3. **Click** on Bigquery \>

4. **Hit** Edit

5. **Update** your location, you may need to re-upload your service account JSON to re-fetch your private key, and **save. (NOTE:** be sure to exactly copy the region BigQuery specifies your dataset is in.**)**

## DBT \- When executing dbt run after installing dbt-utils latest version i.e., 1.0.0 warning has generated

Error: \`dbt\_utils.surrogate\_key\` has been replaced by \`dbt\_utils.generate\_surrogate\_key\`

Fix:

Replace dbt\_utils.surrogate\_key  with dbt\_utils.generate\_surrogate\_key in stg\_green\_tripdata.sql

## When executing dbt run after fact\_trips.sql has been created, the task failed with error:  “Access Denied: BigQuery BigQuery: Permission denied while globbing file pattern.”

1\. Fixed by adding the Storage Object Viewer role to the service account in use in BigQuery.

2\. Add the related roles to the service account in use in GCS.

![][image39]

## When You are getting error dbt\_utils not found

You need to create packages.yml file in main project directory and add packages’ meta data: 

packages:

  \- package: dbt-labs/dbt\_utils

	version: 0.8.0

After creating file run:

dbt deps

And hit enter.

## Lineage is currently unavailable. Check that your project does not contain compilation errors or contact support if this error persists.

Ensure you properly format your yml file. Check the build logs if the run was completed successfully. You can expand the command history console (where you type the \--vars '{'is\_test\_run': 'false'}')  and click on any stage’s logs to expand and read errors messages or warnings.

## Build \- Why do my Fact\_trips only contain a few days of data?

Make sure you use:

* dbt run \--var ‘is\_test\_run: false’ or   
* dbt build \--var ‘is\_test\_run: false’  

(watch out for formatted text from this document: re-type the single quotes). If that does not work, use \--vars '{'is\_test\_run': 'false'}' with each phrase separately quoted.

## Build \- Why do my fact\_trips only contain one month of data?

Check if you specified if\_exists argument correctly when writing data from GCS to BigQuery. When I wrote my automated flow for each month of the years 2019 and 2020 for green and yellow data I had specified if\_exists="replace" while I was experimenting with the flow setup. Once you want to run the flow for all months in 2019 and 2020 make sure to set if\_exists="append" 

- if\_exists="replace" will replace the whole table with only the month data that you are writing into BigQuery in that one iteration \-\> you end up with only one month in BigQuery (the last one you inserted)

- if\_exists="append" will append the new monthly data \-\> you end up with data from all months

## BigQuery returns an error when I try to run the dm\_monthly\_zone\_revenue.sql model.

R: After the second SELECT, change this line:

`date_trunc('month', pickup_datetime) as revenue_month,`

To this line:

`date_trunc(pickup_datetime, month) as revenue_month,`

Make sure that “month” isn’t surrounded by quotes\!

## DBT \- Warning: dbt\_utils.surrogate\_key has been replaced by dbt\_utils.generate\_surrogate\_key. The new macro treats null values(...)To restore the behaviour of the original macro, 

## **That means the surrogate\_key has been deprecated, and it indicates you should replace it with the new method \`generate\_surrogate\_key\`**

## **Replace:**  
```sql
{{ dbt_utils.surrogate_key([
     field_a,
     field_b,
     field_c,
     …,
     field_z
]) }}
```

**For this instead:**  
```sql
{{ dbt_utils.generate_surrogate_key([
     field_a,
     field_b,
     field_c,
     …,
     field_z
]) }}
```

add a global variable in dbt\_project.yml(...)

## Warning: \`dbt\_utils.surrogate\_key\` has been replaced by 

## \`dbt\_utils.generate\_surrogate\_key\`. The new macro treats null values differently to empty strings. To restore the behaviour of the original macro, add a global variable in dbt\_project.yml called \`surrogate\_key\_treat\_nulls\_as\_empty\_strings\` to your dbt\_project.yml file with a value of True. The taxi\_rides\_ny.stg\_yellow\_tripdata model triggered this warning.

## I changed location in dbt, but dbt run still gives me an error

Remove the dataset from BigQuery which was created by dbt and run dbt run again so that it will recreate the dataset in BigQuery with the correct location

## DBT \- I ran dbt run without specifying variable which gave me a table of 100 rows. I ran again with the variable value specified but my table still has 100 rows in BQ.

Remove the dataset from BigQuery created by dbt and run again (with test disabled) to ensure the dataset created has all the rows.

DBT \- Why am I getting a new dataset after running my CI/CD Job? / What is this new dbt dataset in BigQuery? 

**Answer:** *when you create the CI/CD job, under ‘Compare Changes against an environment (Deferral) make sure that you select ‘ No; do not defer to another environment’ \- otherwise dbt won’t merge your dev models into production models; it will create a new environment called ‘dbt\_cloud\_pr\_number of pull request’*

![][image40]

## **![][image41]**

## Why do we need the Staging dataset?

Vic created three different datasets in the videos.. dbt\_\<name\> was used for development and you used a production dataset for the production environment. What was the use for the staging dataset?

**R**: Staging, as the name suggests, is like an intermediate between the raw datasets and the fact and dim tables, which are the finished product, so to speak. You'll notice that the datasets in staging are materialised as views and not tables.

Vic didn't use it for the project, you just need to create production and dbt\_name \+ trips\_data\_all that you had already.

## DBT \- Docs Served but Not Accessible via Browser

Try removing the “network: host” line in docker-compose. 

## BigQuery adapter: 404 Not found: Dataset was not found in location europe-west6

1. Go to Account settings \>\> Project \>\> Analytics \>\> Click on your connection \>\> go all the way down to Location and type in the GCP location just as displayed in GCP (e.g. europe-west6). You might need to reupload your GCP key.  
2. Delete your dataset in GBQ   
3. Rebuild project: dbt build  
4. Newly built dataset should be in the correct location

## Dbt+git \- Main branch is “read-only”

Create a new branch to edit. More on this can be found [here in the dbt docs](https://docs.getdbt.com/docs/collaborate/git/version-control-basics).

## Dbt+git \- It appears that I can't edit the files because I'm in read-only mode. Does anyone know how I can change that?

Create a new branch for development, then you can merge it to the main branch

Create a new branch and switch to this branch. It allows you to make changes. Then you can commit and push the changes to the “main” branch.

## Dbt deploy \+ Git CI \- cannot create CI checks job for deployment to Production. See more discussion in [slack chat](https://datatalks-club.slack.com/archives/C01FABYF2RG/p1707972535660619) {#dbt-deploy-+-git-ci---cannot-create-ci-checks-job-for-deployment-to-production.-see-more-discussion-in-slack-chat}

Error: 

Triggered by pull requests

This feature is only available for dbt repositories connected through dbt Cloud's native integration with Github, Gitlab, or Azure DevOps

Solution: Contrary to the [guide on DTC repo](https://github.com/DataTalksClub/data-engineering-zoomcamp/blob/main/04-analytics-engineering/dbt_cloud_setup.md), don’t use the **Git Clone** option. Use the **Github** one instead. Step-by-step guide to UN-LINK **Git Clone** and RE-LINK with **Github** in the next entry below

![][image42]

## Dbt deploy \+ Git CI \- Unable to configure Continuous Integration (CI) with Github

If you’re trying to configure CI with Github and on the job’s options you can’t see **Run on Pull Requests?** on triggers, you have to reconnect with Github using native connection instead clone by SSH. Follow these steps:

1. On **Profile Settings \> Linked Accounts** connect your Github account with dbt project allowing the permissions asked. More info at [https://docs.getdbt.com/docs/collaborate/git/connect-gith](https://docs.getdbt.com/docs/collaborate/git/connect-github)

2. 

   ![][image43]

   

3. Disconnect your current Github’s configuration from ***Account Settings \> Projects (analytics)** **\> Github connection.*** At the bottom left appears the button *Disconnect,* press it.

   

4. Once we have confirmed the change, we can configure it again. This time, choose *Github* and it will appear in all repositories which you have allowed to work with dbt. Select your repository and it’s ready.

   *![][image44]*

   

5. Go to the **Deploy \> job** configuration’s page and go down until ***Triggers*** and now you can see the option *Run on Pull Requests*:

   ![][image45]

## Compilation Error (Model 'model.my\_new\_project.stg\_green\_tripdata' (models/staging/stg\_green\_tripdata.sql) depends on a source named 'staging.green\_trip\_external' which was not found)

If you're following video DE Zoomcamp 4.3.1 \- Building the First DBT Models, you may have encountered an issue at 14:25 where the Lineage graph isn't displayed and a Compilation Error occurs, as shown in the attached image. Don't worry \- a quick fix for this is to simply **save your schema.yml** file. Once you've done this, you should be able to view your Lineage graph without any further issues.

![][image46]

## Compilation Error in test accepted\_values\_stg\_green\_tripdata\_Payment\_type\_\_False\_\_\_var\_payment\_type\_values\_ (models/staging/schema.yml)  'NoneType' object is not iterable

  `> in macro test_accepted_values (tests/generic/builtin.sql)`

 `> called by test accepted_values_stg_green_tripdata_Payment_type__False___var_payment_type_values_ (models/staging/schema.yml)`

Remember that you have to add to dbt\_project.yml the vars:

vars:

  payment\_type\_values: \[1, 2, 3, 4, 5, 6\]

## dbt macro errors with get\_payment\_type\_description(payment\_type)

You will face this issue if you copied and pasted the exact macro directly from data-engineering-zoomcamp repo.

BigQuery adapter: Retry attempt 1 of 1 after error: BadRequest('No matching signature for operator CASE for argument types: STRING, INT64, STRING, INT64, STRING, INT64, STRING, INT64, STRING, INT64, STRING, INT64, STRING, NULL at \[35:5\]; reason: invalidQuery, location: query, message: No matching signature for operator CASE for argument types: STRING, INT64, STRING, INT64, STRING, INT64, STRING, INT64, STRING, INT64, STRING, INT64, STRING, NULL at \[35:5\]')

What you’d have to do is to change the data type of the numbers (1, 2, 3 etc.) to text by inserting ‘’, as the initial ‘payment\_type’ data type should be string (Note: I extracted and loaded the green trips data using Google BQ Marketplace)

 {\#

    This macro returns the description of the payment\_type

\#}

{% macro get\_payment\_type\_description(payment\_type) \-%}

    case {{ payment\_type }}

        when '1' then 'Credit card'

        when '2' then 'Cash'

        when '3' then 'No charge'

        when '4' then 'Dispute'

        when '5' then 'Unknown'

        when '6' then 'Voided trip'

    end

{%- endmacro %}

![][image47]

## Troubleshooting in dbt:

The dbt error  log contains a link to BigQuery. When you follow it you will see your query and the problematic line will be highlighted.

## DBT \- Why changing the target schema to “marts” actually creates a schema named “dbt\_marts” instead?

It is a default behaviour of dbt to [append custom schema to initial schema](https://docs.getdbt.com/docs/build/custom-schemas#why-does-dbt-concatenate-the-custom-schema-to-the-target-schema). To override this behaviour simply create a macro named “generate\_schema\_name.sql”:

{% macro generate\_schema\_name(custom\_schema\_name, node) \-%}  
    {%- set default\_schema \= target.schema \-%}  
    {%- if custom\_schema\_name is none \-%}  
        {{ default\_schema }}  
    {%- else \-%}  
        {{ custom\_schema\_name | trim }}  
    {%- endif \-%}  
{%- endmacro %}

Now you can override default custom schema in “dbt\_project.yml”:

## How to set subdirectory of the github repository as the dbt project root

There is a project setting which allows you to set \`Project subdirectory\` in dbt cloud:

![][image48]

## Compilation Error : Model 'model.XXX' (models/\<model\_path\>/XXX.sql) depends on a source named '\<a table name\>' which was not found

Remember that you should modify accordingly your .sql models, to read from existing table names in BigQuery/postgres db

Example: select \* from {{ source('staging',\<your table name in the database\>') }}

## Compilation Error : Model '\<model\_name\>' (\<model\_path\>) depends on a node named '\<seed\_name\>' which was not found   (Production Environment)

Make sure that you create a pull request from your Development branch to the Production branch (main by default). After that, check in your ‘seeds’ folder if the seed file is inside it.  
Another thing to check is your .gitignore file. Make sure that the .csv extension is not included.

## When executing dbt run after using fhv\_tripdata as an external table**: you** get “Access Denied: BigQuery BigQuery: Permission denied”

1\. Go to your dbt cloud service account

1\. Adding the  \[Storage Object Admin,Storage Admin\] role in addition tco BigQuery Admin.

## How to automatically infer the column data type (pandas missing value issues)?

Problem: when injecting data to bigquery, you may face the type error. This is because pandas by default will parse integer columns with missing value as float type. 

Solution: 

- One way to solve this problem is to specify/ cast data type Int64 during the data transformation stage.

- However, you may be lazy to type all the int columns. If that is the case, you can simply use convert\_dtypes to infer the data type

    *\# Make pandas to infer correct data type (as pandas parse int with missing as float)*

    df.fillna(-999999, inplace=True)ingesting

    df \= df.convert\_dtypes()

    df \= df.replace(-999999, None)

## When loading github repo raise exception that ‘taxi\_zone\_lookup’ not found

Seed files loaded from directory with name ‘seed’, that’s why you should rename dir with name ‘data’ to ‘seed’

## ‘taxi\_zone\_lookup’ not found

Check the .gitignore file and make sure you don’t have \*.csv in it

Dbt error 404 was not found in location

My specific error:  
Runtime Error in rpc request (from remote system.sql) 404 Not found: Table dtc-de-0315:trips\_data\_all.green\_tripdata\_partitioned was not found in location europe-west6 Location: europe-west6 Job ID: 168ee9bd-07cd-4ca4-9ee0-4f6b0f33897c

Make sure all of your datasets have the correct region and not a generalised region:  
Europe-west6 as opposed to EU

Match this in dbt settings:  
dbt \-\> projects \-\> optional settings \-\> manually set location to match

## Data type errors when ingesting with parquet files 

The easiest way to avoid these errors is by ingesting the relevant data in a .csv.gz file type. Then, do:

CREATE OR REPLACE EXTERNAL TABLE \`dtc-de.trips\_data\_all.fhv\_tripdata\`

OPTIONS (

  format \= 'CSV',

  uris \= \['gs://dtc\_data\_lake\_dtc-de-updated/data/fhv\_all/fhv\_tripdata\_2019-\*.csv.gz'\]

);

As an example. You should no longer have any data type issues for week 4\.

## Inconsistent number of rows when re-running fact\_trips model

This is due to the way the deduplication is done in the two staging files.

Solution: add `order by` in the `partition by` part of both staging files. Keep adding columns to order by until the number of rows in the fact\_trips table is consistent when re-running the fact\_trips model.

Explanation (a bit convoluted, feel free to clarify, correct etc.)

We partition by vendor id and pickup\_datetime and choose the first row (rn=1) from all these partitions. These partitions are not ordered, so every time we run this, the first row might be a different one. Since the first row is different between runs, it might or might not contain an unknown borough. Then, in the fact\_trips model we will discard a different number of rows when we discard all values with an unknown borough.

## Data Type Error when running fact table

If you encounter data type error on trip\_type column, it may due to some nan values that isn’t null in bigquery.

Solution: try casting it to FLOAT datatype instead of NUMERIC

## CREATE TABLE has columns with duplicate name locationid.

This error could result if you are using some select \* query without mentioning the name of table for ex: 

with dim\_zones as (

    select \* from \`engaged-cosine-374921\`.\`dbt\_victoria\_mola\`.\`dim\_zones\`

    where borough \!= 'Unknown'

),

fhv as (

    select \* from \`engaged-cosine-374921\`.\`dbt\_victoria\_mola\`.\`stg\_fhv\_tripdata\`

)

**select \* from fhv**

inner join dim\_zones as pickup\_zone

on fhv.PUlocationID \= pickup\_zone.locationid

inner join dim\_zones as dropoff\_zone

on fhv.DOlocationID \= dropoff\_zone.locationid

    );

To resolve just replace use : **select fhv.\* from fhv**

## Bad int64 value: 0.0 error

Some ehail fees are null and casting them to integer gives Bad int64 value: 0.0 error, 

Solution:

Using safe\_cast returns NULL instead of throwing an error. So use safe\_cast from dbt\_utils function in the jinja code for casting into integer as follows:

 {{ dbt\_utils.safe\_cast('ehail\_fee',  api.Column.translate\_type("integer"))}} as ehail\_fee,

Can also just use safe\_cast(ehail\_fee as integer) without relying on dbt\_utils.

## Bad int64 value: 2.0/1.0 error

You might encounter this when building the fact\_trips.sql model. The issue may be with the **payment\_type\_description** field. 

Using safe\_cast as above, would cause the entire field to become null. A better approach is to drop the offending decimal place, then cast to integer. 

cast(replace({{ payment\_type }},'.0','') as integer)

## Bad int64 value: 1.0 error (again)

I found that there are more columns causing the bad INT64: ratecodeid and trip\_type on Green\_tripdata table.  
You can use the queries below to address them:

`CAST(`

        `REGEXP_REPLACE(CAST(rate_code AS STRING), r'\.0', '') AS INT64`

    `) AS ratecodeid,`

`CAST(`

        `CASE`

            `WHEN REGEXP_CONTAINS(CAST(trip_type AS STRING), r'\.\d+') THEN NULL`

            `ELSE CAST(trip_type AS INT64)`

        `END AS INT64`

    `) AS trip_type,`

## DBT \- Error on building fact\_trips.sql: Parquet column 'ehail\_fee' has type DOUBLE which does not match the target cpp\_type INT64. File: gs://\<gcs bucket\>/\<table\>/green\_taxi\_2019-01.parquet")

The two solution above don’t work for me \- I used the line below in \`stg\_green\_trips.sql\` to replace the original ehail\_fee line:

\`{{ dbt.safe\_cast('ehail\_fee',  api.Column.translate\_type("numeric"))}} as ehail\_fee,\`

## The \- vars argument must be a YAML dictionary, but was of type str

Remember to add a space between the variable and the value. Otherwise, it won't be interpreted as a dictionary.

It should be:

dbt run \--var 'is\_test\_run: false'

Not able to change Environment Type as it is greyed out and inaccessibleYou don't need to change the environment type. If you are following the videos, you are creating a Production Deployment, so the only available option is the correct one.'

## Access Denied: Table yellow\_tripdata: User does not have permission to query table yellow\_tripdata, or perhaps it does not exist in location US.

![][image49]

Database Error in model stg\_yellow\_tripdata (models/staging/stg\_yellow\_tripdata.sql)

  Access Denied: Table taxi-rides-ny-339813-412521:trips\_data\_all.yellow\_tripdata: User does not have permission to query table taxi-rides-ny-339813-412521:trips\_data\_all.yellow\_tripdata, or perhaps it does not exist in location US.

  compiled Code at target/run/taxi\_rides\_ny/models/staging/stg\_yellow\_tripdata.sql

In my case, I was set up in a different branch, so always check the branch you are working on. Change the 04-analytics-engineering/taxi\_rides\_ny/models/staging/**schema.yml** file in the 

sources:

  \- name: staging

    database: your\_database\_name

If this error will continue when running dbt job, As for changing the branch for your job, you can use the ‘Custom Branch’ settings in your dbt Cloud environment. This allows you to run your job on a different branch than the default one (usually main). To do this, you need to:

Go to an environment and select Settings to edit it

Select Only run on a custom branch in General settings

Enter the name of your custom branch (e.g. HW)

Click Save

## Could not parse the dbt project. please check that the repository contains a valid dbt project

Running the Environment on the master branch causes this error, you must activate “Only run on a custom branch” checkbox and specify the branch you are working when Environment is setup.

![][image50]

## Made change to your modelling files and commit the your development branch, but Job still runs on old file?

Change to main branch, make a pull request from the development branch.  
Note: this will take you to github.  
Approve the merging and rerun you job, it would work as planned now

## Setup \- I’ve set Github and Bigquery to dbt successfully. Why nothing showed in my Develop tab?

Before you can develop some data model on dbt, you should create development environment and set some parameter on it. After the model being developed, we should also create deployment environment to create and run some jobs.

## BigQuery returns an error when i try to run ‘dbt run’: 

My taxi data was loaded into gcs with etl\_web\_to\_gcs.py script that converts csv data into parquet. Then I placed raw data trips into external tables and when I executed dbt run I got an error message: Parquet column 'passenger\_count' has type INT64 which does not match the target cpp\_type DOUBLE. It is because several columns in files have different formats of data. 

When I added df\[col\] \= df\[col\].astype('Int64') transformation to the columns: passenger\_count, payment\_type, RatecodeID, VendorID, trip\_type it went ok. Several people also faced this error and more about it you can read on the slack channel.

## DBT \- Running dbt run \--models stg\_green\_tripdata \--var 'is\_test\_run: false' is not returning anything:

Use the syntax below instead if the code in the tutorial is not working. 

dbt run \--select stg\_green\_tripdata \--vars '{"is\_test\_run": false}'

## DBT \- Error: No module named 'pytz' while setting up dbt with docker 

Following dbt with [BigQuery on Docker readme.md](https://github.com/DataTalksClub/data-engineering-zoomcamp/blob/main/04-analytics-engineering/docker_setup/README.md), after \`docker-compose build\` and \`docker-compose run dbt-bq-dtc init\`, encountered error \`ModuleNotFoundError: No module named 'pytz'\`

Solution:

Add \`**RUN python \-m pip install \--no-cache pytz**\` in the **Dockerfile** under \`FROM \--platform=$build\_for python:3.9.9-slim-bullseye as base\`

## ​​VS Code: NoPermissions (FileSystemError): Error: EACCES: permission denied (linux)

If you have problems editing *dbt\_project.yml* when using Docker after ‘docker-compose run dbt-bq-dtc init’, to change profile ‘taxi\_rides\_ny’ to 'bq-dbt-workshop’, just run:

sudo chown \-R username path  


DBT \- Internal Error: Profile should not be None if loading is completed

When  running `dbt debug`, change the directory to the newly created subdirectory (e.g: the newly created \`taxi\_rides\_ny\` directory, which contains the dbt project).

## Google Cloud BigQuery Location Problems

When running a query on BigQuery sometimes could appear a this table is not on the specified location error.

For this problem there is not a straightforward solution, you need to dig a little, but the problem could be one of these:

- Check the locations of your bucket, datasets and tables. Make sure they are all on the same one.  
- Change the query settings to the location you are in: on the query window select more \-\> query settings \-\> select the location  
- Check if all the paths you are using in your query to your tables are correct: you can click on the table \-\> details \-\> and copy the path.

## DBT Deploy \- This dbt Cloud run was cancelled because a valid dbt project was not found.

1. This happens because we have moved the dbt project to another directory on our repo.   
2. Or might be that you’re on a different branch than is expected to be merged from / to.

Solution:

Go to the projects window on dbt cloud \-\> settings \-\> edit \-\> and add directory (the extra path to the dbt project)

For example:

/week5/taxi\_rides\_ny

Make sure your file explorer path and this Project settings path matches and there’s no files waiting to be committed to github if you’re running the job to deploy to PROD. 

![][image51]

![][image52]

And that you had setup the PROD environment to check in the main branch, or whichever you specified. 

In the picture below, I had set it to ella2024 to be checked as “production-ready” by the “freshness” check mark at the PROD environment settings. So each time I merge a branch from something else into ella2024 and then trigger the PR, the CI check job would kick-in. But we still do need to Merge and close the PR manually, I believe, that part is not automated. 

![][image53]

You set up the PROD custom branch (if not default main) in the Environment setup screen.

![][image54]

## DBT Deploy \+ CI \- Location Problems on BigQuery

When you are creating the pull request and running the CI, dbt is creating a new schema on BIgQuery. By default that new schema will be created on ‘US’ location, if you have your dataset, schemas and tables on ‘EU’ that will generate an error and the pull request will not be accepted. To change that location to ‘EU’ on the connection to BigQuery from dbt we need to add the location ‘EU’ on the connection optional settings:

Dbt \-\> project \-\> settings \-\> connection BIgQuery \-\> OPtional Settings \-\> Location \-\> EU

## DBT Deploy \- Error When trying to run the dbt project on Prod

When running trying to run the dbt project on prod there is some things you need to do and check on your own:

- First Make the pull request and Merge the branch into the main.  
- Make sure you have the latest version, if you made changes to the repo in another place.  
- Check if the dbt\_project.yml file is accessible to the project, if not check this solution (Dbt: This dbt Cloud run was cancelled because a valid dbt project was not found.).  
- Check if the name you gave to the dataset on BigQuery is the same you put on the dataset spot on the production environment created on dbt cloud.

## DBT \- Error: “404 Not found: Dataset \<dataset\_name\>:\<dbt\_schema\_name\> was not found in location EU” after building from stg\_green\_tripdata.sql

In the step in [this video](https://www.youtube.com/watch?v=ueVy2N54lyc&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=44) (DE Zoomcamp 4.3.1 \- Build the First dbt Models), after creating \`stg\_green\_tripdata.sql\` and clicking \`build\`, I encountered an error saying dataset not found in location EU. The default location for dbt Bigquery is the US, so when generating the new Bigquery schema for dbt, unless specified, the schema locates in the US. 

Solution:   
Turns out I forgot to specify **Location** to be \`**EU**\` when adding connection details. 

**Develop \-\> Configure Cloud CLI \-\> Projects \-\> taxi\_rides\_ny \-\> (connection) Bigquery \-\> Edit \-\> Location (Optional) \-\> type \`EU\` \-\> Save**

## Homework \- Ingesting FHV\_20?? data

Issue: If you’re having problems loading the FHV\_20?? data from the github repo into GCS and then into BQ (input file not of type parquet), you need to do two things. First, append the URL Template link with ‘?raw=true’ like so:

`URL_TEMPLATE = URL_PREFIX + "/fhv_tripdata_{{ execution_date.strftime(\'%Y-%m\') }}.parquet?raw=true"`

Second, update make sure the URL\_PREFIX is set to the following value:

`URL_PREFIX = "https://github.com/alexeygrigorev/datasets/blob/master/nyc-tlc/fhv"`

It is critical that you use this link with the keyword blob. If your link has ‘tree’ here, replace it. Everything else can stay the same, including the curl \-sSLf command. ‘

## Ingesting FHV : alternative with kestra

Add this task based on the previous ones :

`- id: if_fhv_taxi`

    `type: io.kestra.plugin.core.flow.If`

    `condition: "{{inputs.taxi == 'fhv'}}"`

    `then:`

      `- id: bq_fhv_tripdata`

        `type: io.kestra.plugin.gcp.bigquery.Query`

        `sql: |`

          `` CREATE TABLE IF NOT EXISTS `{{kv('GCP_PROJECT_ID')}}.{{kv('GCP_DATASET')}}.fhv_tripdata` ``

          `(`

              `unique_row_id BYTES OPTIONS (description = 'A unique identifier for the trip, generated by hashing key trip attributes.'),`

              `filename STRING OPTIONS (description = 'The source filename from which the trip data was loaded.'),`      

              `dispatching_base_num STRING,`

              `pickup_datetime TIMESTAMP,`

              `dropoff_datetime TIMESTAMP,`

              `PUlocationID NUMERIC,`

              `DOlocationID NUMERIC,`

              `SR_Flag STRING,`

              `Affiliated_base_number STRING`

          `)`

          `PARTITION BY DATE(pickup_datetime);`

      `- id: bq_fhv_table_ext`

        `type: io.kestra.plugin.gcp.bigquery.Query`

        `sql: |`

          `` CREATE OR REPLACE EXTERNAL TABLE `{{kv('GCP_PROJECT_ID')}}.{{render(vars.table)}}_ext` ``

          `(`

              `dispatching_base_num STRING,`

              `pickup_datetime TIMESTAMP,`

              `dropoff_datetime TIMESTAMP,`

              `PUlocationID NUMERIC,`

              `DOlocationID NUMERIC,`

              `SR_Flag STRING,`

              `Affiliated_base_number STRING`

          `)`

          `OPTIONS (`

              `format = 'CSV',`

              `uris = ['{{render(vars.gcs_file)}}'],`

              `skip_leading_rows = 1,`

              `ignore_unknown_values = TRUE`

          `);`

      `- id: bq_fhv_table_tmp`

        `type: io.kestra.plugin.gcp.bigquery.Query`

        `sql: |`

          `` CREATE OR REPLACE TABLE `{{kv('GCP_PROJECT_ID')}}.{{render(vars.table)}}` ``

          `AS`

          `SELECT`

            `MD5(CONCAT(`

              `COALESCE(CAST(pickup_datetime AS STRING), ""),`

              `COALESCE(CAST(dropoff_datetime AS STRING), ""),`

              `COALESCE(CAST(PUlocationID AS STRING), ""),`

              `COALESCE(CAST(DOLocationID AS STRING), "")`

            `)) AS unique_row_id,`

            `"{{render(vars.file)}}" AS filename,`

            `*`

          ``FROM `{{kv('GCP_PROJECT_ID')}}.{{render(vars.table)}}_ext`;``

      `- id: bq_fhv_merge`

        `type: io.kestra.plugin.gcp.bigquery.Query`

        `sql: |`

          ``MERGE INTO `{{kv('GCP_PROJECT_ID')}}.{{kv('GCP_DATASET')}}.fhv_tripdata` T``

          ``USING `{{kv('GCP_PROJECT_ID')}}.{{render(vars.table)}}` S``

          `ON T.unique_row_id = S.unique_row_id`

          `WHEN NOT MATCHED THEN`

            `INSERT (unique_row_id, filename, dispatching_base_num, pickup_datetime, dropoff_datetime, PUlocationID, DOlocationID, SR_Flag, Affiliated_base_number)`

            `VALUES (S.unique_row_id, S.filename, S.dispatching_base_num, S.pickup_datetime, S.dropoff_datetime, S.PUlocationID, S.DOlocationID, S.SR_Flag, S.Affiliated_base_number);`

Add a trigger too :

`- id: fhv_schedule`

    `type: io.kestra.plugin.core.trigger.Schedule`

    `cron: "0 11 1 * *"`

    `inputs:`

      `taxi: fhv`

And modify inputs :

`inputs:`

  `- id: taxi`

    `type: SELECT`

    `displayName: Select taxi type`

    `values: [yellow, green, fhv]`

    `defaults: green`

## Homework \- Ingesting NYC TLC Data

I found out that the easies way to upload datasets form github for the homework is utilising this script [git\_csv\_to\_gcs.py](https://github.com/inner-outer-space/de-zoomcamp-2024/blob/main/4-analytics-engineering/git_csv_to_gcs.py). Thank you Lidia\!\!  
It is similar to a script that Alexey provided us in 03-data-warehouse/extras/**web\_to\_gcs.py**

## How to set environment variable easily for any credentials

If you have to securely put your credentials for a project and, probably, push it to a git repository then the best option is to use an environment variable   
For example for **web\_to\_gcs.py** or **git\_csv\_to\_gcs.py** we have to set these variables:  
GOOGLE\_APPLICATION\_CREDENTIALS  
GCP\_GCS\_BUCKET  
The easises option to do it  is to use .env  ([dotenv](https://pypi.org/project/python-dotenv/)).  
Install it and add a few lines of code that inject these variables for your project  
pip install python-dotenv

from dotenv import load\_dotenv  
import os

\# Load environment variables from .env file  
load\_dotenv()

\# Now you can access environment variables like GCP\_GCS\_BUCKET and GOOGLE\_APPLICATION\_CREDENTIALS  
credentials\_path \= os.getenv("GOOGLE\_APPLICATION\_CREDENTIALS")  
BUCKET \= os.environ.get("GCP\_GCS\_BUCKET")

## Invalid date types after Ingesting FHV data through CSV files: Could not parse 'pickup\_datetime' as a timestamp

If you uploaded manually the fvh 2019 csv files, you may face errors regarding date types. Try to create an the external table in bigquery but define the pickup\_datetime and dropoff\_datetime to be strings

CREATE OR REPLACE EXTERNAL TABLE \`gcp\_project.trips\_data\_all.fhv\_tripdata\`  (  
    dispatching\_base\_num STRING,  
    pickup\_datetime STRING,  
    dropoff\_datetime STRING,  
    PUlocationID STRING,  
    DOlocationID STRING,  
    SR\_Flag STRING,  
    Affiliated\_base\_number STRING  
)  
OPTIONS (  
    format \= 'csv',  
    uris \= \['gs://bucket/\*.csv'\]  
);

Then when creating the fhv core model in dbt, use TIMESTAMP(CAST(()) to ensure it first parses as a string and then convert it to timestamp.

with fhv\_tripdata as (  
    select \* from {{ ref('stg\_fhv\_tripdata') }}  
),  
dim\_zones as (  
    select \* from {{ ref('dim\_zones') }}  
    where borough \!= 'Unknown'  
)  
select fhv\_tripdata.dispatching\_base\_num,  
    TIMESTAMP(CAST(fhv\_tripdata.pickup\_datetime AS STRING)) AS pickup\_datetime,  
    TIMESTAMP(CAST(fhv\_tripdata.dropoff\_datetime AS STRING)) AS dropoff\_datetime,

## Invalid data types after Ingesting FHV data through parquet files: Could not parse SR\_Flag as Float64,Couldn’t parse datetime column as timestamp,couldn’t handle NULL values in PULocationID,DOLocationID

If you uploaded manually the fvh 2019 parquet files manually after downloading from [`https://d37ci6vzurychx.cloudfront.net/trip-data/fhv_tripdata_2019-*.parquet`](https://d37ci6vzurychx.cloudfront.net/trip-data/fhv_tripdata_2019-*.parquet) you may face errors regarding date types while loading the data in a landing table (say fhv\_tripdata). Try to create an the external table with the schema defines as following and load each month in a loop.

`-----Correct load with schema defination----will not throw error----------------------`  
``CREATE OR REPLACE EXTERNAL TABLE `dw-bigquery-week-3.trips_data_all.external_tlc_fhv_trips_2019` (``  
    `dispatching_base_num STRING,`  
    `pickup_datetime TIMESTAMP,`  
    `dropoff_datetime TIMESTAMP,`  
    `PUlocationID FLOAT64,`  
    `DOlocationID FLOAT64,`  
    `SR_Flag FLOAT64,`  
    `Affiliated_base_number STRING`  
`)`  
`OPTIONS (`  
  `format = 'PARQUET',`  
  `uris = ['gs://project id/fhv_2019_8.parquet']`  
`);`  
`Can Also USE  uris = ['gs://project id/fhv_2019_*.parquet'] (THIS WILL remove the need for the loop and can be done for all month in single RUN )`

– THANKYOU FOR THIS –  

## Join Error on LocationID “Unable to find common supertype for templated argument”

No matching signature for operator \= for argument types: STRING, INT64  
    Signature: T1 \= T1  
      Unable to find common supertype for templated argument  
Make sure the LocationID field is in the same type. If it is in string format in one table, we can use the following code in dbt to convert it to integer:  
{{ dbt.safe\_cast("PULocationID", api.Column.translate\_type("integer")) }} as pickup\_locationid

## Google Looker Studio \- you have used up your 30-day trial

When accessing Looker Studio through the Google Cloud Project console, you may be prompted to subscribe to the Pro version and receive the following errors:

![][image55]

Instead, navigate to [https://lookerstudio.google.com/navigation/reporting](https://lookerstudio.google.com/navigation/reporting) which will take you to the free version.

## How does dbt handle dependencies between models?

Ans: Dbt provides a mechanism called "ref" to manage dependencies between models. By referencing other models using the "ref" keyword in SQL, dbt automatically understands the dependencies and ensures the correct execution order.

## Loading FHV Data goes into slumber using Mage?

Try loading the data using jupyter notebooks in a local environment. There might be bandwidth issues with Mage. 

Load the data into a pandas dataframe using the urls, make necessary transformations, upload the gcp bucket / alternatively download the parquet/csv files locally and then upload to GCP manually. 

## Region Mismatch in DBT and BigQuery

If you are using the datasets copied into BigQuery from BigQuery public datasets, the region will be set as US by default and hence it is much easier to set your dbt profile location as US while transforming the tables and views.   
You can change the location as follows:

![][image56]

![][image57]

## What is the fastest way to upload taxi data to dbt-postgres?

Use the PostgreSQL COPY FROM feature that is compatible with csv files

First create the table like (as an example):

CREATE TABLE taxis (

…

);

And then use copy functionality (as an example):

COPY taxis FROM PROGRAM

‘url'

WITH (

 FORMAT csv,

 HEADER true,

 ENCODING utf8

 );

COPY table\_name \[ ( column\_name \[, ...\] ) \]  
FROM { 'filename' | PROGRAM 'command' | STDIN }  
\[ \[ WITH \] ( option \[, ...\] ) \]  
\[ WHERE condition \]

## dbt \- Where should we create \`profiles.yml\` ?

For local environment i.e. dbt-core, the profile configuration is valid for all projects. Note: dbt Cloud doesn’t require it.

The \~/.dbt/profiles.yml file should be located in your user's home directory. On Windows, this would typically be:

C:\\Users\\\<YourUsername\>\\.dbt\\profiles.yml

Replace \<YourUsername\> with your actual Windows username. This file is used by dbt to store connection profiles for different projects.

Here's how you can create the profiles.yml file in the appropriate directory:

1. Open File Explorer and navigate to C:\\Users\\\<YourUsername\>\\.

2. Create a new folder named .dbt if it doesn't already exist.

3. Inside the .dbt folder, create a new file named profiles.yml.

Usage example can be found [here](https://gist.github.com/pizofreude/ff4d0601f1eb353683d8af8f4b5aac27?permalink_comment_id=5457712#gistcomment-5457712).

## dbt \- Are there UI for dbt Core like dbt Cloud?

* Second only to dbt Cloud functionality: [https://github.com/AltimateAI/vscode-dbt-power-user](https://github.com/AltimateAI/vscode-dbt-power-user) Sign up for the community plan for free usage at [Altimate](https://app.myaltimate.com/register) and add the API into your VS Code extension.  
* VSCode Snippets Package for dbt and Jinja functions in SQL, YAML, and Markdown: [https://github.com/bastienboutonnet/vscode-dbt](https://github.com/bastienboutonnet/vscode-dbt)  
* For monitoring purposes: [https://github.com/elementary-data/elementary](https://github.com/elementary-data/elementary) Read more [here](https://medium.com/@srinivas.dataengineer/supercharge-your-dbt-monitoring-with-elementary-data-0fac140a6f60).

## When configuring the profiles.yml file for dbt-postgres with jinja templates with environment variables, I'm getting "Credentials in profile "PROFILE\_NAME", target: 'dev', invalid: '5432'is not of type 'integer'

| dbt\_postgres\_analytics:  outputs:    dev:      type: postgres      host:   "{{ env\_var('DBT\_POSTGRES\_HOST', 'localhost') }}"      port:   "{{ env\_var('DBT\_POSTGRES\_PORT', 5432\) }}"      dbname: "{{ env\_var('DBT\_POSTGRES\_DATABASE') }}"      schema: "{{ env\_var('DBT\_POSTGRES\_TARGET\_SCHEMA') }}"      user:   "{{ env\_var('DBT\_POSTGRES\_USER') }}"      pass:   "{{ env\_var('DBT\_POSTGRES\_PASSWORD') }}"      threads: 4 |
| :---- |

Update the line:

|  port:   "{{ env\_var('DBT\_POSTGRES\_PORT', 5432\) }}" |
| :---- |

With:

|  port:   "{{ env\_var('DBT\_POSTGRES\_PORT', 5432\) | as\_number }}" |
| :---- |

## DBT \- The database is correct but I get Error with Incorrect Schema in Models

What to do if your  dbt model fails with an error similar to:

| Database Error in model \<model\_name\> Not found: Dataset \<dataset\_name\> was not found in location \<location\_id\> |
| :---- |

1. #### **DBT-CORE**

#### 	

* **Check** profiles.yml:  
  * Ensure your profiles.yml file is correctly configured with the correct schema and database under your target. This file is typically located in \~/.dbt/.

  Example configuration:

| your\_project\_name:  target: dev  outputs:    dev:      type: bigquery      project: your\_project\_id      dataset: zoomcamp  *\# Ensure this is the correct schema*      ... |
| :---- |

2. #### **DBT-CLOUD-IDE**

* **Check Credentials in dbt Cloud UI:**

  * Navigate to the Credentials section in the dbt Cloud project settings.

  * Ensure the correct database and schema are set (e.g., ‘my\_dataset’).

![][image58]

* **Verify Environment Settings:**

  * Double-check that you are working in the correct environment (dev, prod, etc.), as dbt Cloud allows different settings for different environments.

* **No Need for profiles.yml:**

  * In dbt Cloud, you don’t need to configure profiles.yml manually. All connection settings are handled via the UI.

## DBT allows only 1 project in free developer version.

Yes, DBT allows only 1 project under one account. But you can create multiple accounts as shown below:

![][image59]

## Documentation or book sign not shown even after doing dbt docs generate.

In the free version, it does not show the docs when models are run in development environment. Create a production job and tick generate docs section. Execute it and it will generate the documentation.
