
# AWS AMI Creation using Packer

This project demonstrates how to create a custom Amazon Machine Image (AMI) using HashiCorp Packer and Amazon EC2.

The AMI is configured with required DevOps tools and services, including Docker and Node Exporter. The project is designed as a practical hands-on exercise for learning Packer, AWS, Linux, Docker, and infrastructure automation.

```
📁 Project Structure
AMI-PACKER/
│
├── packer.json
├── vars.json
├── docker.service
├── node_exporter.service
├── image.png
└── README.md
```

### Technologies Used
HashiCorp Packer
Amazon Web Services (AWS)
Amazon EC2
Linux
Docker
Node Exporter
systemd
PowerShell
SSH

### What This Project Does

The Packer configuration automates the creation of an AWS AMI.

The process includes:

Launching a temporary EC2 instance.
Using the configured AWS region and AMI settings.
Connecting to the instance using SSH.
Installing and configuring required packages.
Configuring Docker using docker.service.
Configuring Node Exporter using node_exporter.service.
Copying the required configuration files.
Creating a reusable custom AMI.
Terminating the temporary build instance after the AMI is created.

### ⚙️ Prerequisites

Before starting, make sure the following are installed and configured:

AWS account
AWS IAM user/role with permissions to create EC2 instances and AMIs
Packer
PowerShell
SSH client
An existing AWS key pair or SSH public key

Verify Packer:

```bash
packer version
```

Verify AWS CLI, if installed:

```bash
aws --version
```

## Step 1 — Configure SSH Public Key

Open:

packer.json


Find the SSH public key configuration and replace it with your own public key.

You can check an existing public key with:

Get-Content ~/.ssh/id_rsa.pub


Or, if you use an Ed25519 key:

Get-Content ~/.ssh/id_ed25519.pub


If you don't already have an SSH key, create one:

```bash
ssh-keygen -t ed25519


The generated public key will normally be located at:

~/.ssh/id_ed25519.pub
```

Never commit your private SSH key to GitHub.

## Step 2 — Configure vars.json

Update vars.json according to your AWS environment.

Typical variables may include:
```
{
  "aws_region": "us-east-1",
  "instance_type": "t2.micro"
}
```

Use the actual variables required by your packer.json.

Make sure the AWS region, source AMI, instance type, subnet/VPC configuration, and other required values match your environment.

## Step 3 — Configure AWS Credentials

Do not hard-code AWS access keys or secret keys inside packer.json or vars.json.

Instead, configure them as environment variables in PowerShell:

```bash
$Env:AWS_ACCESS_KEY_ID="YOUR_ACCESS_KEY"
$Env:AWS_SECRET_ACCESS_KEY="YOUR_SECRET_KEY"
$Env:AWS_DEFAULT_REGION="us-east-1"
```

You can verify that the variables are set:
```bash
$Env:AWS_ACCESS_KEY_ID
$Env:AWS_DEFAULT_REGION
```

Never commit AWS credentials, secret keys, .pem files, or other sensitive information to GitHub.

## Step 4 — Validate the Packer Configuration

Run:
```bash
packer validate --var-file=vars.json packer.json
```

Expected result:

The configuration is valid.


If you receive an error such as:

Bad source 'docker.service'


make sure docker.service exists in the same directory as packer.json or update the source path in packer.json.

## Step 5 — Inspect the Configuration

Use:
```bash
packer inspect --var-file=vars.json packer.json
```

This helps review the variables and build configuration before starting the AMI creation process.

## Step 6 — Build the AMI

Start the build:

```bash
packer build --var-file=vars.json packer.json
```

Packer will create a temporary EC2 instance, provision it, configure the required services, and create the final AMI.

After a successful build, Packer will display the generated AMI ID.

Example:

amazon-ebs: AMI: ami-xxxxxxxxxxxxxxxxx


Save the AMI ID for future deployments.

🐳 Docker Configuration

The project includes:

docker.service


This file provides a systemd configuration for Docker.

If Docker is configured to listen on TCP port 2375, be extremely careful with network access.

Do not expose an unauthenticated Docker API to the public internet.

Prefer SSH or TLS-secured Docker access for remote administration.

📊 Node Exporter

The project also includes:

node_exporter.service


Node Exporter can be used to expose Linux system metrics for monitoring with tools such as Prometheus.

The service can be managed with:

sudo systemctl daemon-reload
sudo systemctl enable node_exporter
sudo systemctl start node_exporter


Check the service:

sudo systemctl status node_exporter
```
🔄 Complete Workflow
        ┌──────────────────┐
        │   Packer Config  │
        │   packer.json    │
        │   vars.json      │
        └────────┬─────────┘
                 │
                 ▼
        ┌──────────────────┐
        │  Packer Validate │
        └────────┬─────────┘
                 │
                 ▼
        ┌──────────────────┐
        │ Temporary EC2    │
        │ Instance Created │
        └────────┬─────────┘
                 │
                 ▼
        ┌──────────────────┐
        │    Provision     │
        │ Docker + Tools   │
        └────────┬─────────┘
                 │
                 ▼
        ┌──────────────────┐
        │   Create AMI     │
        └────────┬─────────┘
                 │
                 ▼
        ┌──────────────────┐
        │ Reusable AWS AMI │
        └──────────────────┘
```

🧪 Useful Commands
```bash

Validate
packer validate --var-file=vars.json packer.json

Inspect
packer inspect --var-file=vars.json packer.json

Build
packer build --var-file=vars.json packer.json

Format Packer Configuration
packer fmt packer.json
```

## Security Best Practices
Never commit AWS access keys or secret keys.
Never commit private SSH keys.
Use IAM roles with least-privilege permissions.
Keep vars.json free from secrets.
Restrict AWS Security Group access.
Do not expose Docker's unauthenticated API publicly.
Use environment variables or AWS credential profiles.
Consider using AWS IAM roles instead of long-lived access keys.
📚 Learning Objectives

By completing this practical, you will gain hands-on experience with:

Packer
AWS EC2
Custom AMI creation
Infrastructure automation
Linux systemd services
Docker configuration
Node Exporter
SSH authentication
AWS credentials
PowerShell
DevOps automation
👨‍💻 Author

bhange-saheb

GitHub:
https://github.com/bhange-saheb
