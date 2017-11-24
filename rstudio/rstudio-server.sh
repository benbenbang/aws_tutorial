#! /bin/sh
PKG_MANAGER=$( command -v yum || command -v apt || command -v zypper || command -v pkg) || echo "Neither yum nor apt-get found"
: <<'COMMENT'
Support PKG Manager and Disto:
yum: CentOS (Amazon Linux AMI)
apt: Debian / Ubuntu
//dnf: There's no Fedora on AWS
zypper: SUSE
pkg: FreeBSD
COMMENT

sudo $PKG_MANAGER update
# For R core
sudo $PKG_MANAGER install -y r-base
# For dependency of devtools in R
sudo $PKG_MANAGER install -y build-essential libcurl4-gnutls-dev libxml2-dev libssl-dev
# For R Studio Server
sudo $PKG_MANAGER install -y gdebi-core
wget https://download2.rstudio.org/rstudio-server-1.1.383-amd64.deb
sudo gdebi -n rstudio-server-1.1.383-amd64.deb
sudo rm rstudio-server-1.1.383-amd64.deb
# Change port from 8787 to 80 for user friendly
sudo echo "www-port=80" >> /etc/rstudio/rserver.conf
# Make Accessible to /usr/local/lib/R/site-library
sudo chmod 777 -R /usr/local/lib/R/site-library

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

# Create a public user just for test
# Danger!
sudo adduser rstudio --disabled-password