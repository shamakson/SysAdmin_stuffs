##!/bin/bash

echo "Author: Eric Samakinwa
Affiliation:University of Bern, Switzerland
contact: eric.samakinwa@giub.unibe.ch
10th September, 2020."

echo "$(tput setaf 1)Warning: Be aware that keyless logins is a security risk! 
       In particular, you should follow any security alerts from the administrators 
       of the respective machines carefully, and remove all 
       ssh-keys
       ~/.ssh/known_hosts
      ~/.ssh/authorized_keys
       on local and remote machines, if any of the machines is hacked!"

while true
do
  # (1) prompt user, and read command line argument
  read -p "$(tput setaf 3)Do you want to continue? Y or N: " answer

  # (2) handle the input we were given
  case $answer in
   [yY]* ) 
	   echo -n ubelix_username:
           read ubelix_username
           echo -n climstor_username:
	   read climstor_username
           echo "$(tput setaf 2)Thank you for confirming!"
           echo -ne '#####                     (33%)\r'
           sleep 1
           echo "press ENTER to skip passphrase"
 	   ssh-keygen -f $HOME/.ssh/paleo-ra_internal
           echo "press ENTER to skip passphrase"
           ssh-keygen -f $HOME/.ssh/paleo-ra_external
           chmod -R 700 ~/.ssh
           touch $HOME/.ssh/config
	   echo -ne '#############             (66%)\r'
           sleep 1
	   echo "Host submit03
     HostName submit02.ubelix.unibe.ch  
     User $ubelix_username  
     Port 22 
     IdentityFile ~/.ssh/paleo-ra_internal" > $HOME/.ssh/config 
	   echo "Host climstor climstor.giub.unibe.ch
     HostName climstor.giub.unibe.ch  
     User $climstor_username  
     Port 22 
     IdentityFile ~/.ssh/paleo-ra_external" >> $HOME/.ssh/config 
           cat .ssh/paleo-ra_internal.pub >> .ssh/authorized_keys
	   echo -ne '#######################   (100%)\r'
           echo -ne '\n'
           echo "Please enter your Climstor password below!!!"
           cat .ssh/paleo-ra_external.pub | ssh $climstor_username@climstor.giub.unibe.ch 'cat >> .ssh/authorized_keys'
	   echo "$(tput setaf 7)Thank you for your patience, you can now try to login to climstor by
                 simply typing "ssh climstor" to see if the installation is sucessful!" 

           break;;

   [nN]* ) echo -ne '#####                     (33%)\r'
	   sleep 1
           echo -ne '#############             (66%)\r'
           sleep 1
           echo -ne '#######################   (100%)\r'
           echo -ne '\n'
	   echo "$(tput setaf 7)Thanks, bye!."
           exit;;
   * )     ;;
  esac
done

