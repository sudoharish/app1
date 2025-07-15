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

After running the **terraform apply** command, the user can utilize the **alb_dns_name** output variable. This will display a clickable link, which can be accessed directly for use.
example: **alb_dns_name http://app1-alb-2097667644.ap-south-1.elb.amazonaws.com**
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
