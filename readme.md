# 🚀 Automated Infrastructure Deployment with Terraform, Ansible & GitHub Actions

This repository automates the provisioning and configuration of a web server on **AWS EC2** using **Terraform**, **Ansible**, **Docker**, and **GitHub Actions**.  
It creates an EC2 instance, installs Docker and Nginx, and deploys a simple static website inside a container.

---

## 📁 Project Structure

.
├── .github/
│ └── workflows/
│ └── deploy.yml # GitHub Actions CI/CD pipeline
├── Dockerfile # Nginx container setup
├── deploy.yml # Ansible playbook for server configuration
├── index.html # Static webpage
├── main.tf # Terraform configuration for AWS
├── id_rsa.pub # Public SSH key for EC2 key pair
└── README.md # Project documentation

markdown
Copy code

---

## 🧩 Components Overview

### **1. GitHub Actions Workflow**
Located at `.github/workflows/deploy.yml`, this file automates the deployment pipeline:
- **Triggers** on `push` or `pull_request` to the `main` branch.
- **Steps:**
  1. Checkout repository.
  2. Setup Terraform (v1.5.0).
  3. Configure AWS credentials using GitHub Secrets.
  4. Run Terraform:
     - `terraform init`
     - `terraform validate`
     - `terraform plan`
     - `terraform apply -auto-approve` (for pushes to main).

### **2. Terraform (main.tf)**
Defines the AWS infrastructure:
- **Security Group** allowing inbound SSH (22), HTTP (80), and HTTPS (443).
- **Key Pair** using your `id_rsa.pub`.
- **EC2 Instance** (Amazon Linux 2, `t3.micro`).
- Automatically runs the Ansible playbook after instance creation.

### **3. Ansible (deploy.yml)**
Configures the EC2 instance to host the website:
- Installs **Python 3.8**, **Docker**, and **Docker Compose**.
- Adds `ec2-user` to the Docker group.
- Installs and configures **Nginx** as a reverse proxy.
- Copies static website files to `/home/ec2-user/webpage/`.
- Runs Docker Compose to deploy the Nginx container serving your site.

### **4. Docker (Dockerfile)**
Defines a lightweight **Nginx** image that serves your `index.html` page.

---

## ⚙️ How It Works

1. Developer pushes code to the `main` branch.  
2. GitHub Actions triggers the workflow.  
3. Terraform initializes and applies infrastructure changes.  
4. Terraform executes Ansible locally to configure the new EC2 instance.  
5. Docker container runs Nginx serving the website.  

---

## 🔐 AWS Setup

Before deploying, configure the following GitHub Secrets under  
**Settings → Secrets and variables → Actions**:

| Secret Name | Description |
|--------------|-------------|
| `AWS_ACCESS_KEY_ID` | Your AWS access key |
| `AWS_SECRET_ACCESS_KEY` | Your AWS secret access key |

Make sure your AWS user has permissions for EC2, VPC, and IAM key pair operations.

---

## 🧰 Prerequisites

If you plan to test locally before pushing:

- [Terraform](https://developer.hashicorp.com/terraform/downloads)
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_install.html)
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- A valid `id_rsa.pub` key in the project directory.

---

## ▶️ Manual Deployment (Optional)

You can also deploy manually without GitHub Actions:

```bash
# Initialize Terraform
terraform init

# Validate configuration
terraform validate

# See the plan
terraform plan

# Apply infrastructure
terraform apply -auto-approve
🌐 Output
Once applied successfully, Terraform will output:

bash
Copy code
instance_public_ip = "xx.xx.xx.xx"
You can visit your website at:

cpp
Copy code
http://<instance_public_ip>
🧹 Cleanup
To destroy all created resources and avoid charges:

bash
Copy code
terraform destroy -auto-approve
🏁 Summary
Tool	Purpose
Terraform	Provision AWS infrastructure
Ansible	Configure EC2 instance
Docker + Nginx	Serve the static website
GitHub Actions	Automate CI/CD pipeline

Author: Luqman Muhammad
Region: us-west-2
Instance Type: t3.micro
AMI: ami-0c5204531f799e0c6

