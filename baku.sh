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
	echo "Running over $(uname -a)"
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
			;;
		"Encrypt")
			echo "Encrypt has been selected"
			;;
		"Compress")
			echo "Compress has been selected"
			;;
		"Exit")
			echo "GoodBye!"
			break
			;;
		*) echo "Invalid option, you selected $REPLY";;
	esac
done
