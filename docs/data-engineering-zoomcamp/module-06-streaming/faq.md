---
title: FAQ
parent: Module 6
nav_order: 2
---

# Module 6: Stream Processing

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}


## Could not start docker image “control-center” from the docker-compose.yaml file.

Check Docker Compose File:

Ensure that your docker-compose.yaml file is correctly configured with the necessary details for the "control-center" service. Check the service name, image name, ports, volumes, environment variables, and any other configurations required for the container to start.

On Mac OSX 12.2.1 (Monterey) I could not start the kafka control center. I opened Docker Desktop and saw docker images still running from week 4, which I did not see when I typed “docker ps.” I deleted them in docker desktop and then had no problem starting up the kafka environment.

## Module “kafka” not found when trying to run producer.py

Solution from Alexey: create a virtual environment and run requirements.txt and the python files in that environment.

To create a virtual env and install packages (run only once)

`python -m venv env`  
`source env/bin/activate`  
`pip install -r ../requirements.txt`  
To activate it (you'll need to run it every time you need the virtual env):

`source env/bin/activate`

To deactivate it:

`deactivate`

This works on MacOS, Linux and Windows \- but for Windows the path is slightly different (it's env/Scripts/activate)

Also the virtual environment should be created only to run the python file. Docker images should first all be up and running.

## Error importing cimpl dll when running avro examples

ImportError: DLL load failed while importing cimpl: The specified module could not be found

Verify Python Version:

Make sure you are using a compatible version of Python with the Avro library. Check the Python version and compatibility requirements specified by the Avro library documentation.

... you may have to load librdkafka-5d2e2910.dll in the code. Add this before importing avro:

`from ctypes import CDLL`  
CDLL("C:\\\\Users\\\\YOUR\_USER\_NAME\\\\anaconda3\\\\envs\\\\dtcde\\\\Lib\\\\site-packages\\\\confluent\_kafka.libs\\librdkafka-5d2e2910.dll")

It seems that the error may occur depending on the OS and python version installed.

ALTERNATIVE:

`ImportError: DLL load failed while importing cimpl`

✅SOLUTION: `$env:CONDA_DLL_SEARCH_MODIFICATION_ENABLE=1` in Powershell. 

You need to set this DLL manually in Conda Env.

Source: [https://githubhot.com/repo/confluentinc/confluent-kafka-python/issues/1186?page=2](https://githubhot.com/repo/confluentinc/confluent-kafka-python/issues/1186?page=2)

## ModuleNotFoundError: No module named 'avro'

✅SOLUTION: `pip install confluent-kafka[avro].` 

For some reason, Conda also doesn't include this when installing confluent-kafka via pip.

More sources on Anaconda and confluent-kafka issues:

* [https://github.com/confluentinc/confluent-kafka-python/issues/590](https://github.com/confluentinc/confluent-kafka-python/issues/590)

* [https://github.com/confluentinc/confluent-kafka-python/issues/1221](https://github.com/confluentinc/confluent-kafka-python/issues/1221)

* [https://stackoverflow.com/questions/69085157/cannot-import-producer-from-confluent-kafka](https://stackoverflow.com/questions/69085157/cannot-import-producer-from-confluent-kafka)

## Error while running python3 stream.py worker

If you get an error while running the command `python3 stream.py worker`

Run `pip uninstall kafka-python`

Then run `pip install kafka-python==1.4.6`

## What is the use of  Redpanda ?

Redpanda: Redpanda is built on top of the Raft consensus algorithm and is designed as a high-performance, low-latency alternative to Kafka. It uses a log-centric architecture similar to Kafka but with different underlying principles.

## Negsignal:SIGKILL while converting data files to parquet format

Got this error because the docker container memory was exhausted. The data file was up to 800MB but my docker container does not have enough memory to handle that. 

Solution was to load the file in chunks with Pandas, then create multiple parquet files for each dat file I was processing. This worked smoothly and the issue was resolved.


## resources/rides.csv is missing

Copy the file found in the Java example: data-engineering-zoomcamp/week\_6\_stream\_processing/java/kafka\_examples/src/main/resources/rides.csv


## Kafka \- python videos have low audio and hard to follow up

tip:As the videos have low audio so I downloaded them and used VLC media player with putting the audio to the max 200% of original audio and the audio became quite good or try to use auto caption generated on Youtube directly.

## Kafka Python Videos \- Rides.csv

There is no clear explanation of the rides.csv data that the producer.py python programs use. You can find that here [https://raw.githubusercontent.com/DataTalksClub/data-engineering-zoomcamp/2bd33e89906181e424f7b12a299b70b19b7cfcd5/week\_6\_stream\_processing/python/resources/rides.csv](https://raw.githubusercontent.com/DataTalksClub/data-engineering-zoomcamp/2bd33e89906181e424f7b12a299b70b19b7cfcd5/week_6_stream_processing/python/resources/rides.csv). 

## kafka.errors.NoBrokersAvailable: NoBrokersAvailable

If you have this error, it most likely that your kafka broker docker container is not working.

Use `docker ps` to confirm

Then in the docker compose yaml file folder, run `docker compose up -d` to start all the instances.

## Kafka homework Q3, there are options that support scaling concept more than the others:

Ankush said we can focus on horizontal scaling option.

“think of scaling in terms of scaling from consumer end. Or consuming message via horizontal scaling”

## How to fix docker compose error: Error response from daemon: pull access denied for spark-3.3.1, repository does not exist or may require 'docker login': denied: requested access to the resource is denied

If you get this error, know that you have not built your sparks and juypter images. This images aren’t readily available on dockerHub. 

In the spark folder, run `./build.sh` from a bash cli to to build all images before running docker compose

## Python Kafka: ./build.sh: Permission denied Error

Run this command in terminal in the same directory (/docker/spark):

chmod \+x build.sh

## Python Kafka: ‘KafkaTimeoutError: Failed to update metadata after 60.0 secs.’ when running stream-example/producer.py

Restarting all services worked for me: 

docker-compose down

docker-compose up 

## Python Kafka: ./spark-submit.sh streaming.py \- ERROR StandaloneSchedulerBackend: Application has been killed. Reason: All masters are unresponsive\! Giving up.

While following [tutorial 13.2](https://www.youtube.com/watch?v=5hRJ8-6Fpyk&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=79) , when running ./spark-submit.sh streaming.py, encountered the following error: 

…

24/03/11 09:48:36 INFO StandaloneAppClient$ClientEndpoint: Connecting to master spark://localhost:7077...

24/03/11 09:48:36 INFO TransportClientFactory: Successfully created connection to localhost/127.0.0.1:7077 after 10 ms (0 ms spent in bootstraps)

24/03/11 09:48:54 WARN GarbageCollectionMetrics: To enable non-built-in garbage collector(s) List(G1 Concurrent GC), users should configure it(them) to spark.eventLog.gcMetrics.youngGenerationGarbageCollectors or spark.eventLog.gcMetrics.oldGenerationGarbageCollectors

24/03/11 09:48:56 INFO StandaloneAppClient$ClientEndpoint: Connecting to master spark://localhost:7077…

24/03/11 09:49:16 INFO StandaloneAppClient$ClientEndpoint: Connecting to master spark://localhost:7077...

24/03/11 09:49:36 WARN StandaloneSchedulerBackend: Application ID is not initialized yet.

24/03/11 09:49:36 ERROR StandaloneSchedulerBackend: Application has been killed. Reason: All masters are unresponsive\! Giving up.

…

py4j.protocol.Py4JJavaError: An error occurred while calling None.org.apache.spark.sql.SparkSession.

: java.lang.IllegalStateException: Cannot call methods on a stopped SparkContext.

…

Solution: 

Downgrade your local PySpark to **3.3.1** (same as Dockerfile)

The reason for the failed connection in my case was the mismatch of PySpark versions. You can see that from the logs of spark-master in the docker container. 

**Solution 2:**

* Check what Spark version your local machine has  
  * `pyspark –version`  
  * `spark-submit –version`  
* Add your version to `SPARK_VERSION` in **build.sh**

## Python Kafka: ./spark-submit.sh streaming.py \- How to check why Spark master connection fails

Start a new terminal

Run: **docker ps**

Copy the CONTAINER ID of the spark-master container

Run: **docker exec \-it \<spark\_master\_container\_id\> bash**

Run: **cat logs/spark-master.out** 

Check for the log when the error happened

Google the error message from there

## Python Kafka: ./spark-submit.sh streaming.py Error: py4j.protocol.Py4JJavaError: An error occurred while calling None.org.apache.spark.api.java.JavaSparkContext.

Make sure your java version is 11 or 8\. 

Check your version by: 

**java \--version**

Check all your versions by:

**/usr/libexec/java\_home \-V**

If you already have got java 11 but just not selected as default, select the specific version by: 

**export JAVA\_HOME=$(/usr/libexec/java\_home \-v 11.0.22)**

(or other version of 11\)

## Java Kafka: \<project\_name\>-1.0-SNAPSHOT.jar errors: package xxx does not exist even after gradle build

In my set up, all of the dependencies listed in gradle.build were not installed in \<project\_name\>-1.0-SNAPSHOT.jar.

Solution:

In build.gradle file, I added the following at the end: 

shadowJar { 

archiveBaseName \= "java-kafka-rides"

archiveClassifier \= ''

 }

And then in the command line ran ‘gradle shadowjar’, and run the script from java-kafka-rides-1.0-SNAPSHOT.jar created by the shadowjar

## Python Kafka: Installing dependencies for python3 06-streaming/python/avro\_example/producer.py

**confluent-kafka: \`**pip install confluent-kafka\` or \`conda install conda-forge::python-confluent-kafka\`

**fastavro:** pip install fastavro

Abhirup Ghosh

## Can install Faust Library for Module 6 Python Version due to dependency conflicts? 

The Faust repository and library is no longer maintained \- [https://github.com/robinhood/faust](https://github.com/robinhood/faust) 

If you do not know Java, you now have the option to follow the Python Videos 6.13 & 6.14 here [https://www.youtube.com/watch?v=BgAlVknDFlQ\&list=PL3MmuxUbc\_hJed7dXYoJw8DoCuVHhGEQb\&index=80](https://www.youtube.com/watch?v=BgAlVknDFlQ&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=80)  and follow the RedPanda Python version here [https://github.com/DataTalksClub/data-engineering-zoomcamp/tree/main/06-streaming/python/redpanda\_example](https://github.com/DataTalksClub/data-engineering-zoomcamp/tree/main/06-streaming/python/redpanda_example) \- NOTE: I highly recommend watching the Java videos to understand the concept of streaming but you can skip the coding parts \- all will become clear when you get to the Python videos and RedPanda files. 

## Java Kafka: How to run producer/consumer/kstreams/etc in terminal

In the project directory, run: 

java \-cp build/libs/\<jar\_name\>-1.0-SNAPSHOT.jar:out src/main/java/org/example/JsonProducer.java

## Java Kafka: When running the producer/consumer/etc java scripts, no results retrieved or no message sent

For example, when running JsonConsumer.java, got:

Consuming form kafka started

RESULTS:::0

RESULTS:::0

RESULTS:::0

Or when running JsonProducer.java, got:

Exception in thread "main" java.util.concurrent.ExecutionException: org.apache.kafka.common.errors.SaslAuthenticationException: Authentication failed

Solution:

Make sure in the scripts in src/main/java/org/example/ that you are running (e.g. JsonConsumer.java, JsonProducer.java), the StreamsConfig.BOOTSTRAP\_SERVERS\_CONFIG is the correct server url (e.g. europe-west3 from example vs europe-west2)

Make sure cluster key and secrets are updated in src/main/java/org/example/Secrets.java (KAFKA\_CLUSTER\_KEY and KAFKA\_CLUSTER\_SECRET)

## Java Kafka: Tests are not picked up in VSCode

Situation: in VS Code, usually there will be a triangle icon next to each test. I couldn’t see it at first and had to do some fixes. 

Solution: 

([Source](https://stackoverflow.com/a/66527032))

VS Code 

→ Explorer (first icon on the left navigation bar)

![][image65]  

→ JAVA PROJECTS (bottom collapsable)

![][image66]  
→  ![][image67]icon next in the rightmost position to JAVA PROJECTS

→  clean Workspace 

→ Confirm by clicking Reload and Delete

Now you will be able to see the triangle icon next to each test like what you normally see in python tests.

E.g.: 

![][image68]

You can also add classes and packages in this window instead of creating files in the project directory

## Confluent Kafka: Where can I find schema registry URL?

In [Confluent Cloud](https://confluent.cloud/):

Environment → default (or whatever you named your environment as) → The right navigation bar →  “Stream Governance API” →  The URL under “Endpoint” 

And create credentials from Credentials section below it

## How do I check compatibility of local and container Spark versions?

You can check the version of your local spark using `spark-submit --version`. In the build.sh file of the Python folder, make sure that `SPARK_VERSION` matches your local version. Similarly, make sure the pyspark you pip installed also matches this version. 

## How to fix the error "ModuleNotFoundError: No module named 'kafka.vendor.six.moves'"?

According to https://github.com/dpkp/kafka-python/

“DUE TO ISSUES WITH RELEASES, IT IS SUGGESTED TO USE https://github.com/wbarnha/kafka-python-ng FOR THE TIME BEING”

Use pip install kafka-python-ng instead

## How to fix “connection failed: connection to server at "127.0.0.1", port 5432 failed” error when setting up Postgres connection in pgAdmin?

Instead of using “localhost” as the host name/address, try “postgres”, or “host.docker.internal” instead

**Alternative Solution:** For those having installed postgres locally and disabling persist data on postgres-container in docker i.e. *volume:* removed, remember to use postgres port other than 5432 (e.g. 5433 is usable). And for **pgadmin host name/address**, if *localhost, postgres, and host.docker.internal* is not working, you can use your own *IPv4 Address* which can be found in Windows OS via: Command Prompt \> ipconfig \> Under Wireless LAN adapter WiFi 2\. E.g.:

IPv4 Address. . . . . . . . . . . : 192.168.0.148

## Why is my table not being created in PostgreSQL when I submit a job?

There could be a few reasons for this issue:

* Race Conditions: If you're running multiple processes in parallel.

* Database Connection Issues: The job might not be connecting to the correct PostgreSQL database, or there could be authentication or permission issues preventing table creation.

* Missing Table Creation Logic: The code responsible for creating the table might not be properly included or executed in the job submission process.

As a best practice, it's generally recommended to pre-create tables in PostgreSQL to avoid runtime errors. This ensures the database schema is properly set up before any jobs are executed.

Extra: Use CREATE TABLE IF NOT EXISTS in your code. This will prevent errors if the table already exists and ensure smooth job execution.
