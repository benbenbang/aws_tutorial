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