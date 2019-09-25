# kitchen-ec2
Kitchen-ec2 test that checks the ec2 box have nginx

Based on : https://github.com/Galser/nginx-aws-box


# Purpose
This repository contains the minimal code and instructions required to create an **AWS EC2** instance box with **Nginx** web server and check with **KitchenCI** that box indeed has Nginx inside.

To learn more about the mentioned above tools and technologies -  please check section [Technologies near the end of the README](#technologies)


# How to use


# Technologies

1. **To download the content of this repository** you will need **git command-line tools**(recommended) or **Git UI Client**. To install official command-line Git tools please [find here instructions](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) for various operating systems. 
2. **This box for virtualization** uses **AWS EC2** - Amazon Elastic Compute Cloud (Amazon EC2 for short) - a web service that provides secure, resizable compute capacity in the cloud. It is designed to make web-scale cloud computing easier for developers. You can read in details and create a free try-out account if you don't have one here :  [Amazon EC2 main page](https://aws.amazon.com/ec2/) 
3. **For creating AWS EC2 image** we need **Packer** - an open-source tool for creating identical machine images for multiple platforms from a single source configuration.  You can [download binaries for your platform here](https://www.packer.io/downloads.html)  and then [follow this installation instruction](https://www.packer.io/intro/getting-started/install.html#precompiled-binaries).  
4. **KitchenCI** - provides a test harness to execute infrastructure code on one or more platforms in isolation. FGor more details please check the productl site : [KitchenCI](https://kitchen.ci/)
5. **RubyGems** is a package manager for the Ruby programming language that provides a standard format for distributing Ruby programs and libraries (in a self-contained format called a "gem"), a tool designed to easily manage the installation of gems, and a server for distributing them. More her : https://rubygems.org/

6. **Nginx stands apart - as it will be downloaded and installed automatically during the provision.** Nginx is an open source HTTP Web server and reverse proxy server.In addition to offering HTTP server capabilities, Nginx can also operate as an IMAP/POP3 mail proxy server as well as function as a load balancer and HTTP cache server. You can get more information about it  - check [official website here](https://www.nginx.com)  

# TODO
- [ ] define objectives
- [ ] create (reuse) AWS EC2 packer template
- [ ] update instrcutions
- [ ] create first KitchenCI tests
- [ ] tune KitchenCI test
- [ ] update instruction for **KitchenCI part**
- [ ] create makefile for end-user
- [ ] update instruction for **make part**
- [ ] make last-minutes updates to README

# DONE

- [x] initial readme
