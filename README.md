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
![screenshot](https://github.com/davoclock/magento2-tf/blob/master/images/multiregionmagento.png)

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
- [ ] Security Groups
- [ ] Database Subnet Groups

### Database
- [ ] Aurora MySQL Database
- [ ] Cross-Region Replica
- [ ] Parameter Groups
- [ ] Auto-Scaling

### EFS
- [ ] EFS Volumes

### Redis
- [ ] Cross-Region Redis Cluster
- [ ] Parameter Groups

### Search
- [ ] TBD; AWS ElasticSearch vs EC2

### LBs
- [ ] Certificate
- [ ] Target Groups
- [ ] Security Profile
- [ ] Health Checks

### Cache
- [ ] Bootstrap AMI with Varnish Config
- [ ] AutoScaling

### Web
- [ ] Bootstrap AMI with Nginx and Magento Config
- [ ] AutoScaling

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
