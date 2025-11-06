# 🚀 Automated Infrastructure Deployment

> Automated provisioning and configuration of AWS EC2 infrastructure using Terraform, Ansible, Docker, and GitHub Actions

[![Terraform](https://img.shields.io/badge/Terraform-1.5.0-623CE4?logo=terraform&logoColor=white)](https://www.terraform.io/)
[![Ansible](https://img.shields.io/badge/Ansible-Latest-EE0000?logo=ansible&logoColor=white)](https://www.ansible.com/)
[![Docker](https://img.shields.io/badge/Docker-Latest-2496ED?logo=docker&logoColor=white)](https://www.docker.com/)
[![AWS](https://img.shields.io/badge/AWS-EC2-FF9900?logo=amazon-aws&logoColor=white)](https://aws.amazon.com/)

---

## 📋 Table of Contents

- [Overview](#-overview)
- [Architecture](#-architecture)
- [Project Structure](#-project-structure)
- [Components](#-components)
- [Prerequisites](#-prerequisites)
- [Setup](#-setup)
- [Deployment](#-deployment)
- [Cleanup](#-cleanup)
- [Configuration](#-configuration)

---

## 🎯 Overview

This project demonstrates a complete **Infrastructure as Code (IaC)** solution that automatically:

- ✅ Provisions AWS EC2 infrastructure using **Terraform**
- ✅ Configures servers with **Ansible** automation
- ✅ Deploys a containerized **Nginx** web server
- ✅ Implements **CI/CD** pipeline with GitHub Actions
- ✅ Serves a static website with zero-downtime deployment

---

## 🏗 Architecture

```
┌─────────────────┐
│  GitHub Push    │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ GitHub Actions  │
└────────┬────────┘
         │
         ▼
┌─────────────────┐      ┌──────────────────┐
│   Terraform     │─────▶│   AWS EC2        │
└────────┬────────┘      └────────┬─────────┘
         │                        │
         ▼                        │
┌─────────────────┐              │
│    Ansible      │──────────────┘
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Docker + Nginx  │
└─────────────────┘
```

---

## 📁 Project Structure

```
.
├── .github/
│   └── workflows/
│       └── deploy.yml          # CI/CD pipeline configuration
├── Dockerfile                   # Nginx container definition
├── deploy.yml                   # Ansible playbook
├── index.html                   # Static website content
├── main.tf                      # Terraform infrastructure code
├── id_rsa.pub                   # SSH public key
└── README.md                    # This file
```

---

## 🧩 Components

### 1️⃣ GitHub Actions Workflow

**Location:** `.github/workflows/deploy.yml`

Automates the entire deployment pipeline:

- **Trigger:** Push or PR to `main` branch
- **Actions:**
  - 🔍 Code checkout
  - ⚙️ Terraform setup (v1.5.0)
  - 🔐 AWS credentials configuration
  - 🚀 Infrastructure deployment (`init` → `validate` → `plan` → `apply`)

### 2️⃣ Terraform Infrastructure

**Location:** `main.tf`

Defines AWS resources:

| Resource | Description |
|----------|-------------|
| **Security Group** | Allows SSH (22), HTTP (80), HTTPS (443) |
| **Key Pair** | SSH access using `id_rsa.pub` |
| **EC2 Instance** | Amazon Linux 2, `t3.micro`, `us-west-2` |
| **Provisioner** | Triggers Ansible configuration post-creation |

### 3️⃣ Ansible Configuration

**Location:** `deploy.yml`

Server configuration tasks:

- 🐍 Installs Python 3.8
- 🐳 Installs Docker & Docker Compose
- 👤 Configures `ec2-user` permissions
- 🌐 Deploys Nginx reverse proxy
- 📦 Copies website files
- ▶️ Starts Docker containers

### 4️⃣ Docker Container

**Location:** `Dockerfile`

Lightweight Nginx image serving your static website.

---

## 🛠 Prerequisites

### Required Tools

- [Terraform](https://developer.hashicorp.com/terraform/downloads) (v1.5.0+)
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_install.html) (Latest)
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) (Configured)
- SSH Key Pair (`id_rsa.pub`)

### AWS Requirements

- Valid AWS account
- IAM user with permissions:
  - EC2 (full access)
  - VPC (read/write)
  - Key Pair management

---

## ⚙️ Setup

### 1. Configure GitHub Secrets

Navigate to **Settings** → **Secrets and variables** → **Actions** and add:

| Secret Name | Value |
|-------------|-------|
| `AWS_ACCESS_KEY_ID` | Your AWS access key |
| `AWS_SECRET_ACCESS_KEY` | Your AWS secret key |

### 2. Configure SSH Key

Ensure `id_rsa.pub` is in the project root:

```bash
# Generate new key if needed
ssh-keygen -t rsa -b 4096 -f id_rsa
```

### 3. Update Configuration

Edit `main.tf` to customize:
- AWS region (default: `us-west-2`)
- Instance type (default: `t3.micro`)
- AMI ID (default: `ami-0c5204531f799e0c6`)

---

## 🚀 Deployment

### Automated (GitHub Actions)

Simply push to the `main` branch:

```bash
git add .
git commit -m "Deploy infrastructure"
git push origin main
```

The GitHub Actions workflow will automatically:
1. Validate your Terraform code
2. Provision AWS infrastructure
3. Configure the server
4. Deploy your website

### Manual Deployment

For local testing:

```bash
# Initialize Terraform
terraform init

# Preview changes
terraform plan

# Apply infrastructure
terraform apply -auto-approve
```

---

## 🌐 Accessing Your Website

After successful deployment, Terraform outputs the instance IP:

```
Outputs:
instance_public_ip = "54.123.45.67"
```

Visit your website at:
```
http://54.123.45.67
```

⏱ **Note:** Allow 2-3 minutes for the Ansible playbook to complete server configuration.

---

## 🧹 Cleanup

To destroy all resources and stop AWS charges:

```bash
terraform destroy -auto-approve
```

> ⚠️ **Warning:** This action is irreversible and will delete all created infrastructure.

---

## 📊 Configuration

### Default Settings

| Parameter | Value |
|-----------|-------|
| **Region** | us-west-2 |
| **Instance Type** | t3.micro |
| **AMI** | ami-0c5204531f799e0c6 (Amazon Linux 2) |
| **Web Server** | Nginx (containerized) |
| **Automation** | GitHub Actions |

### Customization

To modify instance settings, edit `main.tf`:

```hcl
resource "aws_instance" "web" {
  instance_type = "t3.small"  # Change instance size
  # ... other settings
}
```

---

## 🤝 Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## 📝 License

This project is open source and available under the [MIT License](LICENSE).

---

## 👤 Author

**Luqman Muhammad**

- GitHub: [@yourusername](https://github.com/yourusername)
- LinkedIn: [Your Profile](https://linkedin.com/in/yourprofile)

---

## 🙏 Acknowledgments

- [Terraform Documentation](https://www.terraform.io/docs)
- [Ansible Documentation](https://docs.ansible.com/)
- [AWS Documentation](https://docs.aws.amazon.com/)
- [Docker Documentation](https://docs.docker.com/)

---

<div align="center">

**⭐ Star this repository if you find it helpful!**

Made with ❤️ by Luqman Muhammad

</div>