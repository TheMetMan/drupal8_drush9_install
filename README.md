# drupal8_drush9_install
Bash Script to install a new Drupal 8 site using Composer and Drush for File Based Workflow in a little over Three Minutes.
# Preamble
This project came from an attempt to develop a File Based Workflow for Drupal 8 and is developed from TheMetMan/drupal8_install also on GitHub. This one however used Drush version 9 and the drupal-composer/drupal-project for the download. 
There are various methods out there, many using Composer. Unfortunately Composer is very memory hungry and would not run in our Hosting service with limited memory. My friend Rob the Bones and I had to find a way to install a Drupal 8 site for File Based Workflow, but the method requires a particular order which we discovered by trial and error. So lots of Install, Rip Down and Start Again. Very time comsuming!!
We have found that installing Drupal 8 using Composer and Drush on the Local site, then Composer to update Locally. We then used Git to push/pull via a remote repo and this seemed to work well.
Drush 9 works well for syncing the sites, but we had to develop a method to prevent the site details overwriting each other. Not too dificult once the workflow was established and we discovered the drupal/config_ignore module.
This is why we developed this script which will Install a Drupal 8 Site to the location of your choice, and in only a little over three minutes.

# Requirements
This is for Linux Only. We have not considered Windows. It will probably work on a Mac, but we have not tested it.
You will need to have already installed Drush 9, Composer and Git globally.
You will also need a Virtual Host in the web Server (Apache)setup to match your site. Set the DocumentRoot to be the Install Folder.
The install puts a .htaccess file in the DocRoot to make the web/ folder the DocRoot and the correct setting in the sites/default/settings.php file to also make this work.
You will need a database (mysql) ready to accept the installation.

# Usage
Place the script and the base_files folder in a location of your choice eg ~/bin/drupal8_install
Edit the config.cfg file to put the correct variables for your location and site in place
Then make sure the createDrupalSite.sh script is executable

`chmod +x createDrupalSite.sh`

and execute like so:

`./createDrupalSite.sh`

Wait a little ......

# To Sync with Dev and Production
You can go [here](https://themetman.net/drupal-8-drush-git-development-workflow) to get more information on how to do this.
