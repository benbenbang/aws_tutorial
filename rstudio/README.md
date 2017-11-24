# Project: Run R Server on AWS

##### Ben Chen, 19/11/2017



## Part. 1 Launch a EC2 Instance

1. In <u>Step1</u>, select a AMI, you can choose either

   - **Ubuntu Server 16.04 LTS (HVM)**

     <img src="http://d.pr/i/BX11Ya.png" style="zoom:30%">

   - **Amazon Linux AMI 2017.09.1 (HVM)**
     <img src="http://d.pr/i/2d0yiS.png" style="zoom:30%">

2. In <u>Step 2</u>, select an Instance Type that you will need. For one who only want to try, you can select `t2.micro` which is included in the free tier.

3. In <u>Step 3</u>, In the **Advanced Details: User data**, paste the folling code to the text block. 

   - Notice that there's a optional part in the following code and it might take some little time especially you decide to include the second part of optional code.
     - First part will help you to change port from `8787` to normal http port `80`
     - Second part will help you to preinstall some package in R


   - For one who choose **Ubuntu Server**:

``` bash
#! /bin/sh
sudo apt update
# For R core
sudo apt install -y r-base
# For dependency of devtools in R
sudo apt install -y build-essential libcurl4-gnutls-dev libxml2-dev libssl-dev
# For R Studio Server
sudo apt install -y gdebi-core
wget https://download2.rstudio.org/rstudio-server-1.1.383-amd64.deb
sudo gdebi -n rstudio-server-1.1.383-amd64.deb
sudo rm rstudio-server-1.1.383-amd64.deb
# Make Accessible to /usr/local/lib/R/site-library
sudo chmod 777 -R /usr/local/lib/R/site-library

# Optional Part
# Change port from 8787 to 80 for user friendly
sudo echo "www-port=80" >> /etc/rstudio/rserver.conf
sudo rstudio-server restart

# Preinstall some useful R Packages
R -e "install.packages('devtools', repos='http://cran.rstudio.com/')"
R -e "install.packages('ggplot2', repos='http://cran.rstudio.com/')"
R -e "install.packages('knitr', repos='http://cran.rstudio.com/')"
R -e "install.packages('rmarkdown', repos='http://cran.rstudio.com')"
R -e "install.packages('RCurl', repos='http://cran.rstudio.com')"
R -e "install.packages('shiny', repos='http://cran.rstudio.com/')"
R -e "devtools::install_github('IRkernel/IRdisplay')"
R -e "devtools::install_github('IRkernel/IRkernel')"
R -e "IRkernel::installspec()"
```

   - For one who choose **Amazon Linux AMI**:

``` bash
#! /bin/sh
sudo yum update
# For R core
sudo yum install -y R
# For dependency of devtools in R
sudo yum install -y libcurl-devel openssl-devel
# Make Accessible to /usr/local/lib/R/site-library
sudo chmod 777 -R /usr/lib64/R/library
# For R Studio Server
wget https://download2.rstudio.org/rstudio-server-rhel-1.1.383-x86_64.rpm
sudo yum install -y --nogpgcheck rstudio-server-rhel-1.1.383-x86_64.rpm
sudo rm rstudio-server-rhel1.1.383-amd64.deb
# Make Accessible to /usr/local/lib/R/site-library
sudo chmod 777 -R /usr/lib64/R/library

# Optional Part
# Change port from 8787 to 80 for user friendly
sudo chmod 777 /etc/rstudio/rserver.conf
sudo echo "www-port=80" >> /etc/rstudio/rserver.conf
sudo rstudio-server restart

# Preinstall some useful R Packages
R -e "install.packages('devtools', repos='http://cran.rstudio.com/')"
R -e "install.packages('ggplot2', repos='http://cran.rstudio.com/')"
R -e "install.packages('knitr', repos='http://cran.rstudio.com/')"
R -e "install.packages('rmarkdown', repos='http://cran.rstudio.com')"
R -e "install.packages('RCurl', repos='http://cran.rstudio.com')"
R -e "install.packages('shiny', repos='http://cran.rstudio.com/')"
R -e "devtools::install_github('IRkernel/IRdisplay')"
R -e "devtools::install_github('IRkernel/IRkernel')"
R -e "IRkernel::installspec()"
```

4. Still in <u>Step 3</u>, make sure you have chosen `Use subnet setting (Enable)` in **Auto-assign Public IP**.

5. In <u>in Step 4</u> (Optional), add to more than 8G in **size** if you need. 

6. In <u>Step 5</u> (Optional), add: 

   - Key = `rstudio_server`
   - value = `R Studio Server`

7. In <u>Step 6</u> (**Important**)

   - if you choose to change the default port of R Studio from 8787 to 80 (which means you copy-paste the code above without edit it…), you need to choose:

     - Type = `HTTP`
     - Source = `Anywhere` or `custom 0.0.0.0/0, ::/0` 

     <img src="http://d.pr/i/QDnP6A.png" style="zoom:50%">

   - Otherwise:

     - Type = `Custom TCP Rule`
     - Port Range = `8787`
     - Source = `Anywhere` or `custom 0.0.0.0/0, ::/0`

     <img src="http://d.pr/i/cIyaI4.png" style="zoom:30%">

8. In <u>Step 7</u>, review and launch it.

9. Stand up and have a cup of coffee.

## Part 2. Change R Studio User Password

1. Use your **pem** to login to the instance you just created.
2. Type `rstudio-server status` to check R Studio was properly installed.
3. For the last step, you would need to add a user to log into rstudio server, please type `sudo adduser username` which you would like to add. And it will lead you to finish all the setting. 
4. (Optional) In Amazon Linux AMI, if it doesn't lead you to set your user password, please simply type `sudo passwd username` to do so.

## Part 3. Connect to your R Studio Server

From your web browser, type `ec2-xxxxxxxx.compute.amazonaws.com` to login to your RStudio if you changed the port to `80`, otherwise, type `ec2-compute.amazonaws.com:8787`. Then use `rstudio` as username, the password you choosed in **Part 2** to login. And Done!

## Part 4. Make it reusable (Optional)

For easier to launch for future usage, we can simply create a **AMI** to achieve it.  Simply right click on your instance then choose `Image → Create Image`, and for the final step, you might need to enter an image name and description to create a snapshot and AMI. **Noted** that you should save your workspace in rstudio if you are now using it, once you click on `Create Image`, it might reboot automatically.

<img src="http://d.pr/i/F5aGi5.png" style="zoom:50%">

<img src="http://d.pr/i/cvPu63.png" style="zoom:30%">