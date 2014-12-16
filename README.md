# SPARQLverse implementation with [R](http://www.rstudio.com/)

## Run

- Boot up the system with `sudo rstudio-server start` (sometimes you need to use `restart`) and access on port 8787 (http://localhost:8787/).
- Log in as the user, or paraccel
- Run this command from the RStudio Console panel:
```
runApp('~/sparqlverse-r/<<your app>>')
```
or from the terminal 
```
R -e "shiny::runApp('~/sparqlverse-r/shinyappsv')" &
```
It will try to automatically pop open a new window with the visualization. If it does not work, it will tell you the port. Copy that and follow this pattern: `http://localhost:8787/p/<<port>>`

## Build assets for development

For development, you will need serve the Shiny Server, and watch for file changes.
```
npm run serve
npm run watch
```

## Shiny Server

- Boot up the Shiny Server with `start shiny-server` and access port 3838 (https://localhost:3838)

## Run in the browser

On your VM go to port 3838/sparqlverse-r/<<your app>> . This opens the /srv/shiny-server/ directory

# Setup 

- Clone the repo to /srv/shiny-server on the VM
- Install node packages with `npm install`
- Duplicate any .sample files, removing the .sample filetype. 'endpoint.txt' for example. This is to keep developer-specific files out of the repo and reduce merge conflicts.
- Build the global assets with `npm run build` in this directory
- Read any specific instructions in the local readme
- install shiny packages as sudo:
```
sudo su -c "R -e \"install.packages('<package name>', repos='http://cran.rstudio.com/')\"" &
```

# Build for production

Build the global assets with `npm run build` in this directory

Individual examples might have specific stylesheets, scripts, and images that will be located in the project's www directory.

# Dependencies
- NPM
- Ruby
- Sass

### Running in /srv
If you cannot clone the repo to /srv, copy from your main directory to /srv. Check the ownership and make sure all of the main files are owned by the paraccel user and paraccel group
```
sudo chown -R paraccel:paraccel *
sudo chown -R paraccel:paraccel .git 
sudo chown -R paraccel:paraccel .gitignore
```
## Install Shiny
```
R -e "install.packages('shiny')" &
```

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

## Packages

The full package list can be found here: [http://cran.r-project.org/web/packages/available_packages_by_name.html](http://cran.r-project.org/web/packages/available_packages_by_name.html)


### Intall the SPARQL package
Once you are logged into the rstudio server you will need to install the SPARQL packages

- Go to the packages panel in the bottom right window
- Select 'install packages'
- Search for SPARQL and install it
- If you get errors, you will need to install libxml and RcURL:
```
sudo yum -y install libxml2-devel
sudo yum -y install libcurl-devel
```
- Now SPARQL will appear in the packages and you can select it

You can also install through the terminal:
```
R
install.packages("SPARQL",dependencies="TRUE");
install.packages("igraph");
```

#### The problem with accessing packages through shiny

The shiny user needs to have access to the R packages.

```
# Make the shiny user accessable
chmod 777 /home/shiny
# Copy the R package from 
cd shiny
cp -r ~/R .
```

Ideally, this would be a symlink to our main directory. 

### Installation errors

`unable to locate r binary by scanning standard locations`

You need to install R as well as the RStudio IDE

`xquartz`

OS X mountain Lion requires XQuartz.
`brew cask install xquartz`

### Install the iGraph package

- Go to the packages panel, select 'install packages', search for igraph and install with dependencies

# Apps

Each subfolder of this project is a unique Shiny application. Each will have a readme file explaining unique capabilities and requirements for the app

