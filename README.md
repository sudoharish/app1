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

```
cd app
docker run --rm --name api-server -p 8005:8005 sudoharish/api-server:latest
```

Deploying APP1 into AWS ECS
===========================

post terraform apply comand user can utilse variable "alb_dns_name" will show link just click on link and use.
example: alb_dns_name http://app1-alb-2097667644.ap-south-1.elb.amazonaws.com
```
cd terraform
terraform init
terraform plan
terraform apply
```

removing infra
--------------
```
cd terraform
terraform destroy
```
