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
[To be done]

## Releases
### v0.1
- Network core only. Creates VPCs, subnets, routing tables, IGW, NAT Gateway & creates routing table associations

