# magento2-tf

## Summary
This terraform project creates a multi-region Magento 2.4 environment on AWS, with the ability to be used in an active-active manner. 

## How-to
### Deploying as multi-region
1. Edit the `region1_main.tf` file, set the `credentials` variable to your aws credentials file.
2. Add 2 profiles to your credentials file, one for each region, with profile names `region1` and `region2` as follows:

```
[region1]
region = us-east-1
aws_access_key_id = <ACCESS_KEY_ID>
aws_secret_access_key = <SECRET_KEY>

[region2]
region = us-west-1
aws_access_key_id = <ACCESS_KEY_ID>
aws_secret_access_key = <SECRET_KEY>
```
3. Modify `region1_vars.tf` and `region2_vars.tf`, set the regions you want Magento to be deployed to. Default values are `us-east-1` and `us-west-1`

### Deploying as single-region
1. Edit the `region1_main.tf` file, set the `credentials` variable to your aws credentials file.
2. Add 1 profiles to your credentials file, one for each region, with profile names `region1`

```
[region1]
region = us-east-1
aws_access_key_id = <ACCESS_KEY_ID>
aws_secret_access_key = <SECRET_KEY>
```
3. Delete `region2*.tf` files
4. Modify `region1_vars.tf`, set the `region1` variable to where you want Magento to be deployed to. Default value is `us-east-1`

## Diagram
![screenshot](https://github.com/davoclock/magento2-tf/blob/master/img/multiregionmagento.png)

## Progress
### Network
- [x] VPCs
- [x] Subnets
- [x] Routing tables
- [x] Internet Gateways
- [x] NAT Gateways
- [x] Routing table associations
- [x] Default Routes
- [X] VPC Peering
- [X] VPC Routes
- [X] Security Groups
- [X] Database Subnet Groups

### EC2 - Bastion Host
- [X] EC2 Instance
- [X] Key Pair

### Database
- [X] MariaDB Database (10.4.13)
- [ ] Cross-Region Replica
- [X] Parameter Groups
- [X] Storage Auto-Scaling

### EFS
- [X] EFS Volumes
- [X] EFS Targets

### Redis
- [ ] Cross-Region Redis Cluster

### Search
- [X] Elasticsearch Domain
- [X] Elasticsearch Access Policies
- [ ] Elasticsearch Dedicated Master

### LBs
- [ ] Certificate
- [ ] Target Groups
- [ ] Security Profile
- [ ] Health Checks

### Cache
- [ ] Varnish Dockerfile
- [ ] Varnish ECR Permissions
- [ ] Fargate Cluster
- [ ] Fargate Task Definition
- [ ] Fargate Service

### Web
- [ ] Magento 2.4 Dockerfile
- [ ] Varnish ECR Permissions
- [ ] Fargate Cluster
- [ ] Fargate Task Definition
- [ ] Fargate Service

### IAM
- [ ] EC2 Roles
- [ ] ECS/Fargate Task roles
- [ ] ECS/Fargate Task Execution roles

### CDN
- [ ] TBD; Cloudfront vs Cloudflare

### DNS
- [ ] Route53 zone
- [ ] DNS Records

### WAF
- [ ] TBD - AWS Shield/WAF vs Cloudflare

## Useful Links
[Magento performance best practices](https://devdocs.magento.com/guides/v2.3/performance-best-practices/software.html)

[Magento system requirements](https://devdocs.magento.com/guides/v2.3/install-gde/system-requirements-tech.html)

[Tuning Nginx](https://www.nginx.com/blog/tuning-nginx/)
