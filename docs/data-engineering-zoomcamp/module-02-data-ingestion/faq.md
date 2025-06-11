---
title: FAQ
parent: Module 2
nav_order: 2
---

# Module 2: Workflow Orchestration

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

## Where are the FAQ questions from the previous cohorts for the orchestration module?

[Prefect](https://docs.google.com/document/d/1K_LJ9RhAORQk3z4Qf_tfGQCDbu8wUWzru62IUscgiGU/edit?usp=sharing%20) [Airflow](https://docs.google.com/document/d/1-BwPAsyDH_mAsn8HH5z_eNYVyBMAtawJRjHHsjEKHyY/edit?usp=sharing%20) [Mage](https://docs.google.com/document/d/1CkHVelbYYTMbwuj2eurNIwWVqXWzH-9-AqKETD9IC3I/edit?tab=t.0)

## How do I launch Kestra?

Start docker in linux with docker run \--pull=always \--rm \-it \-p 8080:8080 \--user=root \\

  \-v /var/run/docker.sock:/var/run/docker.sock \\

  \-v /tmp:/tmp kestra/kestra:latest server local

Once run you can login to dashboard at localhost:8080 

For windows instructions see the Kestra github here [https://github.com/kestra-io/kestra](https://github.com/kestra-io/kestra)

## 

Here sample docker-compose for kestra

services:

  kestra:

    build: .

    image: kestra/kestra:latest

    container\_name: kestra

    user: "0:0"

    environment:

      DOCKER\_HOST: tcp://host.docker.internal:2375  \# for Windows

      KESTRA\_CONFIGURATION: |

        kestra:

          repository:

            type: h2

          queue:

            type: memory

          storage:

            type: local

            local:

              basePath: /app/storage

          tasks:

            tmp-dir:

              path: /app/tmp

          plugins:

            repositories:

              \- id: central

                type: maven

                url: https://repo.maven.apache.org/maven2

            definitions:

              \- io.kestra.plugin.core:core:latest

              \- io.kestra.plugin.scripts:python:1.3.4

              \- io.kestra.plugin.http:http:latest

      KESTRA\_TASKS\_TMP\_DIR\_PATH: /app/tmp

    ports:

      \- "8080:8080"

    volumes:

      \- //var/run/docker.sock:/var/run/docker.sock  \# Windows path

      \- /yourpath/.dbt:/app/.dbt

      \- /yourpath/kestra/plugins:/app/plugins

      \- /yourpath/kestra/workflows:/app/workflows

      \- /yourpath/kestra/storage:/app/storage

      \- /yourpath//kestra/tmp:/app/tmp

      \- /yourpath//dbt\_prj:/app/workflows/dbt\_project

      \- /yourpath//my-creds.json:/app/.dbt/my-creds.json

    command: server standalone

## docker: Error response from daemon: mkdir C:\\Program Files\\Git\\var: Access is denied.

Description:

Running the command below in Bash with Docker running and WSL2 installed. Even running Bash as admin won’t work

\`\`\`:

$ docker run \--pull=always \--rm \-it \-p 8080:8080 \--user=root \-v 

/var/run/docker.sock:/var/run/docker.sock \-v /tmp:/tmp kestra/kestra:latest server local

latest: Pulling from kestra/kestra

Digest: sha256:af02a309ccbb52c23ad1f1551a1a6db8cf0523cf7aac7c7eb878d7925bc85a62

Status: Image is up to date for kestra/kestra:latest

docker: Error response from daemon: mkdir C:\\\\Program Files\\\\Git\\\\var: Access is denied.

See 'docker run \--help'.

\`\`\`

The error mentioned above will appear and localhost wont shows the Kestra UI, the solution is to run Command Prompt as admin with the following command:

\`\`\`

docker run \--pull=always \--rm \-it \-p 8080:8080 \--user=root ^

    \-v "/var/run/docker.sock:/var/run/docker.sock" ^

    \-v "C:/Temp:/tmp" kestra/kestra:latest server local

\`\`\`

This works flawlessly and localhost shows Kestra UI as usual.

## Error when running Kestra flow connecting to postgres.

Error: org.postgresql.util.psqlexception the connection attempt failed due to this config on kestra flow \-\> jdbc:postgresql://host.docker.internal:5432/postgres-zoomcamp

Solution: Just replace host.docker.internal for the name of the service for postgres in docker compose. 

—---

I also encountered a similar error as above, slightly different error message:

org.postgresql.util.PSQLException: The connection attempt failed. 2025-01-29 22:52:22.281 green\_create\_table The connection attempt failed. host.docker.internal

I could download my dataset by executing my flow, but when i wanted to ingest it to the pg database, the connection to pg failed. 

The main issue was that the pg database url is different for linux than the url in the tutorial. Namely, instead of host.docker.internal, linux users will use the service or container name for postgres, which for me was just postgres.   
`url: jdbc:postgresql://postgres:5432/kestra`

Voila. Also, make sure to double check your pg database name. Mine was kestra in the docker compose file, whereas in the tutorial they had named it postgres-zoomcamp. 

## Adding a pgadmin service with volume mounting to the docker-compose: 

I encountered an error where the localhost url for pgadmin would just hang up (i chose localhost:8080 for my pgadmin, and made kestra localhost:8090, personal preference). 

The associated error was: 

| | \[2025-01-30 02:38:49 \+0000\] \[91\] \[INFO\] Worker exiting (pid: 91\) 2\_kestra-pgadmin-1 | ERROR : Failed to create the directory /var/lib/pgadmin/sessions: 2\_kestra-pgadmin-1 | \[Errno 13\] Permission denied: '/var/lib/pgadmin/sessions' 2\_kestra-pgadmin-1 | HINT : Create the directory /var/lib/pgadmin/sessions, ensure it is writeable by 2\_kestra-pgadmin-1 | 'pgadmin', and try again, or, create a config\_local.py file 2\_kestra-pgadmin-1 | and override the SESSION\_DB\_PATH setting per 2\_kestra-pgadmin-1 | https://www.pgadmin.org/docs/pgadmin4/8.14/config\_py.html 2\_kestra-pgadmin-1 | \[2025-01-30 02:38:50 \+0000\] \[1\] \[ERROR\] Worker (pid:91) exited with code 1 2\_kestra-pgadmin-1 | \[2025-01-30 02:38:50 \+0000\] \[1\] \[ERROR\] Worker (pid:91) exited with code 1\. 2\_kestra-pgadmin-1 | \[2025-01-30 02:38:50 \+0000\] \[92\] \[INFO\] Booting worker with pid: 92 |
| :---- |

And the resolution involved changing the ownership of my local directory to the user “5050” which is pgadmin. Unlike postgres, pgadmin requires you to give it permission. Apparently the postgres user inside the docker container creates the postgres volume/dir, so it has permission\`s already.   
This is a good source: [https://stackoverflow.com/questions/64781245/permission-denied-var-lib-pgadmin-sessions-in-docker](https://stackoverflow.com/questions/64781245/permission-denied-var-lib-pgadmin-sessions-in-docker)G

## Running out of storage when using kestra with postgres on GCP VM

Running out of storage while trying to backfill. I realized my GCP VM only has 30GB of storage and I was eating it up\! Couple things I did/would suggest: 

1. Clean up your GCP VM drive. You can use this command to see what is taking up the most space:  $ sudo du \-sh \*  
2. (\~1gb) For me, Anaconda installer was taking up lots of space \- you can delete that immediately because I already installed anaconda. I don’t need the installer anymore. 

   Rm \-rf  \<anacondainstaller\_fpath\>

3. (\~3gb) Anaconda also takes up lots of space. You can’t delete it all if you want to run python, but you can clean it up significantly. I don’t care much about libs, etc. because I can build them in a docker container\! Command is $ conda clean \--all \-y  
4. You can clean up your kestra files with a purge flow. Here is the generic one: [https://kestra.io/docs/administrator-guide/purge](https://kestra.io/docs/administrator-guide/purge)  
   1. I personally wanted to do it immediately, not at end of month, so I made end date just now and got rid of the trigger block. You can also specify if you want to removed FAILED state executions, but I chose not to: `endDate: "{{ now() }}"`   
5. You can clean up your pg database by manually deleting tables in pgadmin. Or possibly set up a workflow for it in kestra, but it was easy enough to manually delete. 

## How can Kestra access service account credential?

Do not directly add the content of service account credential json in Kestra script, especially if we are pushing to Github. Follow the instruction to add the service account as a secret [Configure Google Service Account](https://kestra.io/docs/how-to-guides/google-credentials#add-service-account-as-a-secret).

When we need to use it in Kestra, we can pull it through `{{ secret('GCP_SERVICE_ACCOUNT') }}`

In the pluginDefaults.

## Storage Bucket Permission Denied Error when running the gcp\_setup flow

When following the [youtube lesson](https://www.youtube.com/watch?v=nKqjjLJ7YXs&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=23) and then running the [gcp\_setup flow](https://github.com/DataTalksClub/data-engineering-zoomcamp/blob/main/02-workflow-orchestration/flows/05_gcp_setup.yaml), I get the following error:

| 2025-02-03 08:12:17.991create\_gcs\_bucket2i78v7qCFw9Q7rKzR424iMzoomcamp@kestra-sandbox-449806.iam.gserviceaccount.com does not have storage.buckets.get access to the Google Cloud Storage bucket. Permission 'storage.buckets.get' denied on resource (or it may not exist).2025-02-03 08:12:17.991create\_gcs\_bucket2i78v7qCFw9Q7rKzR424iM403 Forbidden GET https://storage.googleapis.com/storage/v1/b/kestra-de-zoomcamp-bucket?projection=full { "code" : 403, "errors" : \[ { "domain" : "global", "message" : "zoomcamp@kestra-sandbox-449806.iam.gserviceaccount.com does not have storage.buckets.get access to the Google Cloud Storage bucket. Permission 'storage.buckets.get' denied on resource (or it may not exist).", "reason" : "forbidden" } \], "message" : "zoomcamp@kestra-sandbox-449806.iam.gserviceaccount.com does not have storage.buckets.get access to the Google Cloud Storage bucket. Permission 'storage.buckets.get' denied on resource (or it may not exist)." } |
| :---- |

I tried manually creating the bucket in the GCP console, but this showed me that the bucket already existed. So I came up with another name for the bucket and it worked. 

The GCP bucket name has to be unique globally across all buckets, even if those are not your buckets, because the bucket will be accessible by URL.

## Invalid dataset ID Error Error when running the gcp\_setup flow

When following the [youtube lesson](https://www.youtube.com/watch?v=nKqjjLJ7YXs&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=23) and then running the [gcp\_setup flow](https://github.com/DataTalksClub/data-engineering-zoomcamp/blob/main/02-workflow-orchestration/flows/05_gcp_setup.yaml),  it works until the create\_bq\_dataset task, where I got the following error:

| 2025-02-03 08:44:12.162Invalid dataset ID "de-zoomcamp". Dataset IDs must be alphanumeric (plus underscores) and must be at most 1024 characters long.2025-02-03 08:44:12.162400 Bad Request POST https://bigquery.googleapis.com/bigquery/v2/projects/kestra-sandbox-449806/datasets?prettyPrint=false { "code": 400, "errors": \[ { "domain": "global", "message": "Invalid dataset ID \\"de-zoomcamp\\". Dataset IDs must be alphanumeric (plus underscores) and must be at most 1024 characters long.", "reason": "invalid" } \], "message": "Invalid dataset ID \\"de-zoomcamp\\". Dataset IDs must be alphanumeric (plus underscores) and must be at most 1024 characters long.", "status": "INVALID\_ARGUMENT" |
| :---- |

While not very apparent from the error message, we are not suppose to use a dash in the dataset name, so I changed the dataset name to “de\_zoomcamp” and it worked.

## How do I properly authenticate a Google Cloud Service Account in Kestra?

Several authentication methods are available;  
These are some of the most straightforward approaches.

### **Method 1:**

Update your docker-compose.yml file as follows:

| volumes:     \- \~/.path-to/service-account.json:/.path-to/service-account.json   environment:     GOOGLE\_APPLICATION\_CREDENTIALS: '/.path-to/service-account.json' |
| :---- |

### **Method 2:**

#### **Step 1: Store the Service Account as a Secret**

1. Run this command, specifying the **correct path** to your service-account.json file and .env\_encoded:


| echo SECRET\_GCP\_SERVICE\_ACCOUNT=$(cat /path/to/service-account.json | base64 \-w 0\) \>\> /path/to/.env\_encoded   |
| :---- |

2. Modify docker-compose.yml to include the encoded secrets:


| kestra:  env\_file: /path/to/.env\_encoded  |
| :---- |

#### **Step 2: Configure Kestra Plugin Defaults**

This ensures all GCP tasks use the secret automatically:


| pluginDefaults:  \- type: io.kestra.plugin.gcp    values:      serviceAccount: "{{ secret('GCP\_SERVICE\_ACCOUNT') }}" |
| :---- |

#### **Step 3: Verify it’s working in a testing GCP workflow** 

| namespace: testing-credentialstasks:  \- id: create\_gcs\_bucket    type: io.kestra.plugin.gcp.gcs.CreateBucket    ifExists: SKIP    storage class: REGIONAL    name: “testing-cred-bucket” \# "{{ kv('GCP\_BUCKET\_NAME') }}" |
| :---- |

### **Additional \- QA**

	**Question:** How do I update the Service Account key?  

**Answer:** Generate a new key, re-run the Base64 command, and restart Kestra.


**Question:** Why use secrets instead of embedding the JSON key in the task?  

**Answer**: Secrets prevent credential exposure and make workflows easier to manage.


**Question**: Can I apply this method to other GCP tasks?  

**Answer**: Yes, all GCP plugins will automatically inherit the secret.


## Should I include my .env\_encoded file in my .gitignore?

⚠️ Yes, you should definitely include the .env\_encoded file in your .gitignore file. Here's why:

* Security: The .env\_encoded file contains sensitive information, namely the base64 encoded version of your GCP Service Account key. Even though it's encoded, it's not secure to share this in a public repository as anyone can decode it back to the original JSON.  
* Best Practices: It's a common practice to not commit environment files or any files containing secrets to version control systems like Git. This prevents accidental exposure of sensitive data.

⚠️ ***How to do it:***  
\# Add this line to your .gitignore file  
.env\_encoded

⚠️ ***More on Security:***  
Base64 encoding is easily reversible. Base64 is an encoding scheme, not an encryption method. It's designed to encode binary data into ASCII characters that can be safely transmitted over systems that are designed to deal with text. Here's why it's not secure for protecting sensitive information:

* **Reversibility:** Base64 encoding simply translates binary data into a text string using a specific set of 64 characters. Decoding it back to the original data is straightforward and doesn't require any secret key or password.  
* **Public Availability of Tools:** Numerous online tools, software libraries, and command-line utilities exist that can decode base64 with just a few clicks or commands.  
* **No Security:** Since base64 encoding does not change or hide the actual content of the data, anyone with access to the encoded string can decode it back to the original data.

## Question: Getting SIGILL in JRE when running latest kestra image on Mac M4 MacOS 15.2/3 ![][image23]

## taskid: yellow\_create\_table The connection attempt failed. Host.docker.internal

If you're using Linux, you might encounter Connection Refused errors when connecting to the Postgres DB from within Kestra. This is because host.docker.internal works differently on Linux.

Using the modified Docker Compose file in 02-workflow-orchestration readme troubleshooting tips **Docker Compose Example**, you can run both Kestra and its dedicated Postgres DB, as well as the Postgres DB for the exercises all together. You can access it within Kestra by referring to the container name postgres\_zoomcamp instead of host.docker.internal in pluginDefaults. 

**The pluginDefaults exist in both 2\_postgres\_taxi\_scheduled.yaml, 02\_postgres\_taxi.yaml, please modify as shown below.** 

![][image24]

## Fix: Add extra\_hosts for host.docker.internal on Linux

This update corrects the Docker Compose configuration to resolve the error when using the alias \`host.docker.internal\` on Linux systems. Since this alias does not resolve natively on Linux, the following entry was added to the affected container:

 kestra:

    image: kestra/kestra:latest

    pull\_policy: always

    user: "root"

    command: server standalone

    volumes:...

    environment:...

    ports:...

    depends\_on:...

    extra\_hosts:

      \- "host.docker.internal:host-gateway"

  extra\_hosts:

    \- "host.docker.internal:host-gateway"

With this change, containers that need to access host services via \`host.docker.internal\` will be able to do so correctly. For inter-container communication within the same network, it is recommended to use the service name directly.

## Fix: Add extra\_hosts for taskRunner in the dbt-build

Adds the extraHosts configuration to the taskRunner in the dbt-build task to resolve the issue with host.docker.internal not being recognized on Linux.

    taskRunner:  
      type: io.kestra.plugin.scripts.runner.docker.Docker  
      extraHosts:  
          \- "host.docker.internal:host-gateway"

## Kestra: Don’t forget to set GCP\_CREDS variable

If you plan on using Kestra with Google Cloud Platform, make sure you setup the GCP\_CREDS that’s gonna be used in the flows that has “gcp” on its name.

To set it, go to Namespaces, and then select “zoomcamp” if you are using the same examples used in the lessons. Then in the “KV Store” tab create the new key as GCP\_CREDS and set the type to JSON and paste the content of the .json file with credentials for the service account created.

## Kestra: Backfill showing getting executed but not getting results or showing up in executions:

It seems to be a bug. Current fix is to remove the timezone from triggers in the script. More on this bug is [here](https://github.com/kestra-io/kestra/issues/7227).
