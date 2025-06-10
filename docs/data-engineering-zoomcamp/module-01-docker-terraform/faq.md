---
title: FAQ
parent: Module 1
nav_order: 2
---

# Module 1: Docker and Terraform - FAQ
{: .fs-9 }

Common questions, troubleshooting tips, and solutions for Docker and Terraform module.
{: .fs-6 .fw-300 }

---

## 🐳 Docker FAQ

### Installation & Setup

**Q: Docker Desktop won't start on Windows**
A: Try these solutions:
1. Enable WSL 2 in Windows Features
2. Update Windows to latest version
3. Enable Hyper-V if available
4. Run Docker Desktop as Administrator

**Q: Getting "permission denied" errors on Linux**
A: Add your user to the docker group:
```bash
sudo usermod -aG docker $USER
# Logout and login again
```

**Q: Docker is slow on Windows/macOS**
A: 
- Allocate more resources to Docker Desktop (Settings > Resources)
- Use WSL 2 backend on Windows
- Consider using Docker on a Linux VM for better performance

### Running Containers

**Q: Container exits immediately**
A: Check the logs first:
```bash
docker logs <container-name>
```
Common causes:
- Application crashes on startup
- Wrong command or entrypoint
- Missing environment variables

**Q: Can't access application running in container**
A: Make sure ports are properly mapped:
```bash
# Correct port mapping
docker run -p 8080:80 nginx

# Check if port is actually exposed
docker port <container-name>
```

**Q: Changes to my code don't reflect in the container**
A: You need to either:
1. Rebuild the image: `docker build -t myapp .`
2. Use bind mounts for development: `docker run -v $(pwd):/app myapp`

### Docker Compose

**Q: Services can't communicate with each other**
A: 
- Make sure services are on the same network (default behavior)
- Use service names as hostnames (not localhost)
- Check if ports are exposed between services (not necessarily to host)

Example:
```yaml
services:
  web:
    build: .
    ports:
      - "8000:8000"
  
  db:
    image: postgres:13
    # No ports mapping needed for internal communication
```

**Q: Database connection fails**
A: Common issues:
- Database not ready when app starts (use `depends_on` and health checks)
- Wrong hostname (use service name, not localhost)
- Missing environment variables

```yaml
services:
  app:
    depends_on:
      db:
        condition: service_healthy
  
  db:
    image: postgres:13
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${POSTGRES_USER}"]
      interval: 30s
      timeout: 10s
      retries: 3
```

### Data Persistence

**Q: My data disappears when container restarts**
A: Use volumes to persist data:
```bash
# Named volume
docker run -v postgres_data:/var/lib/postgresql/data postgres

# Bind mount
docker run -v /host/path:/container/path postgres
```

**Q: Permission issues with bind mounts**
A: On Linux, set correct ownership:
```bash
# Find container user ID
docker run --rm <image> id

# Set ownership on host
sudo chown -R <uid>:<gid> /host/path
```

---

## 🏗️ Terraform FAQ

### Installation & Setup

**Q: Terraform command not found**
A: 
1. Download from [terraform.io](https://terraform.io/downloads)
2. Extract and move to PATH:
```bash
# Linux/macOS
sudo mv terraform /usr/local/bin/

# Windows: Add to PATH environment variable
```

**Q: Provider authentication issues with GCP**
A: Set up authentication:
```bash
# Option 1: Service account key
export GOOGLE_APPLICATION_CREDENTIALS="path/to/key.json"

# Option 2: gcloud auth
gcloud auth application-default login
```

**Q: AWS provider authentication fails**
A: Configure AWS credentials:
```bash
# Using AWS CLI
aws configure

# Or set environment variables
export AWS_ACCESS_KEY_ID="your-key"
export AWS_SECRET_ACCESS_KEY="your-secret"
```

### Configuration Issues

**Q: "Provider not found" error**
A: Run `terraform init` to download providers:
```bash
terraform init
```

**Q: Version conflicts**
A: Pin provider versions in your configuration:
```hcl
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}
```

**Q: Resource already exists error**
A: Import existing resources:
```bash
terraform import google_storage_bucket.example bucket-name
```

### State Management

**Q: State file conflicts in team**
A: Use remote state backend:
```hcl
terraform {
  backend "gcs" {
    bucket = "my-terraform-state"
    prefix = "terraform/state"
  }
}
```

**Q: Lost state file**
A: 
- If using remote backend, state is safe
- If local file is lost, you may need to import resources manually
- Always backup state files!

**Q: State is out of sync**
A: Refresh state:
```bash
terraform refresh
```

### Planning & Applying

**Q: Plan shows unexpected changes**
A: Common causes:
- Resource drift (manual changes outside Terraform)
- Provider version changes
- Variable value changes

Check with:
```bash
terraform plan -detailed-diff
```

**Q: Apply fails partway through**
A: 
- Check state: `terraform show`
- Continue with: `terraform apply` (Terraform tracks what's done)
- For corrupted state, use `terraform import` to fix

**Q: Resource creation timeout**
A: Increase timeout:
```hcl
resource "google_compute_instance" "example" {
  # ... other configuration ...
  
  timeouts {
    create = "10m"
    delete = "10m"
  }
}
```

---

## 🔧 General Troubleshooting

### Environment Issues

**Q: Commands work locally but fail in CI/CD**
A: Common differences:
- Different operating system
- Missing environment variables
- Different versions of tools
- Insufficient permissions

**Q: Out of disk space**
A: Clean up Docker:
```bash
# Remove unused containers, networks, images
docker system prune -a

# Remove specific items
docker container prune
docker image prune
docker volume prune
```

### Networking

**Q: Can't access services on localhost**
A: 
- On Docker Desktop (Windows/macOS): Use `localhost`
- On Linux Docker: Use container IP or bridge network
- In containers: Use service names, not localhost

**Q: Port already in use**
A: Find and stop the process:
```bash
# Find process using port
lsof -i :8080  # macOS/Linux
netstat -ano | findstr :8080  # Windows

# Kill process
kill -9 <PID>  # macOS/Linux
taskkill /PID <PID> /F  # Windows
```

### Performance

**Q: Build/deployment is very slow**
A: Optimization tips:
- Use `.dockerignore` to exclude unnecessary files
- Leverage Docker layer caching
- Use multi-stage builds
- Optimize Dockerfile order (less frequently changing commands first)

**Q: High resource usage**
A: 
- Limit container resources:
```bash
docker run --memory="512m" --cpus="1.0" myapp
```
- Monitor usage:
```bash
docker stats
```

---

## 🆘 Getting Help

### Before Asking for Help

1. **Check the logs**:
   ```bash
   docker logs <container>
   terraform plan -detailed-diff
   ```

2. **Search existing issues**:
   - GitHub repositories
   - Stack Overflow
   - Official documentation

3. **Provide context**:
   - Operating system
   - Tool versions
   - Full error messages
   - Steps to reproduce

### Where to Get Help

- **DataTalks.Club Slack**: [Join here](https://datatalks.club/slack.html)
- **Course GitHub**: [Issues section](https://github.com/DataTalksClub/data-engineering-zoomcamp)
- **Stack Overflow**: Use tags `docker`, `terraform`, `google-cloud-platform`
- **Official Documentation**:
  - [Docker Docs](https://docs.docker.com/)
  - [Terraform Docs](https://terraform.io/docs)

---

**Still stuck?** Join our [Slack community](https://datatalks.club/slack.html) and ask in the `#data-engineering-zoomcamp` channel! 💬