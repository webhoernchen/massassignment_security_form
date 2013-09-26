#!/bin/bash

rvm get stable --auto-dotfiles
rvm reload
rvm --version | awk '{print $2}' | grep [0-9] > RVM_VERSION

# ruby
LATEST_REMOTE_RUBY_VERSION=$(rvm list known strings | grep "1.9.3" | sed "s/\[//g" | sed "s/\]//g" | grep -v "head" | grep -v "rc" | grep -v "preview" | sort -r | head -n 1)

if [[ $(rvm list strings | grep $LATEST_REMOTE_RUBY_VERSION) == '' ]]
then
  rvm install $LATEST_REMOTE_RUBY_VERSION --disable-binary && source $HOME/.rvm/scripts/rvm && rvm use $LATEST_REMOTE_RUBY_VERSION && gem install bundler
fi

source $HOME/.rvm/scripts/rvm
rvm use $LATEST_REMOTE_RUBY_VERSION --default
echo $LATEST_REMOTE_RUBY_VERSION > RUBY_VERSION

# rubygems
gem update --system
gem --version > GEM_VERSION

# bundler
gem update bundler
bundle --version | awk '{print $3}' > BUNDLER_VERSION

# bundle
bundle update

## javascript: jquery
#URL="http://code.jquery.com"
#wget $URL/jquery.min.js -O public/javascripts/jquery/jquery.min.js
#CURRENT_UI_PATH=$(wget $URL -O - | egrep '\/ui\/[0-9\.]+\/jquery-ui.min.js' | awk -F \" '{print $2}' | sort -Vr | head -n 1)
#wget $URL/$CURRENT_UI_PATH -O public/javascripts/jquery/jquery-ui.custom.min.js
#
## javascript: jeditable
#wget https://raw.github.com/tuupola/jquery_jeditable/master/jquery.jeditable.js -O public/javascripts/jquery/jquery.jeditable.js
#
## javascript: jquery form
#wget http://malsup.github.com/jquery.form.js -O public/javascripts/jquery/jquery.form.js
#
## javascript: jquery timepicker
#TIME_PICKER_URL="https://raw.github.com/trentrichardson/jQuery-Timepicker-Addon/master"
#wget $TIME_PICKER_URL/jquery-ui-timepicker-addon.js -O public/javascripts/jquery/jquery-ui-timepicker-addon.js
#wget $TIME_PICKER_URL/localization/jquery-ui-timepicker-de.js -O public/javascripts/jquery/jquery-ui-timepicker-de.js
#wget $TIME_PICKER_URL/jquery-ui-timepicker-addon.css -O public/stylesheets/jquery/timepicker-addon.css
#
#wget https://raw.github.com/jquery/jquery-ui/master/ui/i18n/jquery.ui.datepicker-de.js -O public/javascripts/jquery/jquery.ui.datepicker-de.js
#wget https://raw.github.com/jquery/jquery-ui/master/ui/i18n/jquery.ui.datepicker-en-GB.js -O public/javascripts/jquery/jquery.ui.datepicker-en-GB.js
#
## javascript: jquery livequery
#wget https://raw.github.com/brandonaaron/livequery/master/jquery.livequery.js -O public/javascripts/jquery/jquery.livequery.js

# javascript: ckeditor
# aktuelle Download-Url
#CKEDITOR_DOWNLOAD=$(wget http://ckeditor.com/download -O - | egrep -o "href=(\"|\')[^\"\']+download[^\"\']+(\"|\')" | grep tar | grep ckeditor | sort -r | head -n 1 | awk -F "(\"|\')" '{print $2}')
#
#if [[ $CKEDITOR_DOWNLOAD != '' && $(cat CKEDITOR_VERSION) != $CKEDITOR_DOWNLOAD ]]
#then
#  CKEDITOR_PATH="public/javascripts/ckeditor/"
#  CKEDITOR_TMP_PATH="/tmp/ckeditor_backup/"
#  # eigene Dateien sichern
#  mkdir -p $CKEDITOR_TMP_PATH
#  cp ${CKEDITOR_PATH}config.js ${CKEDITOR_TMP_PATH}
#  cp ${CKEDITOR_PATH}contents.css ${CKEDITOR_TMP_PATH}
#
#  # alten CKeditor entfernen
#  svn delete $CKEDITOR_PATH
#  svn commit $CKEDITOR_PATH -m "CKEditor für das Update entfernt"
#  # neue Version einfügen
#  wget $CKEDITOR_DOWNLOAD -O - | tar -xz -C public/javascripts/ 
#  rm $(find public -type f -name '\.htacc*' | grep -v svn)
#  svn add $CKEDITOR_PATH
#  svn commit $CKEDITOR_PATH -m "CKEditor aktualisiert"
#  # eigene Config wieder einspielen
#  cp ${CKEDITOR_TMP_PATH}config.js ${CKEDITOR_PATH}
#  cp ${CKEDITOR_TMP_PATH}contents.css ${CKEDITOR_PATH}
#  svn commit $CKEDITOR_PATH -m "CKEditor aktualisiert"
#
#  echo $CKEDITOR_DOWNLOAD > CKEDITOR_VERSION
#  NEW_CKEDITOR=1
#fi
#
# Firefox
#firefox -v > FIREFOX_BROWSER_VERSION
