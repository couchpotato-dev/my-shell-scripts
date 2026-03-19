#!/bin/bash


while true; do
	
	user="$(whoami)"
	uptime="$(uptime -p)"
	ip="$(hostname -I | awk '{print $1}')"
	cpu="$(top -bn1 | grep 'Cpu(s)' | awk '{print $2}')"
	ram_total_Gi="$(free -h | awk 'NR==2 {print $2}')"
	ram_used_Gi="$(free -h | awk 'NR==2 {print $3}')"
	ram_total_cal="$(free -m | awk 'NR==2 {print $2}')"
	ram_used_cal="$(free -m | awk 'NR==2 {print $3}')"
	ram_percentage="$(((ram_used_cal * 100) / ram_total_cal))%"
	disk_total="$(df -h / | awk 'NR==2 {print $2}')"
	disk_used="$(df -h / | awk 'NR==2 {print $3}')"
	disk_percentage="$(df -h / | awk 'NR==2 {print $5}')"
	cpu_int=${cpu%.*}
	bar=""
	for i in $(seq 1 20); do
    if [ $((i * 5)) -le $cpu_int ]; then
        bar="${bar}█"   # filled
    else
        bar="${bar}░"   # empty
    fi
done
	clear

	echo "=============================="
	echo "       SYSTEM DASHBOARD       "
	echo "=============================="
	echo ""
	echo "  [*]  User           : $user"
	echo "  [*]  Uptime         : $uptime"
	echo "  [*]  IP             : $ip"
	echo ""
	echo "  [*]  CPU            : $cpu%"
	echo "  [*]  RAM            : $ram_used_Gi / $ram_total_Gi (${ram_percentage})"
	echo "  [*]  Disk           : $disk_used / $disk_total ($disk_percentage)"
	echo ""
	echo "       refreshing every 1s | ctrl + c to exit"
	sleep 1
done
