# SPARQLvsR - Node

SPARQLverse implementation with [R](http://www.rstudio.com/)

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

## Setup

- Install node packages with `npm install`
- Duplicate server.R.sample to server.R and set the endpoint

### Installation errors

`unable to locate r binary by scanning standard locations`

You need to install R as well as the RStudio IDE

`xquartz`

OS X mountain Lion requires XQuartz.
`brew cask install xquartz`

## Run

- 

## Apps

### shinyapp

### shinyappsv