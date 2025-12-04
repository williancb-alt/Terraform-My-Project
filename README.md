Terraform Multi-AZ Web Application (CA2 Lab IaC)
Infrastructure as Code deployment of a highly available web application across 2 Availability Zones with Application Load Balancer.

🎯 Architecture Overview
<img width="2785" height="1040" alt="Overview" src="https://github.com/user-attachments/assets/d7abca40-3d9c-4ee1-a315-5bf60995d398" />

Key Components:
- VPC: Multi-AZ with public/private subnets
- ALB: Application Load Balancer with health checks
- EC2: Auto-scaled web servers (Amazon Linux 2023)
- Security Groups: Least privilege rules

📁 Project Structure

<img width="917" height="215" alt="image" src="https://github.com/user-attachments/assets/38762a70-00e2-4509-956c-ccaf2a909e9d" />

🚀 Quick Start
 Clone & Initialize
- git clone https://github.com/williancb-alt/Terraform-My-Project.git
- cd Terraform-My-Project

 🔧 Configure AWS credentials
- AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_DEFAULT_REGION=us-east-1

 🔧 Terraform Lifecycle
- terraform init
- terraform validate
- terraform plan
- terraform apply

🔧 Prerequisites
- AWS Account with IAM user (AdministratorAccess policy)
- Terraform >= 1.5.0
- AWS CLI configured
- Git for version control

📊 Outputs
After terraform apply:
ALB DNS: http://multi-az-alb-1234567890.us-east-1.elb.amazonaws.com
VPC ID: vpc-0abcdef1234567890
EC2 Instances: i-0abcdef1234567890, i-0fedcba9876543210

📈 High Availability Features
- Multi-AZ (us-east-1a, us-east-1b)
- Load Balancing (Cross-zone enabled)
- Health Checks (200-299 status codes)
- Scaling Ready (Target Group integration)
- Private Subnets for EC2 (secure)

📚 Learning Outcomes (CA2 Lab)
- Modular IaC: Reusable VPC/ALB/EC2/Security modules
- Multi-AZ Architecture: Production-grade HA
- Load Balancing: ALB with target groups & health checks
- GitOps Workflow: Clean repo (no .terraform/ binaries)
- Terraform Best Practices: Variables, outputs, .gitignore
