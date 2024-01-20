#!/bin/bash

project="phpCAS"
patch="${project}-patch.tgz"

[ -d ${project} ] && {
    rm -rf ${project}-
    mv ${project} ${project}-
}

git clone https://github.com/apereo/${project}.git

[ -r ${patch} ] && tar xzvf ${patch}
