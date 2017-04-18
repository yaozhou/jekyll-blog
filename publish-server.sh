#!/bin/sh

asscii error
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export RUBYOPT="-KU -E utf-8:utf-8"

PWD="$(cd $(dirname $0) && pwd)"

GITHUB_PATH="/home/eric-zhou/develop/yaozhou.github.io"
HTML_PATH="/home/eric-zhou/develop/jekyll-blog/_site"


cp -r "$PWD/_site" "$GITHUB_PATH"
cd "$GITHUB_PATH"
rm *.sh
git add .
git commit -a -m "normal modify"
git push origin master