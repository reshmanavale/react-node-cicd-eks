
# React-Node.js Full Stack Deployment with Shared CI/CD Pipeline on EKS

## 📘 Project Overview

This project demonstrates the deployment of a full-stack React (frontend) and Node.js (backend) application using a **shared CI/CD pipeline** on **Amazon EKS**. Docker images are built and pushed to **AWS ECR**, and services are deployed to EKS using **Kubernetes manifests**.

---

## 📦 Project Structure

```
react-node-cicd-eks/
├── backend/
│   ├── Dockerfile
│   └── app.js (Node.js app)
├── frontend/
│   ├── Dockerfile
│   └── src/ (React app)
├── manifests/
│   ├── backend-deployment.yaml
│   ├── backend-service.yaml
│   ├── frontend-deployment.yaml
│   ├── frontend-service.yaml
│   └── ecr-secret.yaml (optional, created via CLI)
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
├── Jenkinsfile (shared pipeline for both apps)
└── README.md
```

---

## ✅ Setup & Execution Steps

### 1. ✅ Build & Push Docker Images to AWS ECR

Ensure AWS CLI is configured:
```bash
aws configure
```

Authenticate Docker with ECR:
```bash
aws ecr get-login-password --region us-west-1 | docker login --username AWS --password-stdin <account-id>.dkr.ecr.us-west-1.amazonaws.com
```

Build and push:

#### Backend
```bash
cd backend
docker build -t backend .
docker tag backend:latest <account-id>.dkr.ecr.us-west-1.amazonaws.com/react-node-backend:latest
docker push <account-id>.dkr.ecr.us-west-1.amazonaws.com/react-node-backend:latest
```

#### Frontend
```bash
cd ../frontend
docker build -t frontend .
docker tag frontend:latest <account-id>.dkr.ecr.us-west-1.amazonaws.com/react-node-frontend:latest
docker push <account-id>.dkr.ecr.us-west-1.amazonaws.com/react-node-frontend:latest
```

---

### 2. ✅ Provision EKS and ECR using Terraform

Navigate to the `terraform/` directory:
```bash
cd terraform
terraform init
terraform apply
```

This creates:
- EKS Cluster
- Node groups
- IAM roles
- ECR repositories (if needed)

---

### 3. ✅ Create Kubernetes Secret for ECR

Create the Kubernetes image pull secret:
```bash
kubectl create secret docker-registry ecr-secret   --docker-server=<account-id>.dkr.ecr.us-west-1.amazonaws.com   --docker-username=AWS   --docker-password="$(aws ecr get-login-password --region us-west-1)"   --docker-email=your-email@example.com
```

---

### 4. ✅ Deploy to EKS Using Kubernetes Manifests

Apply all Kubernetes resources:
```bash
kubectl apply -f manifests/
```

---

### 5. ✅ Access the Frontend

Expose the frontend using a LoadBalancer service, then get the external IP:
```bash
kubectl get svc frontend-service
```

Visit the IP in your browser to access the React frontend.

---

## 📄 Jenkinsfile (Shared CI/CD Logic)

The `Jenkinsfile` includes:
- Git checkout
- Docker image build and push to ECR
- Kubernetes deployment updates

Pipeline supports automated delivery for both frontend and backend apps.

---

## 📌 Notes

- All AWS resources (EKS, ECR, IAM roles) are provisioned via Terraform.
- Docker images are securely hosted on AWS ECR.
- Image pull secrets ensure private image access on EKS.

---

## 📬 Deliverables

- ✅ Dockerfiles for frontend and backend
- ✅ Kubernetes manifests for EKS deployment
- ✅ Jenkinsfile for CI/CD pipeline
- ✅ Terraform code for EKS and ECR provisioning

---

## Screenshot

1. Terreform init
   
  ![Screenshot 2025-06-28 114215](https://github.com/user-attachments/assets/61e706a8-2710-4b26-a7b7-2410ea03d364)
  
2. Terraform apply

   ![Screenshot 2025-06-28 120330](https://github.com/user-attachments/assets/b1b7c60b-85d8-47d4-8bfa-e60d8cb86a62)

   
3.  Docker images

    ![Screenshot 2025-06-28 121609](https://github.com/user-attachments/assets/e888a1c3-f2c0-4eb2-a0dd-bdffc6c85609)
    ![Screenshot 2025-06-28 121936](https://github.com/user-attachments/assets/90f5cdba-877f-43d4-baf0-f8e011b2fa5e)


5.  POD running
    ![Screenshot 2025-06-28 123211](https://github.com/user-attachments/assets/fb8c4d98-9981-4aa5-aee7-1542f3a8ee9f)



---

## ✅ Evaluation Highlights

- Multi-service architecture with environment separation
- Shared and reusable CI/CD pipeline
- Infrastructure-as-code using Terraform
- Secure, production-ready AWS deployment

---

© 2025 Reshma Navale | DevOps Capstone Assignment
