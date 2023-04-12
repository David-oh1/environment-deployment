Instructions to run node app with terraform deployment

##  Prerequisites
    
*   Terraform is downloaded and installed
    *  https://developer.hashicorp.com/terraform/downloads
*   AWS cli is installed
    *  https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
*   Configure AWS
    *   https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html
    *   Access key credentials will be provided

&nbsp;
<p>

*  Download github repo
    *  https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository?tool=cli
    * https://github.com/David-oh1/environment-deployment

</p>
&nbsp;
<p>

*  Open terminal (or any other CLI of your choice) move to the file location of the downloaded directory.
*  Verify that you have all files downloaded
    *  There should be 5 files - main.tf, compute_resources.tf, terraform.tfvars, user_data.sh and index.js
    *  Before running any terraform commands, open the terraform.tfvars file. You will set your ip address in the "my-ip" field between the two quotes. (ex. my-ip = "012.345.678.901")
    *   You can use this site or any other site of your choice to find your ip address. https://www.showmyip.com/
    &nbsp;
</p>
&nbsp;
<p>

*  After files have been verified run "terraform init" to iniatialize the backend
    * The output will look like this: 
        *  Terraform has been successfully initialized!
            You may now begin working with Terraform. Try running "terraform plan" to see any changes that are required for your infrastructure. All Terraform commands should now work. If you ever set or change modules or backend configuration for Terraform, rerun this command to reinitialize your working directory. If you forget, other commands will detect it and remind you to do so if necessary.
&nbsp;
</p>
&nbsp;
<p>

*  Run Terraform plan
    *  You will be asked to input your IP address. You can use this site or any other site of your choice. https://www.showmyip.com/
    *  It will show the resources that are planned.
&nbsp;
</p>
&nbsp;
<p>

*  Run terraform apply and wait for the environment to be created. You will be asked for an AWS key and IP address. Press enter when prompted for aws key without any input for now. Once the it is done, log into AWS and verify that all services have been brought up successfully.
</p>
&nbsp;

#  NEED TO ADD INSTRUCTIONS ON ADDING AWS KEY. I REQUIRE FURTHER EXPLANATION/RESEARCH.

<p>

*  In the internet search bar, enter the IP address or DNS name of the load balacner along with the port 3789 and you will be taken to the welcome webpage.
&nbsp;
</p>
&nbsp;
<p>

*  Run terraform destroy in terminal (or your CLI of choice) to bring down the architecture. This will take a few minutes.

</p>