#!/bin/sh 

################################################################################
#                                                                              #
# Managing Local Group Account & Setting special permissions                   #
#==============================================================================#
#==============================================================================#
# This is useful if you want to create a directory that                        #
# should only be accessed by a specific number of people (sub-group)           #
################################################################################
# We add the users to a another subgroup, create directories & Set permissions #
#==============================================================================#
################################################################################

########################### ADD VARIABLES ######################################
									                                                             #
GROUPNAME=                                                                     #            
                                                                               #
DIRECTORYNAME=                               #full path (Absolute)             #
                                                                               #
#==============================================================================#
########################### ADD VARIABLES ######################################
#==============================================================================#
declare -a USERS_LIST=(user1 user2 user3)

## Create the directory you want to users to access

mkdir $DIRECTORYNAME

################################################################################
########################### ADD GROUP ########################################## 
# Add option [-g XXXX] if you want to specify Group ID: XXXX is group number   #
################################################################################
groupadd $GROUPNAME

################################################################################
#   Setting special permissions                                                #
#  (https://www.redhat.com/sysadmin/local-group-accounts)                      #
#==============================================================================#
# To set special permissions on a file or directory, you can utilize either of # 
# the two methods for standard permissions above: Symbolic or numerical.       #
# Let's assume that we want to set SGID on the directory community_content.    # 
# To do this using the symbolic method, we do the following:                   #
# shamakson@server$ chmod g+s community_content                                #
# Using the numerical method, we need to pass a fourth, preceding digit in our #
# chmod command. The digit used is calculated similarly to the standard        #
# permission digits:                                                           #
#    Start at 0                                                                #
#    SUID = 4                                                                  #
#    SGID = 2                                                                  #
#    Sticky = 1                                                                #
# chmod X### file or directory                                                 #
################################################################################
									       #
chmod 2770 -R $DIRECTORYNAME                                                   #
                                                                               # 
#==============================================================================#
#    Add users to group                                                        #
################################################################################
for user in "${USERS_LIST[@]}"                                                 #
do                                    					                               #
  usermod -a -G $GROUPNAME $user 					                                     #
done									                                                         #
################################################################################

exit 0
