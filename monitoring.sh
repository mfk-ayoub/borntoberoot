arch=$(uname -a)
ncpu=$(lscpu | grep 'Socket(s):'  | tr -d 'a-zA-Z(): ')
vcpu=$(lscpu | grep '^CPU(s):' | tr -cd '0-9' &&  printf '\n')
tram=$(free -m | grep Mem | tr -s ' ' | cut -d ' ' -f 2 | tr -d '[:alpha:]')
uram=$(free -m | grep Mem | tr -s ' ' | cut -d ' ' -f 3 | tr -d '[:alpha:]')
pram=$(printf "%.2f\n" "$(echo "scale=2; $uram * 100 / $tram" | bc)")

tdis=$(df -Bg --total | grep total | tr -s ' ' | cut -d ' ' -f 4 | tr -d '[:alpha:]')
udis=$(df -m --total | grep total | tr -s ' ' | cut -d ' ' -f 3 | tr -d '[:alpha:]')
pdis=$(df -m --total | grep total | tr -s ' ' | cut -d ' ' -f 5 | tr -d '[:alpha:]')
load=$(mpstat | grep "all " | awk '{printf "%.2f%%", 100 - $NF}')
lreb=$(uptime -s | cut -d ' ' -f 1,2 | cut -d ':' -f 1,2)
Ctcp=$(printf "%d ESTABLISHED\n" $(( $(ss --tcp | wc -l) - 1 )))
ulog=$(who | cut -d ' ' -f 1 | sort -u | wc -l)
ipad=$(hostname -I)
imac=$(ip link | grep ether | awk '{printf "(%s)", $2}')
ssud=$(journalctl _COMM=sudo -q | grep COMMAND | wc -l)
wall "
       #Architecture    : $arch
       #CPU physical    : $ncpu
       #vCPU            : $vcpu
       #Memory usage    : $uram/$tram"MB" ($pram%)
       #Disk usage      : $udis/$tdis"GB" ($pdis)
       #CPU load        : $load
       #last boot       : $lreb
    $(if cat /etc/fstab | grep -q mapper; then
echo "   #LVM use	     : yes"
     else
	echo "	#LVM use	: no"
     fi)
       #Connections TCP : $Ctcp
       #User log        : $ulog
       #Network         : IP $ipad $imac
       #Sudo            : $ssud "cmd"

