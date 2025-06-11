---
title: Google Cloud Platform FAQ
description: Frequently asked questions and troubleshooting guide for Google Cloud Platform (GCP) issues in the Data Engineering Zoomcamp
parent: Module 1 FAQ
nav_order: 11
has_children: false
---

# Google Cloud Platform FAQ
{: .no_toc }

This guide covers common Google Cloud Platform issues and their solutions for the Data Engineering Zoomcamp, including VM management, authentication, billing, and service configuration.
{: .fs-6 .fw-300 }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## VM & Infrastructure Issues

### Changing IP addresses when VM restarts

**Problem:** VM IP address changes every time the instance restarts, breaking SSH connections and configurations.

**Root Cause:** VMs use ephemeral IP addresses by default, which change after each restart.

**Solution:** Set up a static IP address:

1. **Create static IP:**
   - Go to VPC Network → IP addresses in GCP Console
   - Create a new static IP address

2. **Attach to VM:**
   - Assign the static IP to your VM instance
   - This prevents extra charges (you're only charged for unassigned static IPs)

3. **Update configurations:**
   - Your SSH config file will remain valid between VM restarts
   - No need to update connection settings repeatedly

**Benefits:**
- Consistent IP address across restarts
- No additional configuration changes needed
- Cost-effective (no charges when IP is attached)

### Compute Engine metadata access failure

**Problem:**
```
Failed to load
```
When trying to access the metadata section in Compute Engine (e.g., to add SSH keys).

**Root Cause:** Compute Engine API is not enabled for the project.

**Solution:** Enable the Compute Engine API:
1. Go to [Google Cloud Marketplace](https://console.cloud.google.com/marketplace/details/google/compute.googleapis.com)
2. Enable the Compute Engine API
3. Wait a few minutes for the API to be fully activated
4. Retry accessing the metadata section

### VM instance deletion concerns

**Problem:** Uncertainty about whether to delete VM instance after completing lectures.

**Solution:** **Do NOT delete your VM instance** in Google Cloud Platform. Keep it running as you'll need it again for:
- Week 1 readings and assignments
- Future course modules
- Ongoing project work

**Cost management tip:** Stop (don't delete) the instance when not in use to save on compute costs while preserving your setup.

---

## Authentication & SDK Setup

### Google Cloud SDK PATH issue on Windows

**Problem:**
```
The installer is unable to automatically update your system PATH. 
Please add C:\tools\google-cloud-sdk\bin
```

**Root Cause:** Windows PATH environment variable wasn't automatically updated during SDK installation.

**Solution:** Configure environment properly:

1. **Install Anaconda Navigator:**
   - Check "Add conda to the PATH" during installation

2. **Install/reinstall Git Bash with these options:**
   - Add GitBash to Windows Terminal
   - Use Git and optional Unix tools from command prompt

3. **Configure bash profile:**
   ```bash
   conda init bash
   ```

4. **Optional:** Set GitBash as default terminal in Windows Terminal settings

### Windows SDK installation and authentication issues

**Problem:**
```
WARNING: Cannot find a quota project to add to ADC. You might receive a "quota exceeded" or "API not enabled" error.
```

**Root Cause:** Improper SDK installation or missing project configuration.

**Solution:** Reinstall and configure SDK properly:

1. **Reinstall SDK:**
   ```cmd
   # Extract and run installation
   unzip google-cloud-sdk.zip
   google-cloud-sdk\install.bat
   ```

2. **Verify installation:**
   ```bash
   gcloud version
   ```

3. **Initialize project:**
   ```bash
   gcloud init
   ```

4. **Set up application default credentials:**
   ```bash
   gcloud auth application-default login
   ```

### gcloud auth hanging in VS Code with WSL2

**Problem:** `gcloud auth application-default login` command hangs in VS Code with WSL2.

**Root Cause:** Browser authentication flow conflicts with WSL2 environment.

**Solution:** Follow specific authentication steps:

1. **Don't click the browser prompt** (it will show an error)
2. **Ctrl+click the long authentication link** that appears in terminal
3. **Configure Trusted Domains** in the popup that appears
4. **Select first or second entry** from the options

**Result:** Future `gcloud auth` attempts will open in your default browser automatically.

---

## Project & Billing Configuration

### Project creation failed error

**Problem:**
```
WARNING: Project creation failed: HttpError accessing https://cloudresourcemanager.googleapis.com/v1/projects?alt=json: 
response: {...}, "error": {"code": 409, "message": "Requested entity already exists", "status": "ALREADY_EXISTS"}
```

**Root Cause:** Project IDs must be globally unique across ALL GCP users. Once a project ID is used by any user, it cannot be reused.

**Solution:** Create a more unique project identifier:
- Add your name, numbers, or random characters
- Example: `de-zoomcamp-yourname-2024` instead of `de-zoomcamp`
- Use timestamp or random strings for uniqueness

### Billing account error

**Problem:**
```
Error 403: The project to be billed is associated with an absent billing account., accountDisabled
```

**Root Cause:** Either incorrect project ID or missing billing account configuration.

**Solution:** Check and fix billing setup:

1. **Verify project ID:**
   - Ensure you're using YOUR specific project ID
   - Each student needs their own unique project

2. **Link billing account:**
   - Go to Billing in GCP Console
   - Link your billing account to the current project
   - Ensure billing is enabled

### Billing not enabled error despite activation

**Problem:**
```
Error: Error updating Dataset "projects/<your-project-id>/datasets/demo_dataset": 
googleapi: Error 403: Billing has not been enabled for this project.
```
Despite having enabled billing.

**Root Cause:** Billing configuration cache or synchronization issue.

**Solution:** Reset billing configuration:
1. **Disable billing** for the project in GCP Console
2. **Wait a few minutes**
3. **Re-enable billing** for the project
4. **Wait for changes to propagate** (5-10 minutes)

This process refreshes the billing configuration and resolves the issue.

### OR-CBAT-15 ERROR for free trial account

**Problem:** Google refuses credit/debit card during free trial account setup.

**Root Cause:** Geographic or card-specific restrictions for GCP free trial.

**Solution:** Try alternative payment methods:

1. **Try a different card** (different bank or type)
2. **Regional considerations:**
   - Kaspi (Kazakhstan) cards may not work
   - TBC (Georgia) cards typically work
   - Pyypl web-card might work as alternative
3. **Contact support** (though they may have limited ability to help)

---

## Service Accounts & Keys

### Finding the service account JSON file

**Problem:** Cannot locate the "ny-rides.json" service account file.

**Root Cause:** The file needs to be generated from your GCP project.

**Solution:** Generate your service account key:

1. **Navigate to service accounts:**
   - Go to GCP Console
   - Select your project
   - Go to IAM & Admin → Service Accounts

2. **Create key:**
   - Click on the service account email
   - Go to "KEYS" tab
   - Click "Add Key" → "Create new key"
   - Select JSON format
   - Click "Create"

3. **Download and secure:**
   - File will download automatically
   - Store securely and never commit to version control

**Note:** The service account JSON file is project-specific and private to your account.

---

## SSH & Access Issues

### SSH public key errors with multiple users

**Problem:** SSH connection fails due to username mismatches between SSH configuration and VM.

**Root Cause:** Mismatch between SSH username configuration and actual VM username.

**Solution:** Align usernames across configurations:

1. **Check VM username:**
   - Visible in GCP Console under VM instance details
   - Note the actual username shown

2. **Update SSH configuration:**
   - SSH public key file
   - GCP Console SSH keys section
   - Local SSH config file (`~/.ssh/config`)

3. **Temporary access:**
   - Use browser-based SSH in GCP Console while fixing configuration
   - This allows you to access the VM to troubleshoot

**Example SSH config:**
```
Host gcp-vm
    HostName <EXTERNAL_IP>
    User <CORRECT_USERNAME>
    IdentityFile ~/.ssh/gcp
```
