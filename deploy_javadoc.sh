#!/bin/bash

REPO="git@github.com:sockeqwe/mosby.git"

MODULES[0]=core
MODULES[1]=core-dagger1
MODULES[2]=mvp
MODULES[3]=mvp-common
MODULES[4]=mvp-dagger1
MODULES[5]=retrofit
MODULES[6]=rx
MODULES[7]=viewstate
MODULES[8]=viewstate-dagger1

DIR=/tmp/temp-clone

# Delete any existing temporary website clone
rm -rf $DIR

# Clone the current repo into temp folder
git clone $REPO $DIR

# Move working directory into temp folder
cd $DIR

mkdir ./merged_source
mkdir ../static
mkdir ../static/javadoc

for i in "${MODULES[@]}"
do
    cp -R ./$i/src/main/java/com ./merged_source
done

cd merged_source
javadoc -d ../../static/javadoc -sourcepath . -subpackages com

cd ..
rm -rf merged_source

# Checkout and track the gh-pages branch
git checkout -t origin/gh-pages
cp -rf ../static/javadoc ./static/javadoc
rm -rf ../static/javadoc


# Commit changes
git add .
git add -u
git commit -m "Website at $(date)"

# Push the new files up to GitHub
git push origin gh-pages

# Delete our temp folder
cd ..
rm -rf $DIR