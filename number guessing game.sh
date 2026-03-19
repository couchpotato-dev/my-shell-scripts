#!/bin/bash

# colours
red='\033[1;31m'
green='\033[1;32m'
yellow='\033[1;33m'
blue='\033[1;36m'
nc='\033[0m'

# configs
secret=$((RANDOM % 100 + 1))
attempts=0
max_attempts=10
highscore_file='highscores.txt'
game_folder="$(pwd)/game_conf"
highscore=0

if ! [ -d "${game_folder}" ]; then mkdir -p "${game_folder}"; fi
if ! [ -f "${game_folder}/${highscore_file}" ]; then
        highscore=0
else
        highscore="$(sort -n "${game_folder}/${highscore_file}" | head -1)"
fi

clear

echo -e "${blue}============================"
echo -e "    NUMBER GUESSING GAME    "
echo -e "============================${nc}"
echo ""
echo -e "${yellow}[*]\tI'm thinking of a number between 1 and 100."
echo -e "[*]\tYou have $max_attempts attempts. Good Luck!"
echo -e "[*]\tHighscore:${green} $highscore ${nc}"
echo ""

while true; do
        if [ $attempts -ge $max_attempts ]; then
                echo -e "${red}[!]\tGame Over! You ran out of attempts."
                echo -e "${blue}[0]\tThe number was $secret"
                exit 1
        fi

        echo -ne "${yellow}[*]\tAttempt[$((attempts + 1))/$max_attempts] Enter your guess: ${nc}"
        read -p "" guess

        ((attempts++))

        if [ "$guess" -lt "$secret" ]; then
                echo -e "${blue}[~]\tToo low! Try higher!"
        elif [ "$guess" -gt "$secret" ]; then
                echo -e "${blue}[~]\tToo high! Try lower!"
        else
                echo -e "${green}[+]\tCORRECT! The number was $secret"
                echo -e "[+]\tYou guessed it in $attempts attempts"
                if [ $attempts -le 3 ]; then
                        echo "[***]\tAmazing! You're a mind reader!"
                elif [ $attempts -le 6 ]; then
                        echo -e "[**]\tGood Job! Solid guess!"
                else
                        echo -e "[*]\tYou made it!... Barely."
                fi
                echo $attempts >> "${game_folder}/${highscore_file}"
                exit 0
        fi
        echo ""
done
