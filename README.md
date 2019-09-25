# kitchen-ec2
Kitchen-ec2 test that checks the ec2 box have nginx

Based on : https://github.com/Galser/nginx-aws-box


# Purpose
This repository contains the minimal code and instructions required to create an **AWS EC2** instance box with **Nginx** web server and check with **KitchenCI** that box indeed has Nginx inside.

To learn more about the mentioned above tools and technologies -  please check section [Technologies near the end of the README](#technologies)


# How to use

- To create image we are going to provision instance in Amazon EC2 service. When building, you'll pass in **aws_access_key** and **aws_secret_key** as user variables, keeping your secret keys out of the template. You can create security credentials on [this page](https://console.aws.amazon.com/iam/home?#security_credential). An example IAM policy document can be found in the [Amazon EC2 builder docs](https://www.packer.io/docs/builders/amazon.html). **NEVER** save your credentials directly in the template file or any other repo parts.
- To download the copy of the code (*clone* in Git terminology) - go to the location of your choice (normally some place in home folder) and run in terminal:
 ```
 git clone https://github.com/Galser/kitchen-ec2.git
 ```
 *in case you are using alternative Git Client - please follow appropriate instruction for it and download(*clone*) [this repo](https://github.com/Galser/kitchen-ec2.git).*

- Previous step should create the folder that contains a copy of repository. The default name is going to be the same as the name of repository e.g. `kitchen-ec2`. Locate and open it.
 ```
 cd kitchen-ec2
 ```
- Now to create the AWS EC2 box with Nginx we are going to use Packer and [template](nginx-aws-template.json) with [provision scripts](scripts) provided in this repo.
*Note: It is going to take some time, as Packer need to start instnce, wait for it to be up and running, provision and then pack everything into an AMI - format of images used in Amazon EC2*

To simplify the process we use the credentials in the command line. However, it is potentially insecure. See official  documentation for [other ways to specify Amazon credentials](https://www.packer.io/docs/builders/amazon.html#specifying-amazon-credentials).
 ```
 packer build \
    -var 'aws_access_key=YOUR ACCESS KEY' \
    -var 'aws_secret_key=YOUR SECRET KEY' \ 
    nginx-aws-template.json
 ```
And in the case of successful process completion you would see these *last lines* :
 ```
 Build 'amazon-ebs' finished.

 ==> Builds finished. The artifacts of successful builds are:
 --> amazon-ebs: AMIs were created:
 us-east-1: ami-05109863b0a1a6a3e
 ```
Here - at the end of the run Packer outputs the artifacts that were created as part of the build. Artifacts are the results of a build, and typically represent an ID (such as in the case of an AMI) or a set of files (such as for a VMware virtual machine). In this example, we only have a single artifact: the AMI in us-east-1 that was created with ID  : **ami-05109863b0a1a6a3e** 
This AMI is ready to use. If you wanted you could go and launch this AMI right now and it would work great.

  > Note: Your AMI ID will surely be different than the one above. If you try to launch the one in the example output above, you will get an error. If you want to try to launch your AMI, get the ID from the **your** Packer output.

- **Important NOTE** - Packer only builds images. It does not attempt to manage them in any way. After they're built, it is up to you to launch or destroy them as you see fit. After running the above example, **your AWS account now has an AMI associated with it. AMIs are stored in S3 by Amazon, so unless you want to be charged about $0.01 per month, you'll probably want to remove it**. Remove the AMI by first deregistering it on the [AWS AMI management page](https://console.aws.amazon.com/ec2/home?region=us-east-1#s=Images). Next, delete the associated snapshot on the [AWS snapshot management page](https://console.aws.amazon.com/ec2/home?region=us-east-1#s=Snapshots).

- 


# Technologies

1. **To download the content of this repository** you will need **git command-line tools**(recommended) or **Git UI Client**. To install official command-line Git tools please [find here instructions](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) for various operating systems. 
2. **This box for virtualization** uses **AWS EC2** - Amazon Elastic Compute Cloud (Amazon EC2 for short) - a web service that provides secure, resizable compute capacity in the cloud. It is designed to make web-scale cloud computing easier for developers. You can read in details and create a free try-out account if you don't have one here :  [Amazon EC2 main page](https://aws.amazon.com/ec2/) 
3. **For creating AWS EC2 image** we need **Packer** - an open-source tool for creating identical machine images for multiple platforms from a single source configuration.  You can [download binaries for your platform here](https://www.packer.io/downloads.html)  and then [follow this installation instruction](https://www.packer.io/intro/getting-started/install.html#precompiled-binaries).  
4. **KitchenCI** - provides a test harness to execute infrastructure code on one or more platforms in isolation. FGor more details please check the productl site : [KitchenCI](https://kitchen.ci/)
5. **RubyGems** is a package manager for the Ruby programming language that provides a standard format for distributing Ruby programs and libraries (in a self-contained format called a "gem"), a tool designed to easily manage the installation of gems, and a server for distributing them. More her : https://rubygems.org/

6. **Nginx stands apart - as it will be downloaded and installed automatically during the provision.** Nginx is an open source HTTP Web server and reverse proxy server.In addition to offering HTTP server capabilities, Nginx can also operate as an IMAP/POP3 mail proxy server as well as function as a load balancer and HTTP cache server. You can get more information about it  - check [official website here](https://www.nginx.com)  

# TODO
- [ ] create **first KitchenCI tests**
- [ ] tune KitchenCI test to perfom as per task
- [ ] update instruction for **KitchenCI part**
- [ ] create makefile for end-user
- [ ] update instruction for **make part**
- [ ] make last-minutes updates to README

# DONE

- [x] initial readme
- [x] define objectives
- [x] create (reuse) AWS EC2 packer template
- [x] update instructions for Packer part
