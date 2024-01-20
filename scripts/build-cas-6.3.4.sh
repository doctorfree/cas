#!/bin/bash

JAVA_VERSION=java-1.11.0-openjdk-amd64

sudo update-java-alternatives -s $JAVA_VERSION
export JAVA_HOME=/usr/lib/jvm/$JAVA_VERSION/
export PATH=$PATH:$JAVA_HOME/bin

PACKAGE=cas-6.3.4
[ -d $PACKAGE ] || {
    [ -f ./$PACKAGE.tar.gz ] || {
        echo "No archive of $PACKAGE exists here. Exiting."
        exit 1
    }
    tar xzf $PACKAGE.tar.gz
}
cd $PACKAGE

./gradlew build install --parallel -x test -x javadoc -x check --build-cache --configure-on-demand 2>&1 > log-cas-server-6.3.4.txt
