#!/bin/sh

cp -r /home/eric-zhou/develop/jekyll-blog/_site/* /home/eric-zhou/develop/yaozhou.github.io/
cd /home/eric-zhou/develop/yaozhou.github.io
rm *.sh
git add .
git commit -a -m "normal modify"
git push origin master