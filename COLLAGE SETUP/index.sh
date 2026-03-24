#!/bin/bash
# colours
red='\033[1;31m'
green='\033[1;32m'
yellow='\033[1;33m'
blue='\033[1;36m'
nc='\033[0m'

GET_DOC_PATHS() {
        local pths=("Documents" "Document")
        local concatpths=()
        for p in "${pths[@]}"; do
                concatpths+=("$HOME/$p")
        done
        printf '%s\n' "${concatpths[@]}"
}

DOC_EXISTS() {
        local -n p=$1
        for P in "${p[@]}"; do
                if [[ -d "$P" ]]; then
                        echo "$P"
                        return 0
                fi
        done
        echo -ne $red
        echo "[!] NO DOCUMENTS FOLDER FOUND"
        echo -e "[!] ${blue}\"FROM DEV\"${red}:\t AYO WTF!? WHAT OS DO YOU EVEN USE?? A BUCKET??"
        echo "[!] Terminating..."
        exit 1
}

CREATE() {
        local fp=$1
        local fn=$2
        if mkdir -p "$fp"; then
                echo -e "$green[+] CREATED: $fp"
        else
                echo -e "$red[!] ERROR CREATING: $fp"
                echo "[!] CANNOT CONTINUE. TERMINATING..."
                exit 1
        fi
}

CHECK() {
        local fp=$1
        local fn=$2
        if [[ -d "$fp" ]]; then
                echo -e "$green[+] $fp EXISTS"
        else
                echo -e "$red[!] $fp NOT FOUND"
                CREATE "$fp" "$fn"
        fi
}

LIST() {
        local -n fl=$1
        local fp=$2
        # macOS glob expansion needs nullglob to avoid literal glob strings
        local old_nullglob
        old_nullglob=$(shopt -p nullglob)
        shopt -s nullglob
        for f in "$fp"/*.c "$fp"/*.C; do
                [[ -f "$f" ]] && fl+=("$f")
        done
        eval "$old_nullglob"
}

DISPLAY() {
        local -n fl=$1
        if [[ ${#fl[@]} -eq 0 ]]; then
                echo -e "$red[!] NO .C FILES FOUND"
                return 1
        fi

        echo ""
        echo -e $blue
        echo "      .C FILES AVAILABLE      "
        echo "=============================="
        echo ""
        for i in "${!fl[@]}"; do
                echo -e "$yellow> [$((i + 1))] $green $(basename "${fl[$i]}")"
        done
        echo ""
        echo -ne $blue
        echo "=============================="
        echo ""
}

CR() {
        local sc=$1
        local output="$2/Program"

        # Detect compiler: prefer gcc if real gcc installed, fallback to clang (default on macOS)
        local compiler
        if command -v gcc &>/dev/null && gcc --version 2>&1 | grep -qv "clang"; then
                compiler="gcc"
        elif command -v clang &>/dev/null; then
                compiler="clang"
        else
                echo -e "$red[!] NO COMPILER FOUND. Install Xcode Command Line Tools:"
                echo -e "$yellow    xcode-select --install"
                exit 1
        fi

        echo ""
        echo -e "$blue[*] COMPILING: $(basename "$sc") with $compiler"
        if "$compiler" "$sc" -o "$output"; then
                echo -e "$green[+] COMPILED SUCCESSFULLY"
                echo -e $blue
                echo "      OUTPUT      "
                echo "=================="
                echo ""
                echo -e $nc
                "$output"
                echo ""
                echo -e $blue
                echo "=================="
                echo ""
        else
                echo -e "$red[!] COMPILATION FAILED"
        fi

        rm -rf "$output"
}

TITLE() {
        echo -e "$blue========================================"
        echo "|    Yo NIGGA == UR~ CoMPilEEER BOi    |"
        echo -e "========================================$nc"
        echo -e "$yellow[***] By YO Boiiii -- Lu$nc"
}

# Check bash version — macOS ships with bash 3.x by default which lacks nameref (-n)
if [[ "${BASH_VERSINFO[0]}" -lt 4 ]]; then
        echo -e "\033[1;31m[!] This script requires Bash 4.0 or later."
        echo -e "[!] macOS ships with Bash 3.x. Install a newer version via Homebrew:"
        echo -e "\033[1;33m    brew install bash"
        echo -e "    Then run: /opt/homebrew/bin/bash $(basename "$0")\033[0m"
        exit 1
fi

clear

mapfile -t DOC_PATHS < <(GET_DOC_PATHS)
DOC_PATH=$(DOC_EXISTS DOC_PATHS)
echo -e "$green[+] Documents Folder PATH: $DOC_PATH"
echo ""
TITLE
echo ""
echo -e "$green[!] All Folders and Files is stored in your \"Documents\" Folder${yellow}"
echo ""
echo -e "[*] Main Folder (default)\t: \"${green}COLLAGE 2026$yellow\""
echo -e "[*] Sub Folder (default)\t: \"${green}C$yellow\""
echo ""
echo "=============="
echo ""
echo -en "[*] Enter Main Folder Name      : $green"
read f_dir
echo -en $yellow
echo -en "[*] Enter Sub Folder Name       : $green"
read f_subDir
echo -e $yellow
fdp="$DOC_PATH/$f_dir"
fsdp="$fdp/$f_subDir"

CHECK "$fdp" "$f_dir"
CHECK "$fsdp" "$f_subDir"

while true; do
        clear
        c_files=()
        LIST c_files "$fsdp"
        DISPLAY c_files

        if [[ ${#c_files[@]} -eq 0 ]]; then
                echo -e "$red[!] ADD SOME .C FILES TO $fsdp"
                exit 1
        fi

        echo -en "$yellow[?] ENTER FILE NUMBER (1-${#c_files[@]}): $green"
        read choice

        if ! [[ "$choice" =~ ^[0-9]+$ ]] || [[ "$choice" -lt 1 ]] || [[ "$choice" -gt ${#c_files[@]} ]]; then
                echo -e "$red[!] INVALID CHOICE: $choice"
                sleep 1
                continue
        fi

        echo -ne $nc
        sf="${c_files[$((choice - 1))]}"
        CR "$sf" "$fsdp"

        echo ""
        echo -ne "$yellow[?] CONTINUE? (y/n): $green"
        read a
        if [[ "$a" = "Y" || "$a" = "y" ]]; then
                continue
        elif [[ "$a" = "n" || "$a" = "N" ]]; then
                echo ""
                echo -e "$green[+] TERMINATING. BYE!!!"
                echo ""
                exit 0
        else
                echo -e "$red[!] INVALID INPUT NIGGA. TERMINATING THE PROGRAMMMMM..."
                exit 1
        fi
done
