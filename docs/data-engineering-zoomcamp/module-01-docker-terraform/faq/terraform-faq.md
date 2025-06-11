---
title: Terraform FAQ
description: Frequently asked questions and troubleshooting guide for Terraform issues in the Data Engineering Zoomcamp
parent: Module 1 FAQ
nav_order: 13
has_children: false
---

# Terraform FAQ
{: .no_toc }

This guide covers common Terraform issues and their solutions for the Data Engineering Zoomcamp, focusing on Google Cloud Platform integration.
{: .fs-6 .fw-300 }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## Installation & Setup

### Installing Terraform on WSL

**Problem:** Need to install Terraform on Windows Subsystem for Linux.

**Solution:** Follow the comprehensive installation guide:
- [Configuring Terraform on Windows 10 Linux Subsystem](https://techcommunity.microsoft.com/t5/azure-developer-community-blog/configuring-terraform-on-windows-10-linux-sub-system/ba-p/393845)

### Terraform 1.1.3 for Linux AMD64

**Problem:** Need to download a specific version of Terraform for Linux.

**Solution:** Download directly from HashiCorp releases:
- [Terraform 1.1.3 Linux AMD64](https://releases.hashicorp.com/terraform/1.1.3/terraform_1.1.3_linux_amd64.zip)

### Terraform initialized in empty directory

**Problem:** Getting "The directory has no Terraform configuration files" error.

**Root Cause:** Running `terraform init` outside the working directory that contains Terraform configuration files.

**Solution:** Navigate to the directory containing your `.tf` files before running terraform commands:
```bash
cd /path/to/your/terraform/project
terraform init
```

---

## Network & Connectivity Issues

### Failed to query available provider packages

**Problem:** 
```
Error: Failed to query available provider packages
Could not retrieve the list of available versions for provider hashicorp/google: 
could not query provider registry for registry.terraform.io/hashicorp/google: 
the request failed after 2 attempts, please try again later
```

**Root Cause:** Internet connectivity issues preventing access to Terraform registry.

**Solution:**
1. Check your VPN/Firewall settings
2. Clear browser cookies and cache
3. Restart your network connection
4. Run `terraform init` again after resolving connectivity issues

### OAuth2 token fetch failure

**Problem:**
```
Error: Post "https://storage.googleapis.com/storage/v1/b?alt=json&prettyPrint=false&project=your-project": 
oauth2: cannot fetch token: Post "https://oauth2.googleapis.com/token": 
dial tcp 172.217.163.42:443: i/o timeout
```

**Root Cause:** Google services not accessible in your region, terminal not following system proxy settings.

**Solution:**
1. Configure your VPN properly
2. Enable Enhanced Mode in your VPN application (e.g., Clash)
3. Contact your VPN provider for specific configuration assistance
4. Ensure your terminal can access Google APIs through the proxy

---

## Authentication & Credentials

### Invalid JWT Token error on WSL

**Problem:**
```
Error: Post "https://storage.googleapis.com/storage/v1/b?alt=json&prettyPrint=false&project=<your-project-id>": 
oauth2: cannot fetch token: 400 Bad Request
Response: {"error":"invalid_grant","error_description":"Invalid JWT: Token must be a short-lived token (60 minutes) and in a reasonable timeframe. Check your iat and exp values in the JWT claim."}
```

**Root Cause:** Time desynchronization on your machine affecting JWT token computation.

**Solution:** Synchronize your system clock:
```bash
sudo hwclock -s
```

### Access Denied (Error 403)

**Problem:**
```
Error: googleapi: Error 403: Access denied., forbidden
```

**Root Cause:** `$GOOGLE_APPLICATION_CREDENTIALS` environment variable not pointing to the correct service account key file.

**Solution:**
1. Set the correct path to your service account key:
   ```bash
   export GOOGLE_APPLICATION_CREDENTIALS=~/.gc/YOUR_JSON.json
   ```
2. Activate the service account:
   ```bash
   gcloud auth activate-service-account --key-file $GOOGLE_APPLICATION_CREDENTIALS
   ```

### Insufficient authentication scopes

**Problem:**
```
Error: googleapi: Error 403: Access denied., forbidden
Error: Error creating Dataset: googleapi: Error 403: Request had insufficient authentication scopes.
```

**Root Cause:** Service account credentials not properly configured or have insufficient permissions.

**Solution:**
1. Verify your credentials are set:
   ```bash
   echo $GOOGLE_APPLICATION_CREDENTIALS
   echo $?
   ```
2. If needed, reset your credentials:
   ```bash
   export GOOGLE_APPLICATION_CREDENTIALS="<path/to/your/service-account-authkeys>.json"
   ```

### Permission denied for storage.buckets.create

**Problem:**
```
Error: googleapi: Error 403: terraform-trans-campus@trans-campus-410115.iam.gserviceaccount.com 
does not have storage.buckets.create access to the Google Cloud project. 
Permission 'storage.buckets.create' denied on resource (or it may not exist)., forbidden
```

**Root Cause:** Using Project Name instead of Project ID in configuration.

**Solution:** Use your **Project ID** (not Project Name) in your Terraform configuration. Find your Project ID in the GCP Console Dashboard.

### Service account configuration

**Problem:** Need guidance on service account setup for Terraform.

**Solution:** 
- **One service account is sufficient** for all services/resources used in this course
- Once you have your credentials JSON file and set your environment variable, you're ready to proceed

### Google provider credentials configuration

**Problem:** Need to properly configure Google provider in Terraform.

**Solution:** Use this secure provider configuration:
```hcl
provider "google" {
  project     = var.projectId
  credentials = file("${var.gcpkey}")
  #region      = var.region
  zone        = var.zone
}
```

---

## State Management & Operations

### State lock acquisition error

**Problem:** Terraform state lock issues preventing operations.

**Solution:** 
- Reference the detailed solution in the GitHub issue: [Terraform State Lock Issue #14513](https://github.com/hashicorp/terraform/issues/14513)
- Common approaches include:
  - Force unlock with `terraform force-unlock <lock-id>`
  - Check for stuck processes
  - Verify state backend accessibility

### BigQuery Dataset deletion error

**Problem:**
```
Error: Error when reading or editing Dataset: googleapi: Error 400: 
Dataset terraform-demo-449214:homework_dataset is still in use, resourceInUse
```

**Root Cause:** Dataset contains tables that prevent deletion.

**Solution:** Set the `delete_contents_on_destroy` property to `true` in your `main.tf` file:
```hcl
resource "google_bigquery_dataset" "dataset" {
  dataset_id                  = "homework_dataset"
  friendly_name               = "test"
  description                 = "This is a test description"
  location                    = "EU"
  default_table_expiration_ms = 3600000
  
  delete_contents_on_destroy = true
}
```

