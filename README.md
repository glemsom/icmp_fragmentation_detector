# icmp_fragmentation_detector
Simple shell script to verify working ICMP type 3 code 4 fragmentation

# Usage
```
sudo bash icmp_fragmentation_test.sh
```
# Expected output should be similar to this:
```
	CheckHost:	icmpcheck.popcount.org
	URL:		http://icmpcheck.popcount.org/icmp
	Remote IP:	139.162.188.91
	Local IP:	192.168.50.190
	nic:		enp0s1 
Flushing existing route cache
Collecting data - this will take 10 seconds
reading from file test.pcap, link-type EN10MB (Ethernet), snapshot length 262144
ICMP Type 3 Code 4 received:	Yes


Incomming ICMP message:       139.162.188.91 > 192.168.50.190: ICMP 139.162.188.91 unreachable - need to frag (mtu 905), length 136
Inner header:                 192.168.50.190.41202 > 139.162.188.91.80: Flags [.], seq 1:1449, ack 1, win 502, options [nop,nop,TS val 3908916007 ecr 951470768], length 1448: HTTP, length: 1448
Inner Header, source IP:	 OK 
Inner header, destination IP:	 OK 


Incomming ICMP message:       139.162.188.91 > 192.168.50.190: ICMP 139.162.188.91 unreachable - need to frag (mtu 905), length 136
Inner header:                 192.168.50.190.41202 > 139.162.188.91.80: Flags [P.], seq 1449:2897, ack 1, win 502, options [nop,nop,TS val 3908916007 ecr 951470768], length 1448: HTTP
Inner Header, source IP:	 OK 
Inner header, destination IP:	 OK 


Incomming ICMP message:       139.162.188.91 > 192.168.50.190: ICMP 139.162.188.91 unreachable - need to frag (mtu 905), length 136
Inner header:                 192.168.50.190.41202 > 139.162.188.91.80: Flags [.], seq 2897:4345, ack 1, win 502, options [nop,nop,TS val 3908916007 ecr 951470768], length 1448: HTTP
Inner Header, source IP:	 OK 
Inner header, destination IP:	 OK 


Incomming ICMP message:       139.162.188.91 > 192.168.50.190: ICMP 139.162.188.91 unreachable - need to frag (mtu 905), length 136
Inner header:                 192.168.50.190.41202 > 139.162.188.91.80: Flags [P.], seq 4345:5793, ack 1, win 502, options [nop,nop,TS val 3908916007 ecr 951470768], length 1448: HTTP
Inner Header, source IP:	 OK 
Inner header, destination IP:	 OK 


Incomming ICMP message:       139.162.188.91 > 192.168.50.190: ICMP 139.162.188.91 unreachable - need to frag (mtu 905), length 136
Inner header:                 192.168.50.190.41202 > 139.162.188.91.80: Flags [.], seq 5793:7241, ack 1, win 502, options [nop,nop,TS val 3908916007 ecr 951470768], length 1448: HTTP
Inner Header, source IP:	 OK 
Inner header, destination IP:	 OK 


Incomming ICMP message:       139.162.188.91 > 192.168.50.190: ICMP 139.162.188.91 unreachable - need to frag (mtu 905), length 136
Inner header:                 192.168.50.190.41202 > 139.162.188.91.80: Flags [P.], seq 7241:8263, ack 1, win 502, options [nop,nop,TS val 3908916007 ecr 951470768], length 1022: HTTP
Inner Header, source IP:	 OK 
Inner header, destination IP:	 OK 
```
