#!/bin/bash

source "$HOME/.rvm/scripts/rvm"

set -e

local_folder=$(pwd)
RESULT=0

for test_app in $(ls test_apps | grep -vE 'rails_(2_3|3_0|3_1|3_2)')
do
  if [[ $RESULT == 0 ]]
  then
    echo $test_app
    cd $local_folder/test_apps/$test_app
    rvm use $(cat RUBY_VERSION)
    export BUNDLE_GEMFILE="$local_folder/test_apps/$test_app/Gemfile"
    bundle install
    bundle exec rake db:create:all
    bundle exec rake db:migrate
    bundle exec rake 
    RESULT=$(($RESULT + $?))
  fi
done

if [ $RESULT == 0 ]
then
  exit 0
else
  exit 1
fi
