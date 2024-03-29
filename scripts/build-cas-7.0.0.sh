#!/bin/bash

JAVA_VERSION=java-1.21.0-openjdk-amd64
CAS_VERSION="7.0.0"

sudo update-java-alternatives -s $JAVA_VERSION
export JAVA_HOME=/usr/lib/jvm/$JAVA_VERSION/
export PATH=$PATH:$JAVA_HOME/bin

CAS_DIR=cas-${CAS_VERSION}
PACKAGE=v${CAS_VERSION}.tar.gz
[ -d ${CAS_DIR} ] || {
    [ -f ./${PACKAGE} ] || {
        wget https://github.com/apereo/cas/archive/refs/tags/${PACKAGE}
    }
    tar xzf ${PACKAGE}
}
cd ${CAS_DIR}

./gradlew build \
    -Djava.net.preferIPv4Stack=true \
    --parallel \
    -x test -x javadoc -x check \
    --build-cache \
    --configure-on-demand 2>&1 > log-cas-server-${CAS_VERSION}.txt
