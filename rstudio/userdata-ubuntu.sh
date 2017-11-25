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