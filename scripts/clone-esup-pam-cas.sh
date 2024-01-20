#!/bin/bash

project="esup-pam-cas"
patch="${project}-patch.tgz"

[ -d ${project} ] && {
    rm -rf ${project}-
    mv ${project} ${project}-
}

git clone https://github.com/EsupPortail/${project}.git

[ -r ${patch} ] && tar xzvf ${patch}
