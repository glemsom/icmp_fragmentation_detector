#!/bin/bash
# Internet Control Mesage Protocol, type 3 code 4 (Fragmentation Neeed) tester
#
# Based on http://icmpcheck.popcount.org/
# By Glenn Sommer
#

checkHost=icmpcheck.popcount.org
url=http://${checkHost}/icmp
nic=$(ip route list|grep default|sed 's/.* dev //g'|awk '{print $1}') # Alternativly define statically, like eth0
myIp=$(ip addr show $nic | awk '/inet/ {print $2}'| head -n 1 | cut -d / -f 1)
colorOff='\033[0m'	# Reset color
colorRed='\033[0;31m'	# Red
colorGreen='\033[0;32m'	# Green

# Check we have the required tools installed
tools="curl tcpdump awk ip cut"
for tool in $tools; do
	command -v ${tool} 1>/dev/null || { echo "Error $tool not installed"; exit 1; }
done

# Generate payload
>tmpPayload
for x in {1..180}; do
	echo -n "packettoolongyaithuji6reeNab4XahChaeRah1diej4" >> tmpPayload
done

# Find ip of test host
ip=$(getent hosts icmpcheck.popcount.org | awk '{print $1}')

echo "	CheckHost:	$checkHost"
echo "	URL:		$url"
echo "	Remote IP:	$ip"
echo "	Local IP:	$myIp"
echo "	nic:		$nic"

# Check we can start tcpdump
if ! tcpdump -i ${nic} -c 1 -nn -w test.pcap > /dev/null 2>&1; then
	echo "Error, unable to start tcpdump from this user. Use sudo or similar to run this script"
	exit 1
fi

# Ensure we can flush the ip route cache
echo "Flushing existing route cache"
if ! ip route flush cache; then
	echo "Error, unable to flush ip route cache. Use sudo or similar to run this script"
	exit 1
fi

# Start a tcpdump, listening for icmp packages
( timeout 10 tcpdump -c 50 -i ${nic} -nn -w test.pcap host $ip ) > /dev/null 2>&1 &

sleep 1

# Start the curl provoking a fragmentation ICMP package
( curl  -v -s ${url} --data @tmpPayload ) > /dev/null 2>&1  &

echo "Collecting data - this will take 10 seconds"
sleep 10

result=$(tcpdump -nn -v -r test.pcap) >/dev/null 2>&1

# Check we receive the ICMP messages
echo -n "ICMP Type 3 Code 4 received:	"
if echo "${result}" | grep -q "ICMP ${ip} unreachable - need to frag"; then
	echo -e "${colorGreen}Yes${colorOff}"
else
	echo -e "${colorRed}NO${colorOff} ( ICMP blackhole detected) "
fi

echo
echo
# Check ICMP messages are correct
icmpLines=$(echo "${result}" | grep "ICMP ${ip} unreachable - need to frag" -A2 | grep -v "IP (tos")

IFS="
"
shopt -s extglob;

for icmpLine in $icmpLines; do
	case $icmpLine in
		*"unreachable"*) 
			echo -ne "Incomming ICMP message:   ${icmpLine}\n"
			;;
		*"${ip}.80"*)
			echo -ne "Inner header:             ${icmpLine}\n"
			tmpSource=$(echo $icmpLine | awk '{print $1}' | cut -d . -f 1-4)
			tmpDest=$(echo $icmpLine | awk '{print $3}' | cut -d . -f 1-4)
			echo -n "Inner Header, source IP:	"
			if [ "$tmpSource" == "$myIp" ]; then
				echo -e "${colorGreen} OK ${colorOff}"
			else
				echo -e "${colorRed} WRONG ${colorOff} ( Should have been $myIp - invalid network translation detected )"
			fi
			echo -n "Inner header, destination IP:	"
			if [ "$tmpDest" == "$ip" ]; then
				echo -e "${colorGreen} OK ${colorOff}"
			else
				echo -e "${colorRed} WRONG ${colorOff} ( Should have been $ip  - invalid network translation detected)"
			fi

			;;
		"--") 
			echo
			echo
			;;
	esac
done
