#!/bin/bash
#
# https://github.com/TheMetMan/drupal8_install 
# 
# This is the Install script for a Composer/Drush Install for LOCAL SITE ONLY
#
# script to create a Drupal site for File Based Workflow in DocumentRoot web
# 
# The scripts, config file and base_files folder should be together
# perhaps in a folder such as ~/bin/drupal8 or some such
#
# make sure you have a MySql Database setup ready. Can be full or empty
#
# Edit the config.sh file with the correct information for your setup
# and run this script
#
# May  2017 Francis Greaves
# Nov  2018 Francis Greaves
#
askfg(){
  local REPLY
  while true; 
    do
        read -p "$1 [Y/n]" REPLY </dev/tty
        # Default is Y
        if [ -z "$REPLY" ]; then
          REPLY=Y
        fi
        # Check if the reply is valid
        case "$REPLY" in
          Y*|y*) return 0 ;;
          N*|n*) return 1 ;;
        esac
    done
}       # End of ask()
#
############ Import Config
configFile=config.cfg
if [ -e "$configFile" ]; then
  source $configFile
else
  echo "I cannot find the Config File $configFile"
  exit 1
fi
#-----------------------------------------------------------------------------
cd $apacheRoot
echo "----------- This is a Drupal Install using Composer and Drush ----------------"
echo "---------- with the DocumentRoot as $apacheRoot/$siteFolder/web --------------"
echo "                Installing to $apacheRoot/$siteFolder"
echo "we would recommend only using this for the Local Install NOT Dev or Production"
echo "                Make sure you have a database setup already"
echo "=============================================================================="
if [ -d "$siteFolder" ]; then
  echo "**** The Old Site Folder is still present ****"
  echo "     you will need to remove this site."
  echo "  So as ROOT rm -fvr $apacheRoot/$siteFolder"
  echo "           then re-run this script"
  echo "Quitting Install Drupal 8 for File Based Workflow"
  exit 1
fi
if askfg "Do you really want to continue?" ; then
    echo "Installing now"
  else
    exit 1
  fi
echo 'Downloading Drupal ....'
composer create-project drupal-composer/drupal-project:8.x-dev $siteFolder --stability dev --no-interaction
cd "$apacheRoot/$siteFolder"
composer install
composer update
echo
#echo "Removing Drush I have it installed globally"
#composer remove drush/drush
echo "create and copy .htaccess file to private folder"
mkdir private
cp "$workingFolder/base_files/htaccess" private/.htaccess
echo "create the other folders"
mkdir logs
configFolder=config
mkdir -p $configFolder/sync
mkdir $configFolder/active
cp "$workingFolder/base_files/htaccess" $configFolder/.htaccess
echo "set temporary permissions on sites/default"
chmod 777 web/sites/default
chmod 666 web/sites/default/d*
chmod 777 web/sites/default/files
chmod 777 private
echo 'Append Config Sync settings to default.settings.php file'
cat "$workingFolder/base_files/default.settings.xtra" >> ./web/sites/default/default.settings.php
cp ./web/sites/default/default.settings.php ./web/sites/default/settings.php
cp ./web/sites/default/default.services.yml ./web/sites/default/services.yml
cat "$workingFolder/base_files/default.services.xtra" >> ./web/sites/default/services.yml
cd web/
echo 'Install Site using Drush'
drush site-install standard \
--db-url="mysql://$dbUser:$dbPwd@localhost:3306/$db" \
--account-name=$acName \
--account-pass=$acPwd \
--account-mail=$acMail \
--site-name=$siteName \
--site-mail=$siteMail \
-y
echo
echo "copy useful files across and clean up a little"
cp "$workingFolder/base_files/FixPermissions" ../
cp "$workingFolder/base_files/backupEssentials" ../
cp "$workingFolder/base_files/gitignore" ../.gitignore
cp "$workingFolder/base_files/htaccess_docroot" ../.htaccess
cp "$workingFolder/base_files/*ConfigSync" ../

echo "adding Private Files Path and Trusted Hosts to settings.php file"
chmod 666 ./sites/default/settings.php
echo "\$settings['file_private_path'] = '$privatePath';" >> ./sites/default/settings.php
echo "\$settings['trusted_host_patterns'] = array('$trustedHosts',);" >> ./sites/default/settings.php 

echo "Creating a .htaccess access file in DocumentRoot to redirect Document Root to web"
sed -i 's/SITEFOLDER/'$siteFolder'/' ../.htaccess
sed -i 's/SITEFOLDER/'$siteFolder'/' exportConfigSync
echo "Updating FixPermissions User and Group"
sed -i 's/USER/'$apacheUser'/' ../FixPermissions
sed -i 's/GROUP/'$apacheGroup'/' ../FixPermissions
drush updb
drush cr
echo
cd "$apacheRoot/$siteFolder/"
echo "Copying a .gitignore file for you"
cp $workingFolder/base_files/gitignore .gitignore
echo
echo and creating a git repository
git init
echo "You need to Check, Add and Commit to repository"
echo
echo "now run FixPermissions as ROOT from the $apacheRoot/$siteFolder folder"
echo
echo "The $siteName Site should now be up and running so go the URL of the site"
echo "Test it out and login to check the Reports->Status Report and Reports->Log Messages then tidy it up"
echo 
echo "There is more info regarding a git workflow at http://themetman.net/content/drupal-cms"
echo
