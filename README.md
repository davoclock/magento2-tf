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
2. AWS Credentials file with a profile name matching the region you choose on the vars.tf file

## How-to
### Deployment
1. Edit the `terraform/main.tf` file, set the `credentials` variable to your aws credentials file.
2. Add 1 profiles to your credentials file with the region you want to deploy Magento to. Use profile name: `magento-region`
```
[magento-region]
region = <region>
aws_access_key_id = <ACCESS_KEY_ID>
aws_secret_access_key = <SECRET_KEY>
```
3. Modify `vars.tf`, set the `region` variable to where you want Magento to be deployed to. Default value is `us-east-1`

## Diagram
![screenshot]("https://github.com/davoclock/magento2-tf/blob/master/img/Magento Single Region.png")

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
- [X] Parameter Groups
- [X] Storage Auto-Scaling

### EFS
- [X] EFS Volumes
- [X] EFS Targets

### Redis
- [ ] Redis Cluster

### Search
- [X] Elasticsearch Domain
- [X] Elasticsearch Access Policies
- [ ] Elasticsearch Dedicated Master

### LBs
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
- [X] Magento 2.4 Dockerfile
- [ ] Magento ECR Permissions
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
