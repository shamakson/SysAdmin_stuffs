#!/bin/bash


# Flush filter table
iptables -F 

# Permit loopback interface
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# DROP INVALID PACKETS
iptables -A INPUT -m state --state INVALID -j DROP
iptables -A OUTPUT -m state --state INVALID -j DROP

# ALLOW icmp traffic

iptables -A INPUT -p icmp -j ACCEPT
iptables -A OUTPUT -p icmp -j ACCEPT

#allowed incoming tcp ports
PERMIT_TCP="20 21 465 80 443 110 143 993 44 2232 89 1111"

for port in $PERMIT_TCP
do
  echo "allowing port $port"
  iptables -A INPUT -p tcp --dport $port -j ACCEPT
  echo "done"
done

#allow incoming DNS Traffic
iptables -A INPUT -p udp --dport 53 -j ACCEPT

#IP addresses allowed to connect using ssh 
PERMIT_SSH="192.168.0.145 3.4.5.1 89.0.1.1 90.0.0.1"

for IP in $PERMIT_SSH 
do
	iptables -A INPUT -p tcp --dport 22 -s $IP -j ACCEPT
done

#permit no more that 50 concurent connections from the same ip address to our web server
iptables -A INPUT -p tcp -m multiport --dports 80,443 -m connlimit --connlimit-above 50 -j DROP

#permit all traffic from the following mac addresses
ALLOWED_MAC="08:00:27:65:5c:3c  08:00:27:65:5c:41  08:00:27:65:5c:ab  08:00:27:65:5c:23"
for MAC in $ALLOWED_MAC
do
	iptables -A INPUT -m mac --mac-source $MAC -j ACCEPT
done

#permit any packet on OUTPUT chain except INVALID
iptables -A OUTPUT -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT

#set default policy DROP
iptables -P INPUT DROP
iptables -P OUTPUT DROP

##############################################################################################
##############################################################################################
# USER DEFINED CHAINS REFACTORING                                                            #
##############################################################################################
##############################################################################################

# Clear Policy and User defined rules
iptables -F
iptables -X

# Allow all outgoing traffic (except invalid packets) 
iptables -A OUTPUT -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT

# Allow incoming ssh packets
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 22 -j ACCEPT

#create a new chain named ACCEPTED_MAC
iptables -N ACCEPTED_MAC

#add rules to the user defined-chain
iptables -A ACCEPTED_MAC -m mac --mac-source B8:81:98:22:C7:6B -j ACCEPT
iptables -A ACCEPTED_MAC -m mac --mac-source B8:81:98:22:C6:7C -j ACCEPT
iptables -A ACCEPTED_MAC -m mac --mac-source B8:81:98:22:23:AB -j ACCEPT
iptables -A ACCEPTED_MAC -m mac --mac-source B8:81:98:22:67:AA -j ACCEPT

# Jump from the INPUT chain to the user-defined chain
# now packets traverse the iptables rules in the user-defined chain
iptables -A INPUT -j ACCEPTED_MAC

iptables -P OUTPUT DROP
iptables -P INPUT DROP

# Allow only the return traffic on the INPUT chain
iptables -A OUTPUT -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT


# ALLOW SSH CONNECTIONS ONLY FROM ONE IP ADDRESS
# dropping incoming packets to port 22 except if they are coming from 80.0.0.1
iptables -A INPUT -p tcp --dport 22 -s 80.0.0.1 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 22 -d 80.0.0.1 -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -j DROP


iptables -P INPUT DROP
iptables -P OUTPUT DROP
