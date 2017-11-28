# Jumpbox Project

## Overview

**To set up**, we will need:

- [ ] ​VPC * 1
- Subnets:  
- [ ] Public subnet * 1  
- [ ] Private subnet * 1
- Route Table:  
- [ ] Public Route Table * 1  
- [ ] Private Route Table * 1  
- [ ] Internet Gateway * 1
- [ ] Security Group * 2
- EC2 Instances:  
- [ ] (Public) EC2 in public subnet  
- [ ] (Private) EC2 in private subnet  

## Step 1. Setting VPC

Avoiding using wizard to create a VPC, we should switch tab to `Your VPCs` and then create one with manually by setting:

- Name tag: `Jumpbox`

- IPv4 CIDR block: `10.0.0.0/24` 

  > Due to we only don't need much ip adress, we just set our Network bit to **24**

- From `Actions` select `Edit DNS Hostname` from No to **Yes**

## Step 2. Setting Subnets

1. Public Subnet

   - VPC: Choose `Jumpbox`

   - Availability Zone: Choose `****-1a`

   - IPv4 CIDR block: `10.0.0.0/28` 

     > 11 ips are enough in this case

   - From `Actions` select `Modify auto-assign IP settings` and **check** it.

2. Private Subnet

   - VPC: Choose `Jumpbox`
   - Availability Zone: **Same as public subnet**
   - IPv4 CIDR block: `10.0.0.16/28`

## Step 3. Setting Internet Gateway

Simply create a new `Internet Gateway` for `jumpbox` and remember to attach this gateway to it.

## Step 4. Setting Route Table

By default, there will be a route table which is already linked with `jumpbox` when we create the VPC. For convenience, rename it to be `Jumpbox Public` and in the `Route` tab `add` `0.0.0.0/0` and `igw-****` which is the Internet Gateway assigned to `jumpbox`. Then go to the `Subnet Association` tab to add **public subnet** to this route table.

Finally, create another route table which also should be assigned `jumpbox` VPC and then add **private subnet** to it in `Subnet Association`.

## Step 5. Setting Security Groups

By default, there will be a security group associated with `jumpbox`. Change the inbound rule to `SSH(22)`. 

## Step 6. Launch EC2 Instances

In EC2 Service, first launch a `ubuntu` instance in **public subnet**:

- Network: `jumpbox`
- Subnet: `Public subnet`
- Auto-assign Public IP: If you did it right in Step. 2, you will see`Use subnet setting (Enalbe)`
- Assign to default Security Group
- Create a new PEM Key and name it as `jumpbox_public`
- Copy the Private IP of the Public Instance for future use

Then start to launch a `ubuntu` instance in **private subnet**:

- Network: `jumbox`
- Subnet: `Private subnet`
- (Optional) Create a new Security Group and choose `SSH(22)` and the source from the `Group ID` of Security Group which publc EC2 belongs to.
- Create one another new PEM key and name it as `jumpbox_private`

## Step 7. Send Private key to Public EC2 and Test 

1. In local terminal, use `cat jumpbox_private.pem.txt | ssh -i jumpbox_public.pem ubuntu@****ip-compute.amazonaws.com 'cat >> jumpbox_private.pem && echo "Private key successfully sent"'`


2. Then use `jumpbox_public` to ssh to our public EC2.
3. In public EC2, first type `sudo chmod 400 jumpbox_private.pem`.
4. Then ssh to private EC2 by `ssh -i jumpbox_private ubuntu@Private-IPs`
5. Test: `ping 8.8.8.8` to Google check network works well. And you might get **PING 8.8.8.8 (8.8.8.8) xx(xx) bytes of data.**
