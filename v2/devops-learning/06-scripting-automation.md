# Materi Pembelajaran: Bash & Python Scripting for DevOps

> **Level**: Beginner to Intermediate  
> **Durasi**: 4-5 jam  
> **Prerequisites**: Linux basics

---

## 📚 Daftar Isi

1. [Bash Scripting Fundamentals](#bash-fundamentals)
2. [Advanced Bash](#advanced-bash)
3. [Python for DevOps](#python-devops)
4. [Automation Examples](#automation-examples)
5. [Best Practices](#best-practices)
6. [Hands-On Projects](#projects)

---

## 1. Bash Scripting Fundamentals

### Your First Script

```bash
#!/bin/bash
# Shebang - tells OS to use bash

echo "Hello DevOps!"
```

```bash
# Make executable
chmod +x script.sh

# Run
./script.sh
```

### Variables

```bash
#!/bin/bash

# Define variables
NAME="DevOps"
COUNT=5

# Use variables
echo "Hello $NAME"
echo "Count: $COUNT"

# Read user input
read -p "Enter your name: " USERNAME
echo "Welcome, $USERNAME!"
```

### Conditionals

```bash
#!/bin/bash

if [ "$1" == "start" ]; then
    echo "Starting service..."
elif [ "$1" == "stop" ]; then
    echo "Stopping service..."
else
    echo "Usage: $0 {start|stop}"
    exit 1
fi
```

### Loops

```bash
#!/bin/bash

# For loop
for i in {1..5}; do
    echo "Number: $i"
done

# While loop
COUNT=0
while [ $COUNT -lt 5 ]; do
    echo "Count: $COUNT"
    ((COUNT++))
done

# Loop through files
for file in *.txt; do
    echo "Processing: $file"
done
```

### Functions

```bash
#!/bin/bash

# Define function
deploy_app() {
    local APP_NAME=$1
    local VERSION=$2
    
    echo "Deploying $APP_NAME version $VERSION..."
    # Deployment logic here
}

# Call function
deploy_app "myapp" "v1.0"
```

---

## 2. Advanced Bash

### Error Handling

```bash
#!/bin/bash
set -euo pipefail  # Exit on error, undefined vars, pipe fails

# Trap errors
trap 'echo "Error on line $LINENO"' ERR

# Check command success
if docker ps &>/dev/null; then
    echo "Docker is running"
else
    echo "Docker is not running"
    exit 1
fi
```

### File Operations

```bash
#!/bin/bash

# Check if file exists
if [ -f "config.txt" ]; then
    echo "File exists"
fi

# Read file line by line
while IFS= read -r line; do
    echo "Line: $line"
done < "input.txt"

# Write to file
echo "New log entry" >> logs.txt
```

### Command Substitution

```bash
#!/bin/bash

# Store command output
CURRENT_DATE=$(date +%Y-%m-%d)
DISK_USAGE=$(df -h / | tail -1 | awk '{print $5}')

echo "Date: $CURRENT_DATE"
echo "Disk usage: $DISK_USAGE"
```

### Arrays

```bash
#!/bin/bash

# Define array
SERVERS=("web1" "web2" "web3")

# Loop through array
for server in "${SERVERS[@]}"; do
    echo "Checking $server..."
    ping -c 1 $server &>/dev/null && echo "✓ UP" || echo "✗ DOWN"
done
```

### Practical Script: Backup Automation

```bash
#!/bin/bash
set -euo pipefail

# Configuration
BACKUP_DIR="/backup"
SOURCE_DIR="/var/www"
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="backup_${DATE}.tar.gz"
RETENTION_DAYS=7

# Create backup
echo "Creating backup..."
tar -czf "${BACKUP_DIR}/${BACKUP_FILE}" "${SOURCE_DIR}"

if [ $? -eq 0 ]; then
    echo "✓ Backup created: ${BACKUP_FILE}"
else
    echo "✗ Backup failed!"
    exit 1
fi

# Remove old backups
echo "Removing backups older than ${RETENTION_DAYS} days..."
find "${BACKUP_DIR}" -name "backup_*.tar.gz" -mtime +${RETENTION_DAYS} -delete

echo "Backup complete!"
```

---

## 3. Python for DevOps

### Why Python?

- Rich libraries for DevOps (boto3, paramiko, requests)
- Better for complex logic
- Cross-platform
- Easy to read and maintain

### Basic Python Script

```python
#!/usr/bin/env python3

import sys
import os
from datetime import datetime

def main():
    print("Hello DevOps!")
    print(f"Current time: {datetime.now()}")
    print(f"Python version: {sys.version}")

if __name__ == "__main__":
    main()
```

### File Operations

```python
#!/usr/bin/env python3

import os
import shutil
from pathlib import Path

# Read file
with open('config.txt', 'r') as f:
    content = f.read()
    print(content)

# Write file
with open('output.txt', 'w') as f:
    f.write('Log entry\n')

# Copy file
shutil.copy('source.txt', 'dest.txt')

# List files
for file in Path('.').glob('*.txt'):
    print(f"Found: {file}")
```

### Running Commands

```python
#!/usr/bin/env python3

import subprocess

# Run command
result = subprocess.run(['ls', '-la'], 
                       capture_output=True, 
                       text=True)

print(f"Return code: {result.returncode}")
print(f"Output:\n{result.stdout}")

# Check if Docker is running
try:
    subprocess.run(['docker', 'ps'], 
                  check=True, 
                  capture_output=True)
    print("✓ Docker is running")
except subprocess.CalledProcessError:
    print("✗ Docker is not running")
```

### Working with APIs

```python
#!/usr/bin/env python3

import requests
import json

# GET request
response = requests.get('https://api.github.com/users/github')
user = response.json()
print(f"GitHub followers: {user['followers']}")

# POST request
data = {'key': 'value'}
response = requests.post('https://api.example.com/endpoint', 
                        json=data)

# With auth
headers = {'Authorization': 'Bearer token'}
response = requests.get('https://api.example.com/data', 
                       headers=headers)
```

### AWS Boto3 Example

```python
#!/usr/bin/env python3

import boto3

# List EC2 instances
ec2 = boto3.client('ec2')
response = ec2.describe_instances()

for reservation in response['Reservations']:
    for instance in reservation['Instances']:
        print(f"Instance: {instance['InstanceId']}")
        print(f"State: {instance['State']['Name']}")
        print(f"Type: {instance['InstanceType']}")
        print("---")
```

---

## 4. Automation Examples

### System Health Check (Bash)

```bash
#!/bin/bash

echo "=== System Health Check ==="
echo

# CPU Usage
echo "CPU Usage:"
top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1

# Memory Usage
echo "Memory Usage:"
free -h | awk '/^Mem:/ {print $3 "/" $2}'

# Disk Usage
echo "Disk Usage:"
df -h / | tail -1 | awk '{print $5}'

# Check critical services
SERVICES=("docker" "nginx" "postgresql")
echo
echo "Service Status:"
for service in "${SERVICES[@]}"; do
    systemctl is-active --quiet $service && \
        echo "✓ $service is running" || \
        echo "✗ $service is not running"
done
```

### Docker Cleanup (Python)

```python
#!/usr/bin/env python3

import docker
from datetime import datetime, timedelta

client = docker.from_env()

# Remove stopped containers older than 7 days
cutoff = datetime.now() - timedelta(days=7)

for container in client.containers.list(all=True):
    if container.status == 'exited':
        created = datetime.fromisoformat(
            container.attrs['Created'].rstrip('Z')
        )
        if created < cutoff:
            print(f"Removing: {container.name}")
            container.remove()

# Remove unused images
client.images.prune()

print("Cleanup complete!")
```

### Log Analyzer (Python)

```python
#!/usr/bin/env python3

import re
from collections import Counter

def analyze_logs(log_file):
    error_pattern = r'ERROR|FATAL'
    ip_pattern = r'\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}'
    
    errors = []
    ips = []
    
    with open(log_file, 'r') as f:
        for line in f:
            if re.search(error_pattern, line):
                errors.append(line.strip())
            
            ip_match = re.search(ip_pattern, line)
            if ip_match:
                ips.append(ip_match.group())
    
    print(f"Total errors: {len(errors)}")
    print("\nRecent errors:")
    for error in errors[-5:]:
        print(f"  {error}")
    
    print("\nTop 5 IPs:")
    for ip, count in Counter(ips).most_common(5):
        print(f"  {ip}: {count} requests")

if __name__ == "__main__":
    analyze_logs('/var/log/nginx/access.log')
```

---

## 5. Best Practices

### Bash Best Practices

```bash
#!/bin/bash

# 1. Use strict mode
set -euo pipefail

# 2. Use meaningful variable names
DEPLOYMENT_DIR="/var/www/app"  # Good
DIR="/var/www/app"              # Bad

# 3. Quote variables
echo "${USER_INPUT}"  # Prevents word splitting

# 4. Check if commands exist
if ! command -v docker &>/dev/null; then
    echo "Docker not found"
    exit 1
fi

# 5. Use functions for reusability
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"
}

log "Starting deployment..."

# 6. Add help message
if [ $# -eq 0 ]; then
    cat <<EOF
Usage: $0 <environment>
Environments: dev, staging, prod
EOF
    exit 1
fi
```

### Python Best Practices

```python
#!/usr/bin/env python3
"""
Module docstring explaining purpose
"""

import logging
import argparse

# Setup logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

def deploy(environment: str) -> bool:
    """
    Deploy application to specified environment
    
    Args:
        environment: Target environment (dev/staging/prod)
    
    Returns:
        bool: True if successful, False otherwise
    """
    try:
        logger.info(f"Deploying to {environment}")
        # Deployment logic
        return True
    except Exception as e:
        logger.error(f"Deployment failed: {e}")
        return False

def main():
    parser = argparse.ArgumentParser(
        description='Deploy application'
    )
    parser.add_argument(
        'environment',
        choices=['dev', 'staging', 'prod'],
        help='Target environment'
    )
    
    args = parser.parse_args()
    success = deploy(args.environment)
    
    return 0 if success else 1

if __name__ == "__main__":
    exit(main())
```

---

## 6. Hands-On Projects

### Project 1: Server Monitoring Script

```bash
#!/bin/bash
# monitor.sh - Monitor server resources

ALERT_THRESHOLD_CPU=80
ALERT_THRESHOLD_MEM=80
ALERT_THRESHOLD_DISK=85

check_cpu() {
    CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1 | cut -d'.' -f1)
    if [ $CPU -gt $ALERT_THRESHOLD_CPU ]; then
        echo "⚠️  CPU: ${CPU}% (threshold: ${ALERT_THRESHOLD_CPU}%)"
    else
        echo "✓ CPU: ${CPU}%"
    fi
}

check_memory() {
    MEM=$(free | grep Mem | awk '{print ($3/$2) * 100.0}' | cut -d'.' -f1)
    if [ $MEM -gt $ALERT_THRESHOLD_MEM ]; then
        echo "⚠️  Memory: ${MEM}% (threshold: ${ALERT_THRESHOLD_MEM}%)"
    else
        echo "✓ Memory: ${MEM}%"
    fi
}

check_disk() {
    DISK=$(df -h / | tail -1 | awk '{print $5}' | cut -d'%' -f1)
    if [ $DISK -gt $ALERT_THRESHOLD_DISK ]; then
        echo "⚠️  Disk: ${DISK}% (threshold: ${ALERT_THRESHOLD_DISK}%)"
    else
        echo "✓ Disk: ${DISK}%"
    fi
}

echo "=== Server Monitoring Report ==="
echo "Time: $(date)"
echo
check_cpu
check_memory
check_disk
```

### Project 2: Deployment Automation (Python)

```python
#!/usr/bin/env python3
"""
deploy.py - Automated deployment script
"""

import subprocess
import sys
import logging
from pathlib import Path

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

class Deployer:
    def __init__(self, environment):
        self.environment = environment
        self.app_dir = Path('/var/www/app')
    
    def pull_code(self):
        """Pull latest code from git"""
        logger.info("Pulling latest code...")
        subprocess.run(
            ['git', 'pull', 'origin', 'main'],
            cwd=self.app_dir,
            check=True
        )
    
    def install_dependencies(self):
        """Install dependencies"""
        logger.info("Installing dependencies...")
        subprocess.run(
            ['npm', 'ci'],
            cwd=self.app_dir,
            check=True
        )
    
    def build(self):
        """Build application"""
        logger.info("Building application...")
        subprocess.run(
            ['npm', 'run', 'build'],
            cwd=self.app_dir,
            check=True
        )
    
    def restart_service(self):
        """Restart application service"""
        logger.info("Restarting service...")
        subprocess.run(
            ['systemctl', 'restart', 'myapp'],
            check=True
        )
    
    def health_check(self):
        """Check if application is healthy"""
        import requests
        logger.info("Running health check...")
        
        try:
            response = requests.get('http://localhost:3000/health')
            if response.status_code == 200:
                logger.info("✓ Health check passed")
                return True
        except Exception as e:
            logger.error(f"✗ Health check failed: {e}")
            return False
    
    def deploy(self):
        """Run full deployment"""
        try:
            self.pull_code()
            self.install_dependencies()
            self.build()
            self.restart_service()
            
            if self.health_check():
                logger.info("🎉 Deployment successful!")
                return True
            else:
                logger.error("❌ Deployment failed health check")
                return False
                
        except Exception as e:
            logger.error(f"❌ Deployment failed: {e}")
            return False

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: deploy.py <environment>")
        sys.exit(1)
    
    deployer = Deployer(sys.argv[1])
    success = deployer.deploy()
    sys.exit(0 if success else 1)
```

---

## 📝 Cheat Sheet

### Common Bash Commands
```bash
# String comparison
[ "$a" == "$b" ]

# Numeric comparison
[ $a -eq $b ]
[ $a -gt $b ]  # greater than
[ $a -lt $b ]  # less than

# File tests
[ -f file ]    # file exists
[ -d dir ]     # directory exists
[ -x file ]    # file is executable

# Logical operators
[ $a -eq 1 ] && [ $b -eq 2 ]  # AND
[ $a -eq 1 ] || [ $b -eq 2 ]  # OR
```

### Useful Python Libraries
```python
# System operations
import os, sys, subprocess, shutil

# File operations
from pathlib import Path
import glob

# HTTP requests
import requests

# JSON/YAML
import json
import yaml

# AWS
import boto3

# Docker
import docker

# Logging
import logging
```

---

## 🎯 Next Steps

1. **Practice**: Automate daily tasks
2. **Learn**: Advanced Python (async, decorators)
3. **Explore**: More libraries (Ansible, Terraform SDKs)
4. **Build**: Complete automation solutions

---

**Selamat! Scripting skills acquired! 🐍🔧**
