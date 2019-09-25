# kitchen-ec2
Kitchen-ec2 test that checks the ec2 box have nginx

Based on : https://github.com/Galser/nginx-aws-box


# Purpose
This repository contains the minimal code and instructions required to create an **AWS EC2** instance box with **Nginx** web server and check with **KitchenCI** that box indeed has Nginx inside.

To learn more about the mentioned above tools and technologies -  please check section [Technologies](#technologies)

# Requirements

You will need to have some applications installed - Packer, Git tools.
For reference where to get them and how to install, please check section [Technologies](#technologies)


# How to use

- To create the image we are going to provision instance in Amazon EC2 service. When building, you'll pass in **aws_access_key** and **aws_secret_key** as user variables, keeping your secret keys out of the template. You can create security credentials on [this page](https://console.aws.amazon.com/iam/home?#security_credential). An example IAM policy document can be found in the [Amazon EC2 builder docs](https://www.packer.io/docs/builders/amazon.html). **NEVER** save your credentials directly in the template file or any other repo parts.
- To download the copy of the code (*clone* in Git terminology) - go to the location of your choice (normally some place in home folder) and run in terminal:
 ```
 git clone https://github.com/Galser/kitchen-ec2.git
 ```
 *in case you are using alternative Git Client - please follow appropriate instruction for it and download(*clone*) [this repo](https://github.com/Galser/kitchen-ec2.git).*

- The previous step should create a folder that contains a copy of the repository. The default name is going to be the same as the name of repository e.g. `kitchen-ec2`. Locate and open it.
 ```
 cd kitchen-ec2
 ```
- To use KitchenCI we will need AWS CLI tools, please follow [instructions from here](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html). Pay attention that you will need to Configure AWS CLI - e.g. have your access key and secret key defined.

- As we are going to use KitchenCI to test our box, we need to prepare some secure way of passing credentials. 
You can provide your credentials via the AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY, environment variables, representing your AWS Access Key and AWS Secret Key, respectively. Note that setting your AWS credentials using either these environment variables will override the use of AWS_SHARED_CREDENTIALS_FILE and AWS_PROFILE. To prepare your credentials execute from command line  :
```
export AWS_ACCESS_KEY_ID="anaccesskey"
export AWS_SECRET_ACCESS_KEY="asecretkey"
```

- In order to prepare box image and test configuration that contains link to new image execute from the command line : 
 ```
 make build
 ```
 *Note : This will utilize [Makefile](Makefile) with all instructions that is prepared in this repo. Generally in the modern distributions, you already have make command by default, if it is missing, you will need to check you OS documentation on the instructions how to install make. Often it will just require simple one or two commands.*
 The output will start with lines like these  :
 ```
 scripts/build.sh
 amazon-ebs output will be in this color.

 ==> amazon-ebs: Force Deregister flag found, skipping prevalidating AMI Name
     amazon-ebs: Found Image ID: ami-050a22b7e0cf85dd0
 ```
 Succesfull build should end up in the lines like in the example below :
 ```
  Build 'amazon-ebs' finished.

 ==> Builds finished. The artifacts of successful builds are:
 --> amazon-ebs: AMIs were created:
 eu-central-1: ami-0e9014773a5cf6a07
 ```
- **Important NOTE** - Inside the build phase we using Packer, and Packer only builds images. It does not attempt to manage them in any way. After they're built, it is up to you to launch or destroy them as you see fit. After running the above example, **your AWS account now has an AMI associated with it. AMIs are stored in S3 by Amazon, so unless you want to be charged about $0.01 per month, you'll probably want to remove it**. Remove the AMI by first deregistering it on the [AWS AMI management page](https://console.aws.amazon.com/ec2/home?region=us-east-1#s=Images). Next, delete the associated snapshot on the [AWS snapshot management page](https://console.aws.amazon.com/ec2/home?region=us-east-1#s=Snapshots).

- Next step is to install KitchenCI, the task includes multiple steps so it is been provided in a separate section. Please follow instructions in [How to install KitchenCI](#how-to-install-kitchenci)

## How to test
As you've finished preparing test with the last `make build` command and had [installed KitchenCI]((#how-to-install-kitchenci)) you can start running them. 
- To prepare test VM execute :
  ```
  bundle exec kitchen converge
  ```
  The output will start with lines :
  ```
  -----> Starting Kitchen (v2.3.3)
  -----> Creating <default-ubuntu-1604>...
         If you are not using an account that qualifies under the AWS
  free-tier, you may be charged to run these suites. The charge
  should be minimal, but neither Test Kitchen nor its maintainers
  are responsible for your incurred costs.
  ```
  and should end up with :
  ```
         Finished converging <default-ubuntu-1604> (0m0.16s).
  -----> Kitchen is finished. (0m40.43s)
  ```
- To run tests execute : 
  ```
  bundle exec kitchen verify
  ```
  The output going to look like : 
  ```
  -----> Starting Kitchen (v2.3.3)
  -----> Setting up <default-ubuntu-1604>...
         Finished setting up <default-ubuntu-1604> (0m0.00s).
  -----> Verifying <default-ubuntu-1604>...
  verify_host_key: false is deprecated, use :never
         Loaded tests from {:path=>".Users.***.kitchen-ec2.test.integration.default"} 

  Profile: tests from {:path=>"/Users/.../kitchen-ec2/test/integration/default"} (tests from {:path=>".Users.***.kitchen-ec2.test.integration.defaultt"})
  Version: (not specified)
  Target:  ssh://ubuntu@ec2-18-185-90-20.eu-central-1.compute.amazonaws.com:22

    System Package nginx
       ✔  should be installed

  Test Summary: 1 successful, 0 failures, 0 skipped
         Finished verifying <default-ubuntu-1604> (0m1.05s).
  -----> Kitchen is finished. (0m6.18s)
  ```
  And as you can see from output above - 1 test finished successfully, no errors, no failures. And if you have color-enabled console there should be a green checkmark that 
    > System package nginx - **should be installed**,
    
  e.g. we do have Nginx installed in our box.
- To destroy the VM and free resources, run:
    ```
    bundle exec kitchen destroy
    ```
    Output :
    ```
     -----> Destroying <default-ubuntu-1604>...
       Waited 0/300s for instance <i-00fba04b9422fa2a0> to terminate.
       Waited 5/300s for instance <i-00fba04b9422fa2a0> to terminate.
       Waited 10/300s for instance <i-00fba04b9422fa2a0> to terminate.
       Waited 15/300s for instance <i-00fba04b9422fa2a0> to terminate.
       Waited 20/300s for instance <i-00fba04b9422fa2a0> to terminate.
       EC2 instance <i-00fba04b9422fa2a0> destroyed.
       Removing automatic security group sg-023f42b1000da5b0b
       Removing automatic key pair kitchen-defaultubuntu1604-sdsdsdsdT11:21:21Z-9goegjwd
       Finished destroying <default-ubuntu-1604> (0m21.22s).
       Finished testing <default-ubuntu-1604> (0m56.22s).    
    ```

This concludes the instructions block, thank you.

Once more - reminder - you could probably have now new AMIs and corresponding snapshots in Amazon AWS, **please do not forget to clean them once they are not needed anymore, to avoid unnecessary charges on your account**. 
 
 
# How to install KitchenCI

In order to run our tests we need an isolated Ruby environment, for this purpose we are going to install and use rbenv - tool that lets you install and run multiple versions of Ruby side-by-side. 
- **On macOS use HomeBrew** (check [Technologies section](#technologies) for more details) to install rbenv.  Execute from command-line :
    ```
    brew install rbenv
    ```
   To succesfully utilize rbenv you will need also to make appropiate env changes :
   - macOs with BASH as the default  shell, run the commands
   ```
   echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
   source ~/.bash_profile
   rbenv init
   echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
   source ~/.bash_profile
   ```
   - macOS with ZSH as default shell (credits to :  [Rod Wilhelmy](https://coderwall.com/wilhelmbot) ), run the commands :
   ```
   echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.zshenv
   echo 'eval "$(rbenv init -)"' >> ~/.zshenv
   echo 'source $HOME/.zshenv' >> ~/.zshrc
   exec $SHELL
   ```
- **On Linux (Debian flavored)**:

 > Note: On Graphical environments, when you open a shell, sometimes ~/.bash_profile doesn't get loaded You may need to source ~/.bash_profile manually or use ~/.bashrc
 ```
 apt update
 apt install autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm5 libgdbm-dev
 wget -q https://github.com/rbenv/rbenv-installer/raw/master/bin/rbenv-installer -O- | bash
 echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
 source ~/.bash_profile
 rbenv init
 echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
 source ~/.bash_profile
 ```
For other distributions please refer to your system's appropriate manuals 

- Install required Ruby version and choose it as default local. Run from command line : 
```
rbenv install 2.3.1
rbenv local 2.3.1
```
- Check that your settings are correct by executing :
```
rbenv versions
```
Output should like something like this : 
```
 system
* 2.3.1 (set by /Users/.../kitchen-vagrant/.ruby-version)
  2.6.0
```
Your output can list other versions also, due to the difference in environments, but the important part is that you should have that asterisk (*) symbol in front of the Ruby version 2.3.1 marking it as active at the current moment
- To simplify our life and to install required Ruby packages we are going to use **Ruby bundler** (See : https://bundler.io/ ). Let's install it. Execute : 
```
gem install bundler
```
- We going to use KitchenCI for our test, to install it and other required **Ruby Gems**, the repository comes with the [Gemfile](Gemfile) that list all that required. Run :
```
bundle install
```
Output going to span several pages, but the last part should be : 
```
Fetching test-kitchen 2.3.3
Installing test-kitchen 2.3.3
Fetching kitchen-inspec 1.2.0
Installing kitchen-inspec 1.2.0
Fetching kitchen-vagrant 1.6.0
Installing kitchen-vagrant 1.6.0
Bundle complete! 4 Gemfile dependencies, 107 gems now installed.
Use `bundle info [gemname]` to see where a bundled gem is installed.
```
Now KitchenCI is ready for usage, you can go back and continue with tests from [this section](#how-to-test). 

# Technologies

1. **To download the content of this repository** you will need **git command-line tools**(recommended) or **Git UI Client**. To install official command-line Git tools please [find here instructions](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) for various operating systems. 
2. **This box for virtualization** uses **AWS EC2** - Amazon Elastic Compute Cloud (Amazon EC2 for short) - a web service that provides secure, resizable compute capacity in the cloud. It is designed to make web-scale cloud computing easier for developers. You can read in details and create a free try-out account if you don't have one here :  [Amazon EC2 main page](https://aws.amazon.com/ec2/) 
3. **For creating AWS EC2 image** we need **Packer** - an open-source tool for creating identical machine images for multiple platforms from a single source configuration.  You can [download binaries for your platform here](https://www.packer.io/downloads.html)  and then [follow this installation instruction](https://www.packer.io/intro/getting-started/install.html#precompiled-binaries).  
4. **KitchenCI** - provides a test harness to execute infrastructure code on one or more platforms in isolation. For more details please check the product site : [KitchenCI](https://kitchen.ci/). There is a dedicated section in README on [How to install KitchenCI](#how-to-install-kitchenci)

# Tools that are going to be used indirectly

5. **RubyGems** is a package manager for the Ruby programming language that provides a standard format for distributing Ruby programs and libraries (in a self-contained format called a "gem"), a tool designed to easily manage the installation of gems, and a server for distributing them. More here: https://rubygems.org/
6. **Nginx** is an open-source HTTP Web server and reverse proxy server. In addition to offering HTTP server capabilities, Nginx can also operate as an IMAP/POP3 mail proxy server as well as function as a load balancer and HTTP cache server. You can get more information about it  - check [official website here](https://www.nginx.com)  

# TODO


# DONE

- [x] initial readme
- [x] define objectives
- [x] create (reuse) AWS EC2 packer template
- [x] update instructions for Packer part
- [x] create **first KitchenCI tests**
- [x] tune KitchenCI test to perform as per task
- [x] create makefile for end-user
- [x] update instruction for **make part**
- [X] update instruction for **KitchenCI part**
- [x] make last-minutes updates to README

