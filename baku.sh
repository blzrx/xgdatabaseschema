#!/bin/bash
#
#Script by blzr
#
#this is used to work with xg firewall backups, over the 17.5 version
#
#
VERSION=1
#
#
#Ask the system if we are root user, since we avoid some access or permissions problems
#Actually im working to make this script root-less
#
#pre-execution verification
#
if [ "$(id -u)" != "0" ]; then
	echo "This script must be run as root!"
	echo "GoodBye ):"
	exit 1
else
	clear
	echo "We are root!"
        echo "########################"
        read -p "Press any key to continue the script"
fi
#
#
#True script starts here!
#
#
#
clear
PS3='Choose an action: '
options=("Decrypt" "Decompress" "Encrypt" "Compress" "Exit")
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
				done < <(find $dir2/ -maxdepth 1 -type f -name "*.*" -print0 )
			select opt3 in "${options[@]}" "Quit"; do
				case $opt3 in
				*.*)
					echo "File $opt3 Selected from list"
					echo "Decompressing..."
					tar -xvzf $opt3
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
					tar -zcvf encrypted.tgz $opt4
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
		"Exit")
			echo "GoodBye!"
			break
			;;
		*) echo "Invalid option, you selected $REPLY";;
	esac
done
