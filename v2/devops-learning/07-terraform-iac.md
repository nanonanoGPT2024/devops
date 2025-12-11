# Materi Pembelajaran: Terraform - Infrastructure as Code

> **Level**: Intermediate  
> **Durasi**: 5-6 jam  
> **Prerequisites**: Cloud basics, Linux

---

## 📚 Daftar Isi

1. [Infrastructure as Code](#iac-intro)
2. [Terraform Fundamentals](#terraform-fundamentals)
3. [Terraform Configuration](#configuration)
4. [State Management](#state-management)
5. [Modules](#modules)
6. [Best Practices](#best-practices)
7. [Real-World Examples](#examples)

---

## 1. Infrastructure as Code

### Why IaC?

**Traditional**: Manual infrastructure setup via console  
**IaC**: Define infrastructure in code files

**Benefits**:
- ✅ Version control for infrastructure
- ✅ Reproducible environments
- ✅ Documentation as code
- ✅ Easy rollback
- ✅ Collaboration

### Terraform vs Others

| Tool | Type | Use Case |
|------|------|----------|
| Terraform | Declarative | Multi-cloud provisioning |
| CloudFormation | Declarative | AWS only |
| Ansible | Procedural | Configuration management |
| Pulumi | Imperative | Code-based IaC |

---

## 2. Terraform Fundamentals

### Installation

```bash
# Linux
wget https://releases.hashicorp.com/terraform/1.6.0/terraform_1.6.0_linux_amd64.zip
unzip terraform_1.6.0_linux_amd64.zip
sudo mv terraform /usr/local/bin/

# Verify
terraform version
```

### Basic Workflow

```
1. Write    → .tf files
2. Init     → terraform init
3. Plan     → terraform plan
4. Apply    → terraform apply
5. Destroy  → terraform destroy
```

### First Terraform File

```hcl
# main.tf
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  
  tags = {
    Name = "HelloTerraform"
  }
}
```

```bash
# Initialize
terraform init

# Preview changes
terraform plan

# Apply changes
terraform apply

# Destroy resources
terraform destroy
```

---

## 3. Terraform Configuration

### Variables

```hcl
# variables.tf
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "environment" {
  description = "Environment name"
  type        = string
}

# main.tf
resource "aws_instance" "web" {
  instance_type = var.instance_type
  
  tags = {
    Environment = var.environment
  }
}
```

Set variables:
```bash
# Via command line
terraform apply -var="environment=prod"

# Via file
# terraform.tfvars
environment = "production"
instance_type = "t2.small"
```

### Outputs

```hcl
# outputs.tf
output "instance_public_ip" {
  description = "Public IP of EC2 instance"
  value       = aws_instance.web.public_ip
}

output "instance_id" {
  value = aws_instance.web.id
}
```

```bash
# View outputs
terraform output
terraform output instance_public_ip
```

### Data Sources

```hcl
# Get latest Ubuntu AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]  # Canonical
  
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

resource "aws_instance" "web" {
  ami = data.aws_ami.ubuntu.id
}
```

---

## 4. State Management

### What is State?

**terraform.tfstate** = Mapping between config and real resources

### Remote Backend (S3)

```hcl
# backend.tf
terraform {
  backend "s3" {
    bucket         = "my-terraform-state"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
```

### Workspaces

```bash
# Create workspace
terraform workspace new dev
terraform workspace new staging
terraform workspace new prod

# List workspaces
terraform workspace list

# Switch workspace
terraform workspace select prod

# Show current
terraform workspace show
```

---

## 5. Modules

### Create Module

```
modules/
  vpc/
    main.tf
    variables.tf
    outputs.tf
```

```hcl
# modules/vpc/main.tf
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)
  
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet_cidrs[count.index]
  
  tags = {
    Name = "${var.vpc_name}-public-${count.index + 1}"
  }
}

# modules/vpc/variables.tf
variable "vpc_cidr" {
  type = string
}

variable "vpc_name" {
  type = string
}

variable "public_subnet_cidrs" {
  type = list(string)
}

# modules/vpc/outputs.tf
output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}
```

### Use Module

```hcl
# main.tf
module "vpc" {
  source = "./modules/vpc"
  
  vpc_cidr             = "10.0.0.0/16"
  vpc_name             = "production-vpc"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
}

# Use module outputs
resource "aws_instance" "web" {
  subnet_id = module.vpc.public_subnet_ids[0]
}
```

---

## 6. Best Practices

### File Structure

```
project/
├── main.tf           # Main resources
├── variables.tf      # Input variables
├── outputs.tf        # Output values
├── backend.tf        # Backend configuration
├── versions.tf       # Provider versions
├── terraform.tfvars  # Variable values
└── modules/          # Reusable modules
    └── vpc/
```

### Naming Conventions

```hcl
# Use descriptive names
resource "aws_instance" "web_server" {}  # ✅ Good
resource "aws_instance" "server1" {}     # ❌ Bad

# Use tags
tags = {
  Name        = "web-server"
  Environment = var.environment
  ManagedBy   = "Terraform"
}
```

### Security

```hcl
# Never hardcode secrets
# ❌ BAD
variable "db_password" {
  default = "mypassword123"
}

# ✅ GOOD - Use AWS Secrets Manager
data "aws_secretsmanager_secret_version" "db_password" {
  secret_id = "prod/db/password"
}
```

---

## 7. Real-World Examples

### Complete AWS VPC + EC2

```hcl
# vpc.tf
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  
  tags = {
    Name = "${var.project}-vpc"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.${count.index + 1}.0/24"
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  
  tags = {
    Name = "${var.project}-public-${count.index + 1}"
  }
}

# ec2.tf
resource "aws_security_group" "web" {
  name_prefix = "${var.project}-web-"
  vpc_id      = aws_vpc.main.id
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web" {
  count         = var.instance_count
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public[count.index % 2].id
  
  vpc_security_group_ids = [aws_security_group.web.id]
  
  user_data = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y nginx
              systemctl start nginx
              EOF
  
  tags = {
    Name = "${var.project}-web-${count.index + 1}"
  }
}

# variables.tf
variable "project" {
  default = "myapp"
}

variable "instance_count" {
  default = 2
}

variable "instance_type" {
  default = "t2.micro"
}

# outputs.tf
output "instance_ips" {
  value = aws_instance.web[*].public_ip
}
```

---

## 📝 Terraform Commands

```bash
# Initialize
terraform init

# Format code
terraform fmt

# Validate configuration
terraform validate

# Plan changes
terraform plan
terraform plan -out=tfplan

# Apply changes
terraform apply
terraform apply tfplan
terraform apply -auto-approve

# Destroy resources
terraform destroy
terraform destroy -target=aws_instance.web

# Show current state
terraform show

# List resources
terraform state list

# Import existing resource
terraform import aws_instance.web i-1234567890abcdef0

# Taint resource (force recreate)
terraform taint aws_instance.web

# Refresh state
terraform refresh
```

---

## 🎯 Next Steps

1. **Practice**: Build infrastructure on AWS/GCP
2. **Learn**: Terraform Cloud for collaboration
3. **Explore**: Advanced features (provisioners, depends_on)
4. **Certify**: HashiCorp Certified Terraform Associate

---

**Infrastructure as Code mastered! 🏗️**
