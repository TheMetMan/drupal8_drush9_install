#!/bin/bash
#script from Drupal.org site Permissions document
# https://drupal.org/node/244924
#
# MUST be run a s root if changing ownership of files
#
echo "Setting Permissions and Ownership on this Site"
chown -Rv USER:GROUP .
echo "Setting all directories to 775"
find . -type d -exec chmod u=rwx,g=rx,o=rx '{}' \;
echo "Setting all files to 644"
find . -type f -exec chmod u=rw,g=r,o=r '{}' \;
echo "Special Permissions on config, private and files"
chmod 777 web/sites/default/files
find config -type d -exec chmod ug=rwx,o=rx '{}' \;
find config -type f -exec chmod ug=rw,o=r '{}' \;
chmod 770 private
echo "Setting settings.php and services.php file to 444"
chmod 640 web/autoload.php
chmod 444 web/sites/default/settings.php
chmod 444 web/sites/default/services.yml
chmod 444 web/.htaccess
chmod 644 private/.htaccess
chmod 444 .htaccess
chmod 444 web/sites/default/files/.htaccess
chmod u=rwx,g=rx,o=  vendor/drush/drush/drush
echo "Setting FixPermissions.sh to 750"
chmod 750 FixPermissions.sh

