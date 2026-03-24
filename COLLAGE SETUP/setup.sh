#!/bin/bash






if ! [[ $USER = "root" ]]; then


	echo "[!] Root Previlages required"


	exit 1


fi





if sudo cp collage "/usr/local/bin"; then


	echo "[+] Setup Completed!"


else


	echo "[!] Error. Failed To Setup"


fi





rm -rf "$PWD"
0 commit commentsComments
