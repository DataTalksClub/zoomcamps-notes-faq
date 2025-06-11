---
title: Git FAQ
description: Frequently asked questions and troubleshooting guide for Git, Git Bash, and GitHub Codespaces in the Data Engineering Zoomcamp
parent: Module 1 FAQ
nav_order: 3
has_children: false
---

# Git FAQ
{: .no_toc }

This guide covers common Git, Git Bash, and GitHub Codespaces issues and their solutions for the Data Engineering Zoomcamp.
{: .fs-6 .fw-300 }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## Git & Shell Configuration

### Backslash escape character in Git Bash (Windows)

**Problem:** Need to configure backslash as an escape character in Git Bash for Windows.

**Solution:** Configure the escape character setting:
```bash
bash.escapeChar=\
```

**Note:** This doesn't need to be included in your `.bashrc` file - just run it in the terminal when needed.

---

## GitHub Codespaces

### Managing secrets in GitHub Codespaces

**Problem:** Need to store and manage sensitive information (API keys, credentials) securely in GitHub Codespaces.

**Solution:** Use GitHub's built-in secrets management for Codespaces:

1. **Access secrets settings:**
   - Go to your GitHub account settings
   - Navigate to Codespaces section
   - Manage account-specific secrets

2. **Add secrets:**
   - Create new secrets with appropriate names
   - Set values for your sensitive data
   - Configure access permissions for repositories

**Reference:** [GitHub Documentation - Managing account-specific secrets for GitHub Codespaces](https://docs.github.com/en/codespaces/managing-your-codespaces/managing-your-account-specific-secrets-for-github-codespaces#about-secrets-for-github-codespaces)

**Best practices:**
- Use descriptive names for secrets (e.g., `GCP_SERVICE_ACCOUNT_KEY`)
- Limit secret access to specific repositories when possible
- Regularly rotate sensitive credentials

### pgAdmin blank screen in GitHub Codespaces

**Problem:** Blank screen when running pgAdmin in Docker with GitHub Codespaces.

**Root Cause:** pgAdmin doesn't work properly with Codespaces' reverse proxy configuration by default.

**Solution:** Add proxy configuration environment variables to your pgAdmin setup:

**Docker run command:**
```bash
docker run --rm -it \
    -e PGADMIN_DEFAULT_EMAIL="admin@admin.com" \
    -e PGADMIN_DEFAULT_PASSWORD="root" \
    -e PGADMIN_CONFIG_PROXY_X_HOST_COUNT=1 \
    -e PGADMIN_CONFIG_PROXY_X_PREFIX_COUNT=1 \
    -p "8080:80" \
    --name pgadmin \
    --network=pg-network \
    dpage/pgadmin4
```

**Docker Compose configuration:**
```yaml
services:
  pgadmin:
    image: dpage/pgadmin4
    environment:
      - PGADMIN_DEFAULT_EMAIL=admin@admin.com
      - PGADMIN_DEFAULT_PASSWORD=root
      - PGADMIN_CONFIG_PROXY_X_HOST_COUNT=1
      - PGADMIN_CONFIG_PROXY_X_PREFIX_COUNT=1
    ports:
      - "8080:80"
    networks:
      - pg-network
```

**Key environment variables:**
- `PGADMIN_CONFIG_PROXY_X_HOST_COUNT=1` - Configures proxy host handling
- `PGADMIN_CONFIG_PROXY_X_PREFIX_COUNT=1` - Configures proxy prefix handling

These variables enable pgAdmin to work correctly with GitHub Codespaces' reverse proxy system.


