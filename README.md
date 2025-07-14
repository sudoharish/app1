APP1: provides your ip with timestamp in json
=============================================

Building Container Image
========================

CI enbled by default using git workflows, i.e pushing the container image to Dockerhub


Manual Container image Build
----------------------------

```
cd app
docker build -t sudoharish/api-server:latest .
```

Running the container locally
----------------------------
docker run --rm --name api-server -p 8005:8005 sudoharish/api-server:latest

Deploying APP1 into AWS ECS
===========================

```
cd terraform
terraform init
terraform plan
terraform apply
```

removing infra
--------------
cd terraform
terraform destroy
