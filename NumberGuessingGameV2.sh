#!/bin/bash
clear

# colours
red='\033[1;31m'
green='\033[1;32m'
yellow='\033[1;33m'
blue='\033[1;36m'
nc='\033[0m'

# configs
data_folder=datas
data_folder_path="$(pwd)/${data_folder}"
highscore_file=highscore.txt
highscore_file_path="${data_folder_path}/${highscore_file}"
attempts=0

# initialize
echo -e "${blue}Initializing..."
echo ""
# data folder
if ! [ -d "$data_folder_path" ]; then mkdir "$data_folder_path"; fi
# highscore
if [[ -f "$highscore_file_path" && -s "$highscore_file_path" ]]; then
	highscore="$(sort -n "$highscore_file_path" | head -1)"
else
	highscore="--"
fi
# mode
echo -en $yellow
echo -e "[*]\tModes:"
echo -e "\t[$]\t${green}Easy${yellow}"
echo -e "\t[$]\t${green}Medium${yellow}"
echo -e "\t[$]\t${green}Hard${yellow}"
echo ""
echo -en "[*]\tEnter your mode: ${green}"
read -p "" mode
# max attempts
mode="${mode,,}"
case "$mode" in
	easy) max_attempts=15 ;;
	medium) max_attempts=10 ;;
	hard) max_attempts=7 ;;
	*) max_attempts=15; mode=easy ;;
esac
# secret
secret=$((RANDOM % 100 + 1))
start_time=$SECONDS

clear

echo -en "${blue}"
echo "================================"
echo "      NUMBER GUESSING GAME      " 
echo "================================"
echo -en "${nc}"
echo ""
echo -en "${yellow}"
echo -e "[*]\tI'm thinking of a number between 1 and 100."
echo -e "[*]\tYou have $max_attempts attempts. Good Luck!"
echo -en "$:\n\t[*] Highscore: "
echo -en $green
echo $highscore
echo -en $yellow
echo -en "\t[*] Mode: "
echo -en "$green"
echo $mode
echo ""

looper="Keep Looping"
while [ "$looper" = "Keep Looping" ]; do
	if [ $attempts -ge $max_attempts ]; then
		echo -en $red
		echo -e "[!]\tGame Over! You ran out of attempts."
		echo -en $blue
		echo -e "[0]\tThe number was $secret"
		looper="Stop"
		continue
	fi
	
	echo -en $yellow
	echo -en "[*]\tAttempt[$((attempts + 1))/$max_attempts] -- Enter your guess: "
	echo -en $green
	read -p "" guess

	if ! [[ $guess =~ ^[0-9]+$ ]]; then
		echo -en $red
		echo -e "[!]\tPlease Enter A Valid Number!"
		echo -e $nc
		continue
	fi

	((attempts++))

	if [[ $guess -lt $secret ]]; then
		echo -en $blue
		echo -e "[~]\tToo Low! Try Higher!"
	elif [[ $guess -gt $secret ]]; then
		echo -en $blue
		echo -e "[~]\tToo High! Try Lower!"
	else
		elasped=$((SECONDS - start_time))
		echo -en $green
		echo -e "[+]\tCORRECT! The number is $secret"
		echo -e "[+]\tYou guessed it in $attempts attempts"
		echo -e "[+]\tTime: $elasped seconds"
		if [[ $attempts -le 3 ]]; then
			echo -e "[+++]\tAmazing! You're a mind reader!"
		elif [[ $attempts -le 6 ]]; then
			echo -e "[++]\tGood Job! Solid Guess!"
		else
			echo -e "[+]\tYou made it!... barely."
		fi
		echo $attempts >> "$highscore_file_path"
		looper="Stop"
		continue
	fi
	echo ""
done
echo -en $yellow
echo -en "[*]\tPlay Again? (y/N)"
echo -en $green
read -p ": " again
if [[ $again = "y" || $again = "Y" ]]; then
	bash "$0"
fi
echo ""
echo THANKS FOR PLAYING!!!
