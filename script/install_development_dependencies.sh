#!/bin/bash

source ~/.bash_profile

local_folder=$(pwd)
RESULT=0

bundle install

for test_app in $(ls test_apps)
do
  cd $local_folder/test_apps/$test_app
  rvm use $(cat RUBY_VERSION)
  export BUNDLE_GEMFILE="$local_folder/test_apps/$test_app/Gemfile"
  rvm use $(cat RUBY_VERSION)
  bundle install 
  bundle exec rake db:create:all
  bundle exec rake db:migrate
  RESULT=$(($RESULT + $?))
done

if [ $RESULT == 0 ]
then
  exit 0
else
  exit 1
fi

