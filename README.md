# Kube Lab Architecture

This repository contains a complete Kubernetes lab setup using Terraform and Helm, deployed on AWS. The setup includes the creation of an EKS cluster and deploying components using Helm charts.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Configuration](#configuration)
- [Usage](#usage)

## Prerequisites

Before you begin, ensure you have the following installed on your local machine:

- [Terraform](https://www.terraform.io/downloads.html)

## Installation

Clone the repository:

```bash
git clone https://github.com/johnnytardin/kube-lab-architecture.git
cd kube-lab-architecture
```

## Configuration

Set up the following environment variables with your AWS and Terraform S3 bucket details:

```bash
export TERRAFORM_S3_PRODUCTION_STATE_BUCKET=<your-s3-bucket-name>
export TERRAFORM_S3_STATE_PATH=<your-s3-state-path>
export AWS_ACCESS_KEY_ID=<your-aws-access-key-id>
export AWS_SECRET_ACCESS_KEY=<your-aws-secret-access-key>
export AWS_REGION=<your-aws-region>
```

Replace <your-s3-bucket-name>, <your-s3-state-path>, <your-aws-access-key-id>, <your-aws-secret-access-key>, and <your-aws-region> with your actual AWS and Terraform S3 bucket details.

## Usage

```bash
terraform init
```

```bash
terraform plan
```

```bash
terraform apply
```
