#!/bin/bash
# script to ease execution of the app
# declare some variables
MYPATH=`pwd`
#JRE_HOME=/usr/jdk/jdk1.6.0_18
# change to the build directory
cd $MYPATH/jar
# run the app
java -jar WebsiteAnalytics.jar -properties $MYPATH/default.properties -task build-reports
#$JRE_HOME/bin/java -jar WebsiteAnalytics.jar -properties $MYPATH/default.properties -task build-reports
