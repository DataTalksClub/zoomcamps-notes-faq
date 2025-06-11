---
title: FAQ
parent: Module 5
nav_order: 2
---

# Module 5: Batch Processing

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

## Setting up Java and Spark (with PySpark) on Linux (Alternative option using SDKMAN)

1. Install SDKMAN:  
   curl \-s "https://get.sdkman.io" | bash  
   source "$HOME/.sdkman/bin/sdkman-init.sh"

2. Using SDKMAN, install Java 11 and Spark 3.3.2:  
   sdk install java 11.0.22-tem  
   sdk install spark 3.3.2

   Open a new terminal or run the following in the same shell:

   source "$HOME/.sdkman/bin/sdkman-init.sh"

3. Verify the locations and versions of Java and Spark that were installed:  
   echo $JAVA\_HOME  
   java \-version  
   echo $SPARK\_HOME  
   spark-submit \--version

## PySpark \- Setting Spark up in Google Colab

If you’re seriously struggling to set things up "locally" (here locally meaning non/partly-managed environment like own laptop, a VM or Codespaces) you can use the following guide to use Spark in Google Colab:

[https://medium.com/gitconnected/launch-spark-on-google-colab-and-connect-to-sparkui-342cad19b304](https://medium.com/gitconnected/launch-spark-on-google-colab-and-connect-to-sparkui-342cad19b304) 

Starter notebook:

[https://github.com/aaalexlit/medium\_articles/blob/main/Spark\_in\_Colab.ipynb](https://github.com/aaalexlit/medium_articles/blob/main/Spark_in_Colab.ipynb) 

It’s advisable to spend some time setting things up locally rather than jumping right into this solution.

## Spark-shell: unable to load native-hadoop library for platform \- Windows

If after installing Java (either jdk or openjdk), Hadoop and Spark, and setting the corresponding environment variables you find the following error when spark-shell is run at CMD:

`java.lang.IllegalAccessError: class org.apache.spark.storage.StorageUtils$ (in unnamed module @0x3c947bc5) cannot access class sun.nio.ch.DirectBuffer (in module java.base) because module java.base does not export sun.nio.ch to unnamed`   
`module @0x3c947bc5`

Solution: Java 17 or 19 is not supported by Spark. Spark 3.x: requires Java 8/11/16. Install Java 11 from the website provided in the windows.md setup file.

## PySpark \- Python was not found; run without arguments to install from the Microsoft Store, or disable this shortcut from Settings \> Manage App Execution Aliases.

I found this error while executing the user defined function in Spark (crazy\_stuff\_udf). I am working on Windows and using conda. After following the setup instructions, I found that the PYSPARK\_PYTHON environment variable was not set correctly, given that conda has different python paths for each environment.

Solution:

*  `pip install findspark` on the command line inside proper environment

* Add to the top of the script

`import findspark`

`findspark.init()`

## PySpark \- TypeError: code() argument 13 must be str, not int  , while executing \`import pyspark\`  (Windows/ Spark 3.0.3 \- Python 3.11)

This is because Python 3.11 has some inconsistencies with such an old version of Spark. The solution is a downgrade in the Python version. Python 3.9 using a conda environment takes care of it. Or install newer PySpark \>= 3.5.1 works for me (Ella) \[[source](https://datatalks-club.slack.com/archives/C01FABYF2RG/p1709470599276889)\].

## Import pyspark \- Error: No Module named ‘pyspark’

Ensure that your \`PYTHONPATH\` is set correctly to include the PySpark library. You can check if PySpark is pointing to the correct location by running:     

import pyspark    

print(pyspark.\_\_file\_\_)  

It should point to the location where PySpark is installed (e.g., \`/home/\<your username\>/spark/spark-3.x.x-bin-hadoop3.x/python/pyspark/\_\_init\_\_.py\`)

## Cannot find Spark jobs UI at localhost

This is because current port is in use, Spark UI will run on a different port. You can check which port Spark is using by running this command:

spark.sparkContext.uiWebUrl 

If it indicates a different port, you should access that specific port instead.  Additionally, ensure that there are no other notebooks or processes that might be using the same port. Clean up unused resources to avoid port conflicts.

## Java+Spark \- Easy setup with miniconda env (worked on MacOS)

If anyone is a Pythonista or becoming one (which you will essentially be one along this journey), and desires to have all python dependencies under same virtual environment (e.g. conda) as done with prefect and previous exercises, simply follow these steps

1. Install OpenJDK 11, 

   1. on MacOS: `$ brew install java11`

   2. Add export PATH="/opt/homebrew/opt/openjdk@11/bin:$PATH"

      to `~/.bashrc` or `~/zshrc`

2. Activate working environment (by pipenv / poetry / conda)

3. Run `$ pip install pyspark`

4. Work with exercises as normal

All default commands of spark will be also available at shell session under activated enviroment.

Hope this can help\!

*P.s. you won’t need findspark to firstly initialize.*

**Py4J \- Py4JJavaError: An error occurred while calling (...)  java.net.ConnectException: Connection refused: no further information;** 

If you're getting \`Py4JavaError\` with a generic root cause, such as the described above (Connection refused: no further information). You're most likely using incompatible versions of the JDK or Python with Spark.

As of the [current latest Spark version (3.5.0)](https://spark.apache.org/docs/3.5.0/), it supports JDK 8 / 11 / 17\. All of which can be easily installed with [SDKMan\!](https://sdkman.io/) on macOS or Linux environments

`$ sdk install java 17.0.10-librca`  
`$ sdk install spark 3.5.0`  
`$ sdk install hadoop 3.3.5py4j`

[As PySpark 3.5.0 supports Python 3.8+](https://spark.apache.org/docs/3.5.0/) make sure you're setting up your virtualenv with either 3.8 / 3.9 / 3.10 / 3.11 (Most importantly avoid using 3.12 for now as not all libs in the data-science/engineering ecosystem are fully package for that)

`$ conda create -n ENV_NAME python=3.11`

`$ conda activate ENV_NAME`

`$ pip install pyspark==3.5.0`

This setup makes installing \`findspark\` and the likes of it unnecessary. Happy coding.

**Py4J \- Py4JJavaError**: An error occurred while calling o54.parquet. Or any kind of **Py4JJavaError that show up after run df.write.parquet('zones')(On window)**

This assume you already correctly set up the PATH in the nano \~/.bashrc

Here my 

export JAVA\_HOME="/c/tools/jdk-11.0.21"

export PATH="${JAVA\_HOME}/bin:${PATH}"

export HADOOP\_HOME="/c/tools/hadoop-3.2.0"

export PATH="${HADOOP\_HOME}/bin:${PATH}"

export SPARK\_HOME="/c/tools/spark-3.3.2-bin-hadoop3"

export PATH="${SPARK\_HOME}/bin:${PATH}"

export PYTHONPATH="${SPARK\_HOME}/python/:$PYTHONPATH"

export PYTHONPATH="${SPARK\_HOME}spark-3.5.1-bin-hadoop3py4j-0.10.9.5-src.zip:$PYTHONPATH"

You also need to add environment variables correctly which paths to java jdk, spark and hadoop through

Go to [Stephenlaye2/winutils3.3.0: winutils.exe hadoop.dll and hdfs.dll binaries for hadoop windows (github.com)](https://github.com/Stephenlaye2/winutils3.3.0), download the right winutils for hadoop-3.2.0. Then create a new folder,bin and put every thing in side to make a /c/tools/hadoop-3.2.0/bin(You might not need to do this, but after testing it without the /bin I could not make it to work)

Then follow the solution in this video: [How To Resolve Issue with Writing DataFrame to Local File | winutils | msvcp100.dll (youtube.com)](https://www.youtube.com/watch?v=yFem0Pu0gC8)

**Remember to restart IDE and computer,** After the error An error occurred while calling o54.parquet.  is fixed but new errors like o31.parquet. Or o35.parquet. appear. 

## Spark \- Installation Error Code 1603

**Issue:** Spark installation on Windows completed but failed to run.

This is a common Windows Installer error code indicating that there was a fatal error during installation. It often occurs due to issues like insufficient permissions, conflicts with other software, or problems with the installer package.

**Step to solve the issue:**

**Installing Chocolatey**

Chocolatey is a package manager for Windows, which makes it easy to install, update, and manage software.

**Installation Steps**

1. **Open PowerShell as an Administrator**

   * Press `Win + X` and select `Windows PowerShell (Admin)` or search for `PowerShell`, right-click, and select `Run as administrator`.  
2. **Run the following command to install Chocolatey**

    `Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('<https://community.chocolatey.org/install.ps1>'))`

3. **Verify the installation**

   * Close and reopen PowerShell as an administrator and run:

      `choco -v`

   * You should see the Chocolatey version number indicating that it has been installed successfully.

**Command for Global Acceptance**

To globally accept all licenses for all packages installed using Chocolatey, run the following command:

`choco feature enable -n allowGlobalConfirmation`

This command configures Chocolatey to automatically accept license agreements for all packages, streamlining the installation process and avoiding prompts for each package.

## RuntimeError: Java gateway process exited before sending its port number

After installing all including pyspark (and it is successfully imported), but then running this script on the jupyter notebook

`import pyspark`  
`from pyspark.sql import SparkSession`

`spark = SparkSession.builder \`  
    `.master("local[*]") \`  
    `.appName('test') \`  
    `.getOrCreate()`

`df = spark.read \`  
    `.option("header", "true") \`  
    `.csv('taxi+_zone_lookup.csv')`

`df.show()`

it gives the error: 

RuntimeError: Java gateway process exited before sending its port number

✅The solution (for me) was:

*  `pip install findspark` on the command line and then

* Add

`import findspark`  
`findspark.init()`

to the top of the script. 

Another possible solution is:

* Check that pyspark is pointing to the correct location. 

* Run `pyspark.__file__`. It should be `list /home/<your user name>/spark/spark-3.0.3-bin-hadoop3.2/python/pyspark/__init__.py` if you followed the videos. 

* If it is pointing to your python site-packages remove the pyspark directory there and check that you have added the correct exports to you .bashrc file and that there are not any other exports which might supersede the ones provided in the course content. 

To add to the solution above, if the errors persist in regards to setting the correct path for spark,  an alternative solution for permanent path setting solve the error is  to set environment variables on system and user environment variables following this tutorial: 

- Once everything is installed, skip to 7:14 to set up environment variables. This allows for the environment variables to be set permanently.

## Module Not Found Error in Jupyter Notebook .

Even after installing pyspark correctly on linux machine (VM ) as per course instructions, faced a module not found error in jupyter notebook . 

The solution which worked for me(use following in jupyter notebook) :

\!pip install findspark

import findspark

findspark.init()

Thereafter , import pyspark and create spark contex\<\<t as usual

None of the solutions above worked for me till I ran \!pip3 install pyspark instead \!pip install pyspark.

### Filter based on conditions based on multiple columns

from pyspark.sql.functions import col

new\_final.filter((new\_final.a\_zone=="Murray Hill") & (new\_final.b\_zone=="Midwood")).show()

Krishna Anand

## Py4JJavaError \- ModuleNotFoundError: No module named 'py4j'\` while executing \`import pyspark\`

You need to look for the Py4J file and note the version of the filename. Once you know the version, you can update the export command accordingly, this is how you check yours:  
\` `ls ${SPARK_HOME}/python/lib/` \` and then you add it in the export command, mine was:  
export PYTHONPATH=”${SPARK\_HOME}/python/lib/Py4J-0.10.9.5-src.zip:${PYTHONPATH}”

Make sure that the version under `` `${SPARK_HOME}/python/lib/` `` matches the filename of py4j or you will encounter `` `ModuleNotFoundError: No module named 'py4j'` `` while executing `` `import pyspark` ``. 

For instance, if the file under `` `${SPARK_HOME}/python/lib/` `` was `` `py4j-0.10.9.3-src.zip` ``. 

Then the `export PYTHONPATH` statement above should be changed to `` ` ``export PYTHONPATH="${SPARK\_HOME}/python/lib/py4j-0.10.9.3-src.zip:$PYTHONPATH"`` ` `` appropriately.

Additionally, you can check for the version of ‘py4j’ of the spark you’re using from [here](https://spark.apache.org/docs/latest/api/python/getting_started/install.html) and update as mentioned above.

\~ Abhijit Chakraborty: Sometimes, even with adding the correct version of py4j might not solve the problem. Simply run `pip install py4j` and problem should be resolved.

## Py4J Error \- ModuleNotFoundError: No module named 'py4j' (Solve with latest version)

If below does not work, then download the latest available py4j version with

conda install \-c conda-forge py4j

Take care of the latest version number in the website to replace appropriately. ![][image60]

Now add

export PYTHONPATH="${SPARK\_HOME}/python/:$PYTHONPATH"

export PYTHONPATH="${SPARK\_HOME}/python/lib/py4j-0.10.9.7-src.zip:$PYTHONPATH"

in your  .bashrc file.

## Exception: Jupyter command \`jupyter-notebook\` not found. 

Even after we have exported our paths correctly you may find that  even though Jupyter is installed you might not have Jupyter Noteboopgak for one reason or another. Full instructions are found [here](https://learningdataengineering540969211.wordpress.com/2022/02/24/week-5-de-zoomcamp-5-2-1-installing-spark-on-linux/) (for my walkthrough) or [here](https://speedysense.com/install-jupyter-notebook-on-ubuntu-20-04/) (where I got the original instructions from) but are included below. These instructions include setting up a virtual environment (handy if you are on your own machine doing this and not a VM):

Full steps:

1. Update and upgrade packages:

   1. sudo apt update && sudo apt \-y upgrade

2. Install Python:

   1. sudo apt install python3-pip python3-dev

3. Install Python virtualenv:

   1. sudo \-H pip3 install \--upgrade pip

   2. sudo \-H pip3 install virtualenv

4. Create a Python Virtual Environment:

   1. mkdir notebook

   2. cd notebook

   3. virtualenv jupyterenv

   4. source jupyterenv/bin/activate

5. Install Jupyter Notebook:

   1. pip install jupyter

6. Run Jupyter Notebook:

   1. jupyter notebook

## Following 5.2.1, I am getting an error \- Head:cannot open ‘taxi+\_zone\_lookup.csv’ for reading: No such file or directory

The latest filename is just ‘taxi\_zone\_lookup.sv’ so it should work after removing the ‘+’ now.

## Error java.io.FileNotFoundException

Code executed:

`df = spark.read.parquet(pq_path)`

`… some operations on df …`

`df.write.parquet(pq_path, mode="overwrite")`

java.io.FileNotFoundException: File file:/home/xxx/code/data/pq/fhvhv/2021/02/part-00021-523f9ad5-14af-4332-9434-bdcb0831f2b7-c000.snappy.parquet does not exist

The problem is that Sparks performs lazy transformations, so the actual action that trigger the job is df.write, which does delete the parquet files that is trying to read (mode=”overwrite”)

✅Solution: Write to a different directorydf

`df.write.parquet(pq_path_temp, mode="overwrite")`

## Hadoop \- FileNotFoundException: Hadoop bin directory does not exist , when trying to write (Windows)

You need to create the Hadoop /bin directory manually and add the downloaded files in there, since the shell script provided for Windows installation just puts them in /c/tools/hadoop-3.2.0/ .

## Which type of SQL is used in Spark? Postgres? MySQL? SQL Server?

Actually Spark SQL is one independent “type” of SQL \- Spark SQL.

The several SQL providers are very similar:

`SELECT [attributes]`

`FROM [table]`

`WHERE [filter]`

`GROUP BY [grouping attributes]`

`HAVING [filtering the groups]`

`ORDER BY [attribute to order]`

`(INNER/FULL/LEFT/RIGHT) JOIN [table2]`

`ON [attributes table joining table2] (...)`

What differs the most between several SQL providers are built-in functions.

For Built-in Spark SQL function check this link: [https://spark.apache.org/docs/latest/api/sql/index.html](https://spark.apache.org/docs/latest/api/sql/index.html)

Extra information on SPARK SQL :

[https://databricks.com/glossary/what-is-spark-sql\#:\~:text=Spark%20SQL%20is%20a%20Spark,on%20existing%20deployments%20and%20data](https://databricks.com/glossary/what-is-spark-sql#:~:text=Spark%20SQL%20is%20a%20Spark,on%20existing%20deployments%20and%20data). 

## The spark viewer on localhost:4040 was not showing the current run

✅Solution: I had two notebooks running, and the one I wanted to look at had opened a port on localhost:4041.

If a port is in use, then Spark uses the next available port number. It can be even 4044\. Clean up after yourself when a port does not work or a container does not run.

You can run `spark.sparkContext.uiWebUrl`

and result will be some like  
'http://172.19.10.61:4041' 

## Java \- java.lang.NoSuchMethodError: sun.nio.ch.DirectBuffer.cleaner()Lsun/misc/Cleaner Error during repartition call (conda pyspark installation)

✅Solution: replace Java Developer Kit 11 with Java Developer Kit 8\.

## Java \- RuntimeError: Java gateway process exited before sending its port number

Shows java\_home is not set on the notebook log

[https://sparkbyexamples.com/pyspark/pyspark-exception-java-gateway-process-exited-before-sending-the-driver-its-port-number/](https://sparkbyexamples.com/pyspark/pyspark-exception-java-gateway-process-exited-before-sending-the-driver-its-port-number/)

https://twitter.com/drkrishnaanand/status/1765423415878463839

## Spark fails when reading from BigQuery and using \`.show()\` on \`SELECT\` queries

✅I got it working using `` `gcs-connector-hadoop-2.2.5-shaded.jar` `` and Spark 3.1

I also added the google\_credentials.json and .p12 to auth with gcs. These files are downloadable from GCP Service account.

To create the SparkSession:

`spark = SparkSession.builder.master('local[*]') \`  
    `.appName('spark-read-from-bigquery') \`  
    `.config('BigQueryProjectId','razor-project-xxxxxxx) \`  
    `.config('BigQueryDatasetLocation','de_final_data') \`  
    `.config('parentProject','razor-project-xxxxxxx) \`  
    `.config("google.cloud.auth.service.account.enable", "true") \`  
    `.config("credentialsFile", "google_credentials.json") \`  
    `.config("GcpJsonKeyFile", "google_credentials.json") \`  
    `.config("spark.driver.memory", "4g") \`  
    `.config("spark.executor.memory", "2g") \`  
    `.config("spark.memory.offHeap.enabled",True) \`  
    `.config("spark.memory.offHeap.size","5g") \`  
    `.config('google.cloud.auth.service.account.json.keyfile', "google_credentials.json") \`  
    `.config("fs.gs.project.id", "razor-project-xxxxxxx") \`  
    `.config("fs.gs.impl", "com.google.cloud.hadoop.fs.gcs.GoogleHadoopFileSystem") \`  
    `.config("fs.AbstractFileSystem.gs.impl", "com.google.cloud.hadoop.fs.gcs.GoogleHadoopFS") \`  
    `.getOrCreate()`

## Spark BigQuery connector Automatic configuration

While creating a SparkSession using the config **spark.jars.packages** as *com.google.cloud.spark:spark-bigquery-with-dependencies\_2.12:0.23.2*

`spark = SparkSession.builder.master('local').appName('bq').config("spark.jars.packages", "com.google.cloud.spark:spark-bigquery-with-dependencies_2.12:0.23.2").getOrCreate()` 

automatically downloads the required dependency jars and configures the connector, removing the need to manage this dependency. More details available [here](https://github.com/GoogleCloudDataproc/spark-bigquery-connector)

## Spark Cloud Storage connector

[Link to Slack Thread](https://datatalks-club.slack.com/archives/C01FABYF2RG/p1646013709648279?thread_ts=1646008578.136059&cid=C01FABYF2RG) : has anyone figured out how to read from GCP data lake instead of downloading all the taxi data again?

There’s a few extra steps to go into reading from GCS with PySpark

1.)  IMPORTANT: Download the Cloud Storage connector for Hadoop here: [https://cloud.google.com/dataproc/docs/concepts/connectors/cloud-storage\#clusters](https://cloud.google.com/dataproc/docs/concepts/connectors/cloud-storage#clusters)

As the name implies, this .jar file is what essentially connects PySpark with your GCS

2.) Move the .jar file to your Spark file directory. I installed Spark using homebrew on my MacOS machine and I had to create a /jars directory under "/opt/homebrew/Cellar/apache-spark/3.2.1/ (where my spark dir is located)

3.) In your Python script, there are a few extra classes you’ll have to import:

`import pyspark`  
`from pyspark.sql import SparkSession`  
`from pyspark.conf import SparkConf`  
`from pyspark.context import SparkContext`

4.) You must set up your configurations before building your SparkSession. Here’s my code snippet:

`conf = SparkConf() \`  
    `.setMaster('local[*]') \`  
    `.setAppName('test') \`  
    `.set("spark.jars", "/opt/homebrew/Cellar/apache-spark/3.2.1/jars/gcs-connector-hadoop3-latest.jar") \`  
    `.set("spark.hadoop.google.cloud.auth.service.account.enable", "true") \`  
    `.set("spark.hadoop.google.cloud.auth.service.account.json.keyfile", "path/to/google_credentials.json")`

`sc = SparkContext(conf=conf)`

`sc._jsc.hadoopConfiguration().set("fs.AbstractFileSystem.gs.impl",  "com.google.cloud.hadoop.fs.gcs.GoogleHadoopFS")`  
`sc._jsc.hadoopConfiguration().set("fs.gs.impl", "com.google.cloud.hadoop.fs.gcs.GoogleHadoopFileSystem")`  
`sc._jsc.hadoopConfiguration().set("fs.gs.auth.service.account.json.keyfile", "path/to/google_credentials.json")`  
`sc._jsc.hadoopConfiguration().set("fs.gs.auth.service.account.enable", "true")`

5.) Once you run that, build your SparkSession with the new parameters we’d just instantiated in the previous step:

`spark = SparkSession.builder \`  
    `.config(conf=sc.getConf()) \`  
    `.getOrCreate()`

6.) Finally, you’re able to read your files straight from GCS\!

`start-slave.sh: command not found`

## How can I read a small number of rows from the parquet file directly?

from pyarrow.parquet import ParquetFile  
pf \= ParquetFile('fhvhv\_tripdata\_2021-01.parquet')  
\#pyarrow builds tables, not dataframes  
tbl\_small \= next(pf.iter\_batches(batch\_size \= 1000))  
\#this function converts the table to a dataframe of manageable size  
df \= [tbl\_small.to](http://tbl_small.to/)\_pandas()

Alternatively without PyArrow:

df \= spark.read.parquet('fhvhv\_tripdata\_2021-01.parquet')  
df1 \= df.sort('DOLocationID').limit(1000)  
pdf \= df1.select("\*").toPandas()

## DataType error when creating Spark DataFrame with a specified schema?

Probably you’ll encounter this if you followed the video ‘5.3.1 \- First Look at Spark/PySpark’ and used the parquet file from the TLC website (csv was used in the video). 

When defining the schema, the PULocation and DOLocationID are defined as IntegerType. This will cause an error because the Parquet file is INT64 and you’ll get an error like:

Parquet column cannot be converted in file \[...\] Column \[...\] Expected: int, Found: INT64

Change the schema definition from IntegerType to LongType and it should work

## Remove white spaces from column names in Pyspark

df\_finalx=df\_finalw.select(\[col(x).alias(x.replace(" ","")) for x in df\_finalw.columns\])

Krishna Anand

## AttributeError: 'DataFrame' object has no attribute 'iteritems'

This error comes up on the Spark video 5.3.1 \- First Look at Spark/PySpark,

because as at the creation of the video, 2021 data was the most recent which utilised csv files but as at now its parquet.

So when you run the command spark.createDataFrame(df1\_pandas).show(),

You get the Attribute error. This is caused by the pandas version 2.0.0 which seems incompatible with Spark 3.3.2, so to fix it you have to downgrade pandas to 1.5.3 using the command **pip install \-U pandas==1.5.3**

Another option is adding the following after importing pandas, if one does not want to downgrade pandas version ([source](https://stackoverflow.com/questions/76404811/attributeerror-dataframe-object-has-no-attribute-iteritems)) : 

**pd.DataFrame.iteritems \= pd.DataFrame.items**

Note that this problem is solved with Spark versions from 3.4.1

## AttributeError: 'DataFrame' object has no attribute 'iteritems'

Another alternative is to install pandas 2.0.1 (it worked well as at the time of writing this), and it is compatible with Pyspark 3.5.1. Make sure to add or edit your environment variable like this:   
       export SPARK\_HOME="${HOME}/spark/spark-3.5.1-bin-hadoop3"  
        export PATH="${SPARK\_HOME}/bin:${PATH}"

## Spark Standalone Mode on Windows

- Open a CMD terminal in administrator mode

- cd %SPARK\_HOME%

- Start a master node: bin\\spark-class org.apache.spark.deploy.master.Master

- Start a worker node: bin\\spark-class org.apache.spark.deploy.worker.Worker spark://\<master\_ip\>:\<port\> \--host \<IP\_ADDR\>  
-   
- bin/spark-class org.apache.spark.deploy.worker.Worker spark://localhost:7077 \--host \<IP\_ADDR\>  
  -  spark://\<master\_ip\>:\<port\>: copy the address from the previous command, in my case it was spark://localhost:7077

  - Use \--host \<IP\_ADDR\> if you want to run the worker on a different machine. For now leave it empty.

- Now you can access Spark UI through localhost:8080

## Export PYTHONPATH command in linux is temporary

You can either type the export command every time you run a new session, add it to the .bashrc/ which you can find in /home or run this command at the beginning of your homebook:

import findspark 

findspark.init()

## Compression Error: zcat output is gibberish, seems like still compressed

In the code along from Video 5.3.3 Alexey downloads the CSV files from the NYT website and gzips them in their bash script. If we now (2023) follow along but download the data from the GH course Repo, it will already be zippes as csv.gz files. Therefore we zip it again if we follow the code from the video exactly. This then leads to gibberish outcome when we then try to cat the contents or count the lines with zcat, because the file is zipped twitch and zcat only unzips it once.

✅solution: do not gzip the files downloaded from the course repo. Just wget them and save them as they are as csv.gz files. Then the zcat command and the showSchema command will also work 

URL="${URL\_PREFIX}/${TAXI\_TYPE}/${TAXI\_TYPE}\_tripdata\_${YEAR}-${FMONTH}.csv.gz"  
   LOCAL\_PREFIX="data/raw/${TAXI\_TYPE}/${YEAR}/${FMONTH}"  
   LOCAL\_FILE="${TAXI\_TYPE}\_tripdata\_${YEAR}\_${FMONTH}.csv.gz"  
   LOCAL\_PATH="${LOCAL\_PREFIX}/${LOCAL\_FILE}"

   echo "downloading ${URL} to ${LOCAL\_PATH}"  
   mkdir \-p ${LOCAL\_PREFIX}  
   wget ${URL} \-O ${LOCAL\_PATH}  
    
   echo "compressing ${LOCAL\_PATH}"  
   \# gzip ${LOCAL\_PATH} \<- uncomment this line

## 

## PicklingError: Could not serialise object: IndexError: tuple index out of range.

Occurred while running : spark.createDataFrame(df\_pandas).show() 

This error is usually due to the python version, since spark till date of 2 march 2023 doesn’t support python 3.11, try creating a new env with python version 3.8 and then run this command.

On the virtual machine, you can create a conda environment (here called myenv) with python 3.10 installed:

conda create \-n myenv python=3.10 anaconda

Then you must run conda activate myenv to run python 3.10. Otherwise you’ll still be running version 3.11. You can deactivate by typing conda deactivate.

## Connecting from local Spark to GCS \- Spark does not find my google credentials as shown in the video?

Make sure you have your credentials of your GCP in your VM under the location defined in the script.

## Spark docker-compose setup

To run spark in docker setup

1\. Build bitnami spark docker

	a. clone bitnami repo using command

    	`git clone https://github.com/bitnami/containers.git`

    	(tested on commit 9cef8b892d29c04f8a271a644341c8222790c992)   	 

	b. edit file \`bitnami/spark/3.3/debian-11/Dockerfile\` and update java and spark version as following

        	`"python-3.10.10-2-linux-${OS_ARCH}-debian-11" \`

        	`"java-17.0.5-8-3-linux-${OS_ARCH}-debian-11" \`

    	reference: https://github.com/bitnami/containers/issues/13409

	c. build docker image by navigating to above directory and running docker build command

    	navigate `cd bitnami/spark/3.3/debian-11/`

    	build command docker build \-t spark:3.3-java-17 . 

2\. run docker compose

	using following file

\`\`\`yaml docker-compose.yml

version: '2'

services:

  spark:

	image: spark:3.3-java-17

	environment:

  	\- SPARK\_MODE=master

  	\- SPARK\_RPC\_AUTHENTICATION\_ENABLED=no

  	\- SPARK\_RPC\_ENCRYPTION\_ENABLED=no

  	\- SPARK\_LOCAL\_STORAGE\_ENCRYPTION\_ENABLED=no

  	\- SPARK\_SSL\_ENABLED=no

	volumes:

  	\- "./:/home/jovyan/work:rw"

	ports:

  	\- '8080:8080'

  	\- '7077:7077'

  spark-worker:

	image: spark:3.3-java-17

	environment:

  	\- SPARK\_MODE=worker

  	\- SPARK\_MASTER\_URL=spark://spark:7077

  	\- SPARK\_WORKER\_MEMORY=1G

  	\- SPARK\_WORKER\_CORES=1

  	\- SPARK\_RPC\_AUTHENTICATION\_ENABLED=no

  	\- SPARK\_RPC\_ENCRYPTION\_ENABLED=no

  	\- SPARK\_LOCAL\_STORAGE\_ENCRYPTION\_ENABLED=no

  	\- SPARK\_SSL\_ENABLED=no

	volumes:

  	\- "./:/home/jovyan/work:rw"

	ports:

  	\- '8081:8081'

  spark-nb:   

	image: jupyter/pyspark-notebook:java-17.0.5

	environment:

  	\- SPARK\_MASTER\_URL=spark://spark:7077

	volumes:

  	\- "./:/home/jovyan/work:rw"

    

	ports:

  	\- '8888:8888'

  	\- '4040:4040'

\`\`\`

run command to deploy docker compose

docker-compose up

Access jupyter notebook using link logged in docker compose logs

Spark master url is spark://spark:7077

## How do you read data stored in gcs on pandas with your local computer?

To do this  
pip install gcsfs,

Thereafter copy the uri path to the file and use   
df \= pandas.read\_csc(gs://path)

## TypeError when using spark.createDataFrame function on a pandas df

Error:

spark.createDataFrame(df\_pandas).schema  
TypeError: field Affiliated\_base\_number: Can not merge type \<class 'pyspark.sql.types.StringType'\> and \<class 'pyspark.sql.types.DoubleType'\>

Solution:

Affiliated\_base\_number is a mix of letters and numbers (you can check this with a preview of the table), so it cannot be set to *DoubleType* (only for double-precision numbers). The suitable type would be *StringType*. Spark  inferSchema is more accurate than Pandas infer type method in this case. You can set it to  true  while reading the csv, so you don’t have to take out any data from your dataset. Something like this can help: 

df \= spark.read \\

    .options( 

    header \= "true", \\

    inferSchema \= "true", \\

            ) \\

    .csv('path/to/your/csv/file/')

Solution B:

It's because some rows in the affiliated\_base\_number are null and therefore it is assigned the datatype String and this cannot be converted to type Double. So if you really want to convert this pandas df to a pyspark df only take the  rows from the pandas df that are not null in the 'Affiliated\_base\_number' column. Then you will be able to apply the pyspark function createDataFrame.

\# Only take rows that have no null values  
pandas\_df= pandas\_df\[pandas\_df.notnull().all(1)\]

## MemoryManager: Total allocation exceeds 95.00% (1,020,054,720 bytes) of heap memory

Default executor memory is 1gb. This error appeared when working with the homework dataset.

Error: MemoryManager: Total allocation exceeds 95.00% (1,020,054,720 bytes) of heap memory  
Scaling row group sizes to 95.00% for 8 writers

Solution:

Increase the memory of the executor when creating the Spark session like this:

spark \= SparkSession.builder \\  
	.master("local\[\*\]") \\  
	.appName('test') \\  
	.config("spark.executor.memory", "4g") \\  
	.config("spark.driver.memory", "4g") \\  
	.getOrCreate()

Remember to restart the Jupyter session (ie. close the Spark session) or the config won’t take effect.

## How to spark standalone cluster is run on windows OS

Change the working directory to the spark directory:

if you have setup up your SPARK\_HOME variable, use the following;

cd %SPARK\_HOME%    

if not, use the following;

cd \<path to spark installation\>

Creating a Local Spark Cluster

To start Spark Master:

bin\\spark-class org.apache.spark.deploy.master.Master \--host localhost

Starting up a cluster:

bin\\spark-class org.apache.spark.deploy.worker.Worker spark://localhost:7077 \--host localhost

## Env variables set in \~/.bashrc are not loaded to Jupyter in VS Code

I added PYTHONPATH, JAVA\_HOME and SPARK\_HOME to \~/.bashrc, import pyspark worked ok in iPython in terminal, but couldn’t be found in .ipynb opened in VS Code

After adding new lines to \~/.bashrc, need to **restart** the shell to activate the new lines, do either

* source \~/.bashrc  
* exec bash

Instead of configuring paths in \~/.bashrc, I created .env file in the root of my workspace:

JAVA\_HOME="${HOME}/app/java/jdk-11.0.2"  
PATH="${JAVA\_HOME}/bin:${PATH}"  
SPARK\_HOME="${HOME}/app/spark/spark-3.3.2-bin-hadoop3"  
PATH="${SPARK\_HOME}/bin:${PATH}"  
PYTHONPATH="${SPARK\_HOME}/python/:$PYTHONPATH"  
PYTHONPATH="${SPARK\_HOME}/python/lib/py4j-0.10.9.5-src.zip:$PYTHONPATH"  
PYTHONPATH="${SPARK\_HOME}/python/lib/pyspark.zip:$PYTHONPATH"

## hadoop “wc \-l” is giving a different result then shown in the video

If you are doing wc \-l fhvhv\_tripdata\_2021-01.csv.gz  with the gzip file as the file argument, you will get a different result, obviously\! Since the file is compressed.

Unzip the file and then do wc \-l fhvhv\_tripdata\_2021-01.csv to get the right results.

## Hadoop \- Exception in thread "main" java.lang.UnsatisfiedLinkError: org.apache.hadoop.io.nativeio.NativeIO$Windows.access0(Ljava/lang/String;I)Z

If you are seeing this (or similar) error when attempting to write to parquet, it is likely an issue with your path variables. 

For Windows, create a new User Variable “HADOOP\_HOME” that points to your Hadoop directory. Then add “%HADOOP\_HOME%\\bin” to the PATH variable.

![][image61]

![][image62]

Additional tips can be found here: https://stackoverflow.com/questions/41851066/exception-in-thread-main-java-lang-unsatisfiedlinkerror-org-apache-hadoop-io

## Java.io.IOException. Cannot run program “C:\\hadoop\\bin\\winutils.exe”. CreateProcess error=216, This version of 1% is not compatible with the version of Windows you are using.

Change the hadoop version to 3.0.1.Replace all the files in the local hadoop bin folder with the files in this repo:  [winutils/hadoop-3.0.1/bin at master · cdarlint/winutils (github.com)](https://github.com/cdarlint/winutils/tree/master/hadoop-3.0.1/bin) 

If this does not work try to change other versions found in this repository. 

For more information please see this link: [This version of %1 is not compatible with the version of Windows you're running · Issue \#20 · cdarlint/winutils (github.com)](https://github.com/cdarlint/winutils/issues/20)

## Dataproc \- ERROR: (gcloud.dataproc.jobs.submit.pyspark) The required property \[project\] is not currently set. It can be set on a per-command basis by re-running your command with the \[--project\] flag.

Fix is to set the flag like the error states. Get your project ID from your dashboard and set it like so:

gcloud dataproc jobs submit pyspark \\  
\--cluster=my\_cluster \\   
\--region=us-central1 \\  
\--project=my-dtc-project-1010101 \\  
gs://my-dtc-bucket-id/code/06\_spark\_sql.py   
\-- \\   
	…

## Run Local Cluster Spark in Windows 10 with CMD

1. Go to %SPARK\_HOME%\\bin 

2. Run spark-class org.apache.spark.deploy.master.Master to run the master. This will give you a URL of the form spark://ip:port

3. Run spark-class org.apache.spark.deploy.worker.Worker spark://ip:port to run the worker. Make sure you use the URL you obtained in step 2\.

4. Create a new Jupyter notebook:

   spark \= SparkSession.builder \\

       .master("spark://{ip}:7077") \\

       .appName('test') \\

       .getOrCreate()

5.  Check on Spark UI the master, worker and app.

## lServiceException: 401 Anonymous caller does not have storage.objects.list access to the Google Cloud Storage bucket. Permission 'storage.objects.list' denied on resource (or it may not exist).

This occurs because you are not logged in “gcloud auth login” and maybe the project id is not settled. Then type in a terminal:

**gcloud auth login**

This will open a tab in the browser, accept the terms, after that close the tab if you want. Then set the project is like:

**gcloud config set project \<YOUR PROJECT\_ID\>**

Then you can run the command to upload the pq dir to a GCS Bucket:

**gsutil \-m cp \-r pq/ \<YOUR URI from gsutil\>/pq**

## py4j.protocol.Py4JJavaError  GCP

When submit a job, it might throw an error about Java in log panel within Dataproc. I changed the Versioning Control when I created a cluster, so it means that I delete the cluster and created a new one, and instead of choosing Debian-Hadoop-Spark, I switch to Ubuntu 20.02-Hadoop3.3-Spark3.3 for Versioning Control feature, the main reason to choose this is because I have the same Ubuntu version in mi laptop, I tried to find documentation to sustent this but unfortunately I couldn't nevertheless it works for me.

## Repartition the Dataframe to 6 partitions using df.repartition(6) \- got 8 partitions instead 

Use both repartition and coalesce, like so:

df \= df.repartition(6)  
df \= df.coalesce(6)  
df.write.parquet('fhv/2019/10', mode='overwrite')

## Jupyter Notebook or SparkUI not loading properly at localhost after port forwarding from VS code?

Possible solution \- Try to forward the port using ssh cli instead of vs code.

Run \> “ssh \-L \<local port\>:\<VM host/ip\>:\<VM port\> \<ssh hostname\>”

ssh hostname is the name you specified in the \~/.ssh/config file

In case of Jupyter Notebook run

“ssh \-L 8888:localhost:8888 gcp-vm”

from your local machine’s cli.

NOTE: If you logout from the session, the connection would break. Also while creating the spark session notice the block's log because sometimes it fails to run at 4040 and then switches to 4041\.

\~Abhijit Chakrborty: If you are having trouble accessing localhost ports from GCP VM consider adding the forwarding instructions to .ssh/config file as following:

\`\`\`

Host \<hostname\>

    Hostname \<external-gcp-ip\>

    User xxxx

    IdentityFile yyyy

    LocalForward 8888 localhost:8888

    LocalForward 8080 localhost:8080

    LocalForward 5432 localhost:5432

    LocalForward 4040 localhost:4040

\`\`\`

This should automatically forward all ports and will enable accessing localhost ports.

## Installing Java 11 on codespaces 

\~ Abhijit Chakraborty

\`sdk list java\`  to check for available java sdk versions.

\`sdk install java 11.0.22-amzn\`  as  java-11.0.22-amzn was available for my codespace.

click on Y if prompted to change the default java version.

Check for java version using \`java \-version \`.

If working fine great, else \`sdk default java 11.0.22-amzn\` or whatever version you have installed.

## Error: Insufficient 'SSD\_TOTAL\_GB' quota. Requested 500.0, available 470.0.

Sometimes while creating a dataproc cluster on GCP, the following error is encountered.

![][image63]

**Solution:** As mentioned [here](https://stackoverflow.com/a/59038704/22748533), sometimes there might not be enough resources in the given region to allocate the request. Usually, gets freed up in a bit and one can create a cluster. – abhirup ghosh

**Solution 2:**  Changing the type of boot-disk from PD-Balanced to PD-Standard, in terraform, helped solve the problem.- Sundara Kumar Padmanabhan

## Homework \- how to convert the time difference of two timestamps to hours

Pyspark converts the difference of two TimestampType values to Python's native datetime.timedelta object. The timedelta object only stores the duration in terms of days, seconds, and microseconds. Each of the three units of time must be manually converted into hours in order to express the total duration between the two timestamps using only hours.

Another way for achieving this is using the **datediff** (sql function). It receives this parameters

- Upper Date: the closest date you have. For example dropoff\_datetime  
- Lower Date: the farthest date you have.  For example pickup\_datetime

And the result is returned in terms of days, so you could multiply the result for 24 in order to get the hours.

## PicklingError: Could not serialize object: IndexError: tuple index out of range

This version combination worked for me:

PySpark \= 3.3.2  
Pandas \= 1.5.3

If it still has an error, 

Py4JJavaError: An error occurred while calling o180.showString. : org.apache.spark.SparkException: Job aborted due to stage failure: Task 0 in stage 6.0 failed 1 times, most recent failure: Lost task 0.0 in stage 6.0 (TID 6\) (host.docker.internal executor driver): org.apache.spark.SparkException: Python worker failed to connect back.

Run this before SparkSession

import os   
import sys   
os.environ\['PYSPARK\_PYTHON'\] \= sys.executable   
os.environ\['PYSPARK\_DRIVER\_PYTHON'\] \= sys.executable

## RuntimeError: Python in worker has different version 3.11 than that in driver 3.10, PySpark cannot run with different minor versions. Please check environment variables PYSPARK\_PYTHON and PYSPARK\_DRIVER\_PYTHON are correctly set.

import os  
import sys  
os.environ\['PYSPARK\_PYTHON'\] \= sys.executable  
os.environ\['PYSPARK\_DRIVER\_PYTHON'\] \= sys.executable

Dataproc Pricing: [https://cloud.google.com/dataproc/pricing\#on\_gke\_pricing](https://cloud.google.com/dataproc/pricing#on_gke_pricing)

## Dataproc Qn: Is it essential to have a VM on GCP for running Dataproc and submitting jobs ?

Ans: No, you can submit a job to DataProc from your local computer by installing gsutil ([https://cloud.google.com/storage/docs/gsutil\_install](https://cloud.google.com/storage/docs/gsutil_install)) and configuring it. Then, you can execute the following command from your local computer. 

gcloud dataproc jobs submit pyspark \\  
    \--cluster=de-zoomcamp-cluster \\  
    \--region=europe-west6 \\  
    gs://dtc\_data\_lake\_de-zoomcamp-nytaxi/code/06\_spark\_sql.py \\  
    \-- \\  
      \--input\_green=gs://dtc\_data\_lake\_de-zoomcamp-nytaxi/pq/green/2020/\*/ \\  
      \--input\_yellow=gs://dtc\_data\_lake\_de-zoomcamp-nytaxi/pq/yellow/2020/\*/ \\  
      \--output=gs://dtc\_data\_lake\_de-zoomcamp-nytaxi/report-2020 (edited) 

## In module 5.3.1, trying to run spark.createDataFrame(df\_pandas).show() returns error

AttributeError: 'DataFrame' object has no attribute 'iteritems'

this is because the method inside the pyspark refers to a package that has been already deprecated

(https://stackoverflow.com/questions/76404811/attributeerror-dataframe-object-has-no-attribute-iteritems) 

You can do this code below, which is mentioned in the stackoverflow link above:

![][image64]

Another work around here is to create a conda enviroment to donwgrade python’s version to 3.8 and pandas to 1.5.3

`conda create -n pyspark_env python=3.8 pandas=1.5.3 jupyter`

`conda activate pyspark_env` 

## Cannot create a cluster: Insufficient 'SSD\_TOTAL\_GB' quota. Requested 500.0, available 250.0.

A: The master and worker nodes are allocated a maximum of 250 GB of memory combined. In the configuration section, adhere to the following specifications:

Master Node:

Machine type: n2-standard-2

Primary disk size: 85 GB

Worker Node:

Number of worker nodes: 2

Machine type: n2-standard-2

Primary disk size: 80 GB

You can allocate up to 82.5 GB memory for worker nodes, keeping in mind that the total memory allocated across all nodes cannot exceed 250 GB.

## Setting JAVA\_HOME with Homebrew on Apple Silicon

The MacOS setup instruction ([https://github.com/DataTalksClub/data-engineering-zoomcamp/blob/main/05-batch/setup/macos.md\#installing-java](https://github.com/DataTalksClub/data-engineering-zoomcamp/blob/main/05-batch/setup/macos.md#installing-java)) for setting the ***JAVA\_HOME*** environment variable is for Intel-based Macs which have a default install location at /usr/local/. If you have an Apple Silicon mac, you will have to set ***JAVA\_HOME*** to /opt/homebrew/, specifically in your .bashrc or .zshrc:

export JAVA\_HOME="/opt/homebrew/opt/openjdk/bin"

export PATH="$JAVA\_HOME:$PATH"

Confirm that your path was correctly set by running the command: which java

You should expect to see the output:

/opt/homebrew/opt/openjdk/bin/java

Check java version with the next command:

Java \-version

Reference: [https://docs.brew.sh/Installation](https://docs.brew.sh/Installation) 

## Subnetwork 'default' does not support Private Google Access which is required for Dataproc clusters when 'internal\_ip\_only' is set to 'true'. Enable Private Google Access on subnetwork 'default' or set 'internal\_ip\_only' to 'false'.

Search for VPC in Google Cloud Console

Navigate to the second tab “SUBNETS IN CURRENT PROJECT”

Look for the region/location where your dataproc will be located and click on it

Click the edit button and toggle on the button for “Private Google Access”

Save changes.

##  Spark is working, however, nothing appears in the Spark UI (e.g., .show())?

Since we used multiple notebooks during the course, it's possible that there are more than one Spark session active. It’s highly likely that you are observing the incorrect one. Follow these steps to troubleshoot:

* Spark uses port **4040** by default, but if more than one session is active, it will try to use the next available port (e.g., **4041**).  
* Ensure you're viewing the correct **Spark Web UI** for the application where your jobs are running.  
* Verify the **current application session address**:   
  * Eg: Using spark.sparkContext.uiWebUrl command in your session.  
  * Expected output: [http://your.application.session.address.internal:4041](http://spark-exec.southamerica-east1-c.c.de-zoomcamp-25-449418.internal:4041/)   
  * Indicating **port** 4041  
* If using a VM, make sure you forward the identified port to access the web ui on the localhost:\<port\>.
