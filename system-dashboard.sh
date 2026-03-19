#!/bin/bash
red='\033[1;31m'
green='\033[1;32m'
yellow='\033[1;33m'
blue='\033[1;36m'
nc='\033[0m'
while true; do
    user="$(whoami)"
    uptime="$(uptime -p)"
    ip="$(hostname -I | awk '{print $1}')"
    cpu="$(top -bn1 | grep 'Cpu(s)' | awk '{print $2}')"
    ram_total_Gi="$(free -h --giga | awk 'NR==2 {print $2}')"
    ram_used_Gi="$(free -h --giga | awk 'NR==2 {print $3}')"
    ram_total_cal="$(free -m | awk 'NR==2 {print $2}')"
    ram_used_cal="$(free -m | awk 'NR==2 {print $3}')"
    ram_percentage="$(( (ram_used_cal * 100) / ram_total_cal ))%"
    disk_total="$(df -h / | awk 'NR==2 {print $2}')"
    disk_used="$(df -h / | awk 'NR==2 {print $3}')"
    disk_percentage="$(df -h / | awk 'NR==2 {print $5}')"
    cpu_int=${cpu%.*}
    ram_int=${ram_percentage%\%}
    disk_int=${disk_percentage%\%}
    bar_cpu="" bar_ram="" bar_disk=""
    for i in $(seq 1 20); do
        if [[ $((i * 5)) -le $cpu_int ]];  then bar_cpu="${bar_cpu}█";  else bar_cpu="${bar_cpu}░";   fi
        if [[ $((i * 5)) -le $ram_int ]];  then bar_ram="${bar_ram}█";  else bar_ram="${bar_ram}░";   fi
        if [[ $((i * 5)) -le $disk_int ]]; then bar_disk="${bar_disk}█"; else bar_disk="${bar_disk}░"; fi
    done
    clear
    echo -e "${blue}=============================="
    echo -e "       SYSTEM DASHBOARD       "
    echo -e "==============================${nc}"
    echo ""
    echo -e "${yellow}  [*]  User           : ${green}$user"
    echo -e "${yellow}  [*]  Uptime         : ${green}$uptime"
    echo -e "${yellow}  [*]  IP             : ${green}$ip"
    echo ""
    echo -e "${yellow}  [*]  CPU            : ${green}[${bar_cpu}] $cpu%"
    echo ""
    echo -e "${yellow}  [*]  RAM            : ${green}[${bar_ram}] $ram_used_Gi / $ram_total_Gi ($ram_percentage)"
    echo ""
    echo -e "${yellow}  [*]  Disk           : ${green}[${bar_disk}] $disk_used / $disk_total ($disk_percentage)"
    echo ""
    echo -e "${blue}       refreshing every 1s | ctrl+c to exit${nc}"
    sleep 1
done

# By me Hehehehehehee
