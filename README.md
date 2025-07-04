🚀 Simple Python App: Docker + ECR + EKS with Terraform & Helm
📜 Overview
This project demonstrates:

✅ A simple Python app (FastAPI/Flask)
✅ Dockerized and pushed to AWS ECR
✅ Deployed on AWS EKS using Helm
✅ Infrastructure provisioned with Terraform (VPC, EKS cluster, Node Groups, IAM)

🛠️ Tech Stack
Python (FastAPI/Flask)

Docker

AWS ECR (container registry)

AWS EKS (managed Kubernetes)

Terraform (infrastructure as code)

Helm (Kubernetes package manager)

🗂️ Project Structure

.
├── app/
│   └── main.py             # Python FastAPI/Flask app
│   └── requirements.txt
├── Dockerfile
├── helm-chart/
│   └── Chart.yaml
│   └── values.yaml
│   └── templates/
│       └── deployment.yaml
│       └── service.yaml
├── terraform/
│   └── main.tf
│   └── vpc.tf
│   └── eks.tf
│   └── variables.tf
│   └── outputs.tf
└── README.md
🚀 Step-by-Step Deployment
1️⃣create a simple app using python
cd YOUR_REPO
2️⃣ Build & push Docker image to ECR
Authenticate with ECR:
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <account_id>.dkr.ecr.us-east-1.amazonaws.com

Build the image:

docker build -t simple-python-app .
Tag the image:

docker tag simple-python-app:latest <account_id>.dkr.ecr.us-east-1.amazonaws.com/simple-python-app:latest

Push to ECR:

docker push <account_id>.dkr.ecr.us-east-1.amazonaws.com/simple-python-app:latest

3️⃣ Provision EKS using Terraform
Navigate to your Terraform folder:

cd terraform
Initialize Terraform:

terraform init
Apply infrastructure:

terraform apply -auto-approve
This creates:
✅ VPC with public and private subnets
✅ EKS cluster and node groups
✅ IAM roles and security groups

4️⃣ Update kubeconfig to connect to EKS

aws eks --region us-east-1 update-kubeconfig --name <cluster_name>
Test connectivity:

kubectl get nodes
5️⃣ Deploy using Helm
Navigate to your Helm chart folder:

cd helm-chart
Update your values.yaml:

Edit
image:
  repository: <account_id>.dkr.ecr.us-east-1.amazonaws.com/simple-python-app
  tag: latest
Install Helm chart:

helm install simple-python-app . --namespace simple-app --create-namespace
Verify deployment:

kubectl get pods -n simple-app
6️⃣ Access the Application
Retrieve the LoadBalancer URL:

kubectl get svc -n simple-app
Copy the EXTERNAL-IP and open it in your browser to access the app.

✅ Cleaning Up
To delete resources and avoid unnecessary costs:

helm uninstall simple-python-app -n simple-app
terraform destroy -auto-approve
