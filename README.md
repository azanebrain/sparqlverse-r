# SPARQLvsR

SPARQLverse implementation with [R](http://www.rstudio.com/)

## Run

- Boot up the system with `sudo rstudio-server start` (sometimes you need to use `restart`) and access on port 8787 (http://ws-akeen:8787/).
- Log in as the user, or paraccel

Shiny Server

- Boot up the Shiny Server with `start shiny-server` and access port 3838 (https://ws-akeen:3838)

## Setup 

- Clone the repo
- Install node packages with `npm install`
- Duplicate server.R.sample to server.R and set the endpoint

## Install locally

The R Studio IDE can be found here: [https://www.rstudio.com/ide/](https://www.rstudio.com/ide/)
- Or with homebrew:
```bash
brew tap homebrew/science
brew install r
echo 'disable r' >> ~/.zshrc
brew cask install rstudio
which r
echo setenv RSTUDIO_WHICH_R <location to r from 'which r'> | launchctl
```

The server version of the IDE can be found here: [https://www.rstudio.com/ide/server/](https://www.rstudio.com/ide/server/)

## Install on a VM. [Official intructions](http://www.rstudio.com/shiny/server/install-opensource)

- Get up to date
```
sudo yum update
? rpm update install
```
- You must first setup R and Shiny R. To do this you need to install the Extra Packages for Enterprise Linux (EPEL) package from [Fedora](https://fedoraproject.org/wiki/EPEL) 
- You can enable EPEL with the Redhat Package Manager (RPM)
```
rpm --import http://ftp.riken.jp/Linux/fedora/epel/RPM-GPG-KEY-EPEL-6
sudo rpm -ivh http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
```
- Now you can install R, Shiny, Shiny Server, and R Studio Server. [Instructions](http://www.rstudio.com/shiny/server/install-opensource):
```
sudo yum -y install R

sudo su - \
    -c "R -e \"install.packages('shiny', repos='http://cran.rstudio.com/')\""
wget http://download3.rstudio.org/centos-5.9/x86_64/shiny-server-1.1.0.10000-x86_64.rpm
sudo yum install --nogpgcheck shiny-server-1.1.0.10000-x86_64.rpm

wget http://download2.rstudio.org/rstudio-server-0.98.501-x86_64.rpm
sudo yum install --nogpgcheck rstudio-server-0.98.501-x86_64.rpm
```
- Configure R Studio Server
```
sudo touch /etc/rstudio/rserver.conf
sudo touch /etc/rstudio/rsession.conf
```
- After editing configuration files you should perform a check to ensure that the entries you specified are valid. This can be accomplished by executing the following command (will fail if the configuration is not valid):
```
sudo rstudio-server test-config
```
- Create a user to log into the R Server on the VM as a user other than paraccel. It is suggested to make a unique user for each person who may access your system. (to list users use `cat /etc/passwd`)
```
sudo useradd <username>
sudo passwd <username>
sudo usermod -u <target user level that is greater than 500> <username>
```
- Start the server with
```
sudo rstudio-server restart
```

Make sure everyting is installed

- Test r with `R`
- Test rstudio with `rstudio-server`
- Test Shiny Server with `shiny-server`

### Intall the SPARQL package
Once you are logged into the rstudio server you will need to install the SPARQL packages
- Go to the packages panel in the bottom right window
- install packages
- search for SPARQL and install it
- Need to install libxml and RcURL:
```
sudo yum -y install libxml2-devel
sudo yum -y install libcurl-devel
```
- Now SPARQL will appear in the packages and you can select it

### Installation errors

`unable to locate r binary by scanning standard locations`

You need to install R as well as the RStudio IDE

`xquartz`

OS X mountain Lion requires XQuartz.
`brew cask install xquartz`

## Apps

### shinyapp

### shinyappsv