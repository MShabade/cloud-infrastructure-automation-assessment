# Cloud Infrastructure Automation Assessment

This project demonstrates a complete end-to-end DevOps workflow using Infrastructure as Code, configuration management, containerization, and CI/CD automation.

The infrastructure is provisioned using Terraform, configured using Ansible, and deployed automatically using GitHub Actions.

---

## Project Highlights

- Infrastructure as Code (IaC) using Terraform  
- Configuration Management using Ansible  
- Dockerized Web Application  
- Automated CI/CD using GitHub Actions  

---

## Architecture Overview

```text
Developer Push → GitHub Repository
                ↓
            Terraform
                ↓
             AWS EC2
                ↓
             Ansible
                ↓
              Docker
                ↓
         Running Web App
```

---

## Folder Structure

```text
cloud-infrastructure-automation-assessment/
│
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
│
├── ansible/
│   ├── inventory.ini
│   └── playbook.yml
│
├── app/
│   ├── index.html
│   └── Dockerfile
│
├── .github/
│   └── workflows/
│       └── main.yml
│
└── README.md
```

---

## Step-by-Step execution

### Clone Repository

```bash
git clone <your-repo-url>
cd cloud-infrastructure-automation-assessment
```

---

### Provision Infrastructure

```bash
cd terraform
terraform init
terraform apply
```

---

### Configure Server

```bash
cd ../ansible
ansible-playbook -i inventory.ini install_docker.yml
```

---

### Deploy Application Manually (Testing)

```bash
ssh -i ../terraform/devops-tf-key.pem ubuntu@<EC2_PUBLIC_IP>
docker build -t devops-app ../app
docker run -d -p 80:80 --name devops-app devops-app
```

Visit:

```
http://<EC2_PUBLIC_IP>
```

---

## CI/CD Deployment

On every push to `main` branch:

- Docker image is built  
- Image is pushed to Docker Hub  
- EC2 is updated automatically  

---

## Required GitHub Secrets

| Secret Name | Description |
|-------------|-------------|
| DOCKER_USERNAME | Docker Hub username |
| DOCKER_PASSWORD | Docker Hub token |
| EC2_HOST | EC2 public IP |
| EC2_SSH_KEY | Content of devops-tf-key.pem |

---

## Author

Mahendra Shabade  
Terraform → EC2 → Ansible → Docker → GitHub Actions
