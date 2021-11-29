# AWS Palo Alto firewall automated setup

Credit: ```https://www.youtube.com/watch?v=bMlidOn76Uo```

PAN_OS_initialisation_script: ```https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest/docs/guides/awsgcp```

The goal of this project was to replicate the solution shown above in the video link using an IaC approach. This includes replicating the infrastructure and initalising PAN_OS with an inital username and password of your choice. The following manual steps need to be taken.

Creates 3 subnets, one management subnet where the Palo alto firewall instance sits and is accessed through. A private subnet where your application would sit and traffic is routed through the firewall. Finally a public subnet which is connected to an IGW, providing internet access and access to the private subnet through the firewall. Essentially creating a firewall platform using the Palo alto firewall VM.

The configuration in the Palo Alto firewall side to configure the network instances via terraform to pass traffic is still work in progress.

## Prerequisites:

- Suscribe to the PAN-OS AMI bundle 1 on the AWS account you will be using the following link: 
```https://aws.amazon.com/marketplace/pp?sku=e9yfvyj3uag5uo5j2hjikv74n```

- Fill in the env-file in the root folder where appropriate as follows:

```AWS_ACCESS_KEY_ID=AAABBBCCC         # Paste your AWS ACCESS KEY no space or quotations required.```

```AWS_SECRET_ACCESS_KEY=AAABBBCCC     # Paste your AWS Secret key no space or quotations required.```

```PANOS_USERNAME=admin                # Can leave as the default admin username or change. No space or quotations required.```

```PANOS_PASSWORD=password             # Enter a password which meets the PAN_OS password requirements. No space or quotations required.```

```TF_VAR_home_ip=111.111.111.111/32   # Enter your public IPv4 address you will be using to access the PAN_OS management interface. Include the /32 prefix. No space or quotations required.```

## Tools used

- Docker: Used to containerise the entire setup so no prerequisite applications are needed to run this except for docker of course.
- Terraform: To initialise and bring up the infrastructure in AWS
- Terragrunt: Used as a wrapper to help keep the code DRY and create and manage a remote terraform state file. So if you exit the container before closing the infrastructure down, this will not affect the state file.
- Bash: Simple bash scripts which help automate the process of bringing up and shutting down the infrastructure and initalising the PAN-OS.
- Golang: To run the PAN_OS initialisation script. Preventing the need to SSH into the server to create the initial credentials.


## Steps:

- Run the following command to build the container: 
```docker build . -t panos_image```
- Run the following command to then attach inside the running container
```docker run --env-file ./env-file --name panos_container -v $pwd:/terragrunt -it --rm panos_image bash```
- Run the ```start.sh``` script to bring up the infrastructure on aws.
- wait 10mins for PAN_OS to finish booting up after the infrastructure has finished building.
- Run the ```panos_init.sh``` script to initalise PAN_OS with the admin and password provided in the env file. If you get a ```connection refused``` error just wait. The server has not finished the inital setup.
- You can now connect via https to the PAN_OS host with the IP address that is outputted at the end of the ```start.sh``` script. 
- When finished run the ```stop.sh``` script to bring down the infrastructure.

## Current issues

- If you exit out the container before running the stop.sh script, you will need to delete the key-pair and run the ```start.sh``` script to generate a new one if you want to ssh into the server or if you have not ran the ```panos_init.sh``` script yet.
- If during the ```start.sh``` you receive an error about a duplicate bucket name, this will need to be resolved by giving a new random set of characters in the file terragrunt/terragrunt.hcl line 30.
- The resouces created from the remote state i.e. dynamoDB table and s3 bucket need to be manually deleted.

## To-do-List

- Import the steps into a CI/CD pipeline system to remove the need for the scripts.
- Automate the setup of the network interfaces within PAN_OS
- Resolve the current issues.



