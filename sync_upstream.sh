#!/bin/bash

git remote | grep upstrean >> 2>&1

if [ $? != 0 ]; then
   git remote add upstream https://github.com/grayudu/perso.git
else
   print "\n"
fi

git pull && \
git fetch upstream && \
git merge upstream/master -m "added remote changes" && \
git push
