# magento2-tf

## Summary
This terraform project creates a Multi-AZ Magento 2.4 environment on AWS. Here are the services it uses:

1. EC2 for Bastion Host (Amazon Linux 2) and ALBs
2. Fargate for Varnish and Magento
3. EFS for media assets
4. RDS for MariaDB (10.4)
5. ElasticSearch (7.4)
6. Cloudfront
7. Route 53

Here's what you need:

1. Wildcard, or store-url matching SSL cert under ACM
2. AWS Credentials file with profile name: "magento2-tf", matching the region you choose on the `variables.tf` file

## How-to
### Deployment
1. Edit the `terraform/variables.tf` file, set the `credentials` variable to your aws credentials file.
2. Add 1 profiles to your credentials file with the region you want to deploy Magento to. Use profile name: `magento2-tf`
```
[magento2-tf]
region = <region>
aws_access_key_id = <ACCESS_KEY_ID>
aws_secret_access_key = <SECRET_KEY>
```
3. Modify `vars.tf`, set the `region` variable to where you want Magento to be deployed to. Default value is `us-east-1`
4. Edit `terraform/variables.tf`, adjust variable `ssl_cert_arn`, set to SSL cert on ACM

## Diagram
![screenshot](https://github.com/davoclock/magento2-tf/blob/master/img/magentosingleregion.png)

## Progress
### Network
- [x] VPCs
- [x] Subnets
- [x] Routing tables
- [x] Internet Gateways
- [x] NAT Gateways
- [x] Routing table associations
- [x] Default Routes
- [X] VPC Routes
- [X] Security Groups
- [X] Database Subnet Groups

### IAM
- [X] EC2 Role (bastion host)
- [X] ECS Web Task Execution roles
- [X] ECS Varnish Task Execution roles

### EC2 - Bastion Host
- [X] EC2 Instance
- [X] Key Pair

### Database
- [X] MariaDB Database (10.4.13)
- [X] Parameter Groups
- [X] Storage Auto-Scaling

### EFS
- [X] EFS Volumes
- [X] EFS Targets

### Redis
- [X] Redis Session Cluster
- [X] Redis Default Cache Cluster

### Search
- [X] Elasticsearch Domain
- [X] Elasticsearch Access Policies
- [ ] Elasticsearch Dedicated Master

### LBs
- [X] Varnish ALB
- [X] Magento ALB
- [X] Target Groups
- [X] Listener Security Profiles
- [X] Health Checks

### Cache
- [X] Varnish Dockerfile
- [X] Varnish ECR Repo
- [X] Fargate Cluster
- [X] Fargate Task Definition
- [X] Fargate Service

### Web
- [X] Magento 2.4 Dockerfile
- [X] Magento ECR Repo
- [X] Fargate Cluster
- [X] Fargate Task Definition
- [X] Fargate Service

### Magento CodePipeline
- [ ] Build Process
- [ ] Deploy Process
- [ ] Github source
- [ ] Magento ECR Permissions

### CDN
- [ ] Cloudfront

### WAF
- [ ] AWS Shield

## Useful Links
[Magento performance best practices](https://devdocs.magento.com/guides/v2.3/performance-best-practices/software.html)

[Magento system requirements](https://devdocs.magento.com/guides/v2.3/install-gde/system-requirements-tech.html)

[Tuning Nginx](https://www.nginx.com/blog/tuning-nginx/)
