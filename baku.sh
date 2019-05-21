#!/bin/bash
#
#Script by blzr, 2019
#
#This is used to work with xg firewall backups, over the 17.5 version
#Mainly designed to avoid problems while working with raw backups
#
#
#Version variable is used to update the script over the internet
#it compares against a script mantained over github, doing a grep over this varibale
#compares the local vs the web version, if the last is greater, a update is triggered
#
#You can safely set this variable to 1 if you want to force a update or 100 if you want to never update
VERSION=2
#
#NOTES=
#V1 First public release, first patch
#V2 Fixes variables passing over the whole script
#V3 Fixes typo errors over the script
#
#######################################################################################
#Ask the system if we are root user, since we avoid some access or permissions problems
#Actually im working to make this script root-less
#######################################################################################
#pre-execution verification
#######################################################################################
if [ "$(id -u)" != "0" ]; then
	echo "This script must be run as root!"
	echo "GoodBye ):"
	exit 1
else
	clear
	echo "We are root!"
	echo "Running over $(hostname)"
        read -p "Press any key to continue the script"
fi
#######################################################################################
#
#True script starts here!
#
#
#######################################################################################
#Menu initialization, we present the whole options to the user under a do and select loop
#then every option has his own submenu, making the whole process a little more interactive
#for the user, every break statement is used to stop the loop
#
#this could be upgraded to a C version of the same script, this is WIP.
#
clear
PS3='Choose an action: '
options=("Decrypt" "Decompress" "Encrypt" "Compress" "Update" "Exit")
select opt in "${options[@]}"
do
	case $opt in 
		"Decrypt")
			clear
			echo "Decrypt has been selected"
			dir=$(pwd)
			unset options i
			while IFS= read -r -d $'\0' f; do
				options[i++]="$f"
				done < <(find $dir/ -maxdepth 1 -type f -name "*.*" -print0 )
			select opt2 in "${options[@]}" "Quit"; do
				case $opt2 in
				*.*)
					echo "File $opt2 Selected from list"
					read -p "Enter password for file $opt2: " decpass
					echo "Decrypting..."
					openssl enc -d -aes-256-cbc -in $opt2 -out decrypted.tgz -md md5 -pass pass\:$decpass
					exit 1
				;;
				"Quit")
					echo "Exiting..."
					exit 1
				;;
				*)
					echo "Invalid option!"
				;;
				esac
			done
			;;
		"Decompress")
			echo "Decompress has been selected"
			dir2=$(pwd)
			unset options i
			while IFS= read -r -d $'\0' f; do
				options[i++]="$f"
				done < <(find $dir2 -maxdepth 1 -type f -name "*.tgz" -print0 )
			select opt3 in "${options[@]}" "Quit"; do
				case $opt3 in
				*.tgz)
					echo "File $opt3 Selected from list"
					echo "Decompressing..."
					tar -xvzf $opt3
					chmod 777 conf/
					exit 1
				;;
				"Quit")
					echo "Exiting..."
					exit 1
				;;
				*)
					echo "Invalid option!"
				;;
				esac
			done
			;;
		"Compress")
			echo "Compress has been selected"
			echo "Please select the root conf folder, otherwise this will not work as expected"
			dir3=$(pwd)
			unset options i
			while IFS= read -r -d $'\0' f; do
				options[i++]="$f"
				done < <( find $pwd -maxdepth 1 -type d -name "conf" -print0  )
			select opt4 in "${options[@]}" "Quit"; do
				case $opt4 in
				*.*)
					echo "Folder $opt4 Selected from list"
					echo "Decompressing..."
					tar -zcvf EncryptMe.tgz $opt4
					exit 1
				;;
				"Quit")
					echo "Exiting..."
					exit 1
				;;
				*)
					echo "Invalid option!"
				;;
				esac
			done
			;;
		"Encrypt")
			echo "Encrypt has been selected"
			echo "Select a valid .tgz file to encrypt from the following list: "
			dir4=$(pwd)
			unset options i
			while IFS= read -r -d $'\0' f; do
				options[i++]="$f"
				done < <(find $dir4/ -maxdepth 1 -type f -name "*.tgz" -print0 )
			select opt5 in "${options[@]}" "Quit"; do
				case $opt5 in
				*.tgz)
					echo "File $opt5 Selected from list"
					echo "Encrypting..."
					echo "You will be prompted for a password!"					
					openssl enc -aes-256-cbc -md md5 -in $opt5 -out backup.conf
					exit 1
				;;
				"Quit")
					echo "Exiting..."
					exit 1
				;;
				*)
					echo "Invalid option!"
				;;
				esac
			done
			;;
		"Update")
			#Create latest version variable
			UPDATEABLE=$(curl --silent https://raw.githubusercontent.com/blzrx/xgdatabaseschema/master/baku.sh | grep 'VERSION=[-0-9]' | cut -d "=" -f 2)
			echo "Checking updates over the Github Repo..."
				if [ "$VERSION" -lt "$UPDATEABLE"  ]
					then
    						echo "There's a update!"
							unset options i
							select opt10 in "Update" "Do Nothing"; do
							case $opt10 in
								"Update")
									echo "Updating..."
									rm baku.sh
									wget https://raw.githubusercontent.com/blzrx/xgdatabaseschema/master/baku.sh
									chmod 777 baku.sh
									chmod +x baku.sh
									exit 1
								;;
								"Do Nothing")
									echo "Didnt Any changes..."
								;;
								*)
									echo "Invalid option!"
								;;
							esac
			done
					else [ "$VERSION" -gt "$UPDATEABLE"  ]
						echo "You are running the latest version of this script"
				fi
			break
			;;
		"Exit")
			echo "GoodBye!"
			break
			;;
		*) echo "Invalid option, you selected $REPLY";;
	esac
done
