#!/bin/bash

read -e -p "What application will we launch? " APP
R -e "shiny::runApp(appDir='./$APP')" & 