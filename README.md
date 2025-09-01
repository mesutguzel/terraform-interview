# AWS VPC with Public/Private Subnets and Public EC2 (Terraform)


## What this code creates
- VPC 10.0.0.0/16
- Three public subnets across distinct AZs
- Three private subnets across distinct AZs
- Internet gateway and public route table for 0.0.0.0/0
- No NAT gateways; private subnets have no direct internet connectivity
- One EC2 instance in a public subnet with a security group allowing inbound TCP/80 from 0.0.0.0/0
