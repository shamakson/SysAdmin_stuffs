##########################
## Getting info about the network interfaces (ifconfig, ip, route)
##########################
 
# displaying information about enabled interfaces
ifconfig



# displaying information about all interfaces (enabled and disabled)
ifconfig -a
ip address show

# displaying info about a specific interface
ifconfig enp0s3
ip addr show dev enp0s3
 
# showing only IPv4 info
ip -4 address

# showing only IPv4 info
ip -6 address
 
# displaying L2 info (including the MAC address)
ip link show
ip link show dev enp0s3
 
# displaying the default gateway
route 
route -n    # numerical addresses
ip route show
 
# displaying the DNS servers
systemd-resolve --status
 
 
##########################
## Setting the network interfaces (ifconfig, ip, route)
##########################
# disabling an interface
ifconfig enp0s3 down
ip link set enp0s3 down
 
# activating an interface
ifconfig enp0s3 up
ip link set enp0s3 up
 
# checking its status
ifconfig -a
ip link show dev enp0s3
 
# setting an ip address on an interface
ifconfig enp0s3 192.168.0.222/24 up
ip address del 192.168.0.111/24 dev enp0s3
ip address add 192.168.0.112/24 dev enp0s3
 
# setting a secondary ip address on sub-interface
ifconfig enp0s3:1 10.0.0.1/24
 
# deleting and setting a new default gateway
route del default gw 192.168.0.1
route add default gw 192.168.0.2
 
# deleting and setting a new default gateway
ip route del default
ip route add default via 192.168.0.1 	
 
# changing the MAC address
ifconfig enp0s3 down
ifconfig enp0s3 hw ether 08:00:27:51:05:a1
ifconfig enp0s3 up
 
# changing the MAC address
ip link set dev enp0s3 address 08:00:27:51:05:a3



##########################
## Network Static configuration using Netplan (Ubuntu)
##########################
 
# 1. Stop and disable the Network Manager
 
sudo systemctl stop NetworkManager
sudo systemctl disable NetworkManager
sudo systemctl status NetworkManager
sudo systemctl is-enabled NetworkManager
 
# 2. Create a YAML file in /etc/netplan
 
network:
  version: 2
  renderer: networkd
  ethernets:
    enp0s3:
      dhcp4: false
      addresses:
        - XXX.XX.XXX.XX/23
      gateway4: "XXX.XXX.X.1"
      nameservers:
        addresses:
          - "8.8.8.8"
          - "8.8.4.4"
          
OR          
          
 network:
  version: 2
  renderer:  NetworkManager
  ethernets:
    eth0:
      # Enable OR Disable DHCP
      dhcp4: yes
      dhcp6: no
      # Address configuration - multiple addresses can be added by adding a line 
      addresses:
        - XXX.XX.XXX.XX/23
      # Gateways
      gateway4: XXX.XX.XXX.1
      # Nameservers - you can add multiple lines
      nameservers:
        addresses:
          - XXX.XX.XXX.1
          - 8.8.8.8
        search: 
          - WEB.ch
          - WEB2.ch
 
# 3. Apply the new config
sudo netplan apply
 
# 4. Check the configuration
ifconfig
route -a


##########################
## OpenSSH
##########################
 
# 1. Installing OpenSSH (client and server)
# Ubuntu
sudo apt update && sudo apt install openssh-server openssh-client
 
# CentOS
sudo dnf install openssh-server openssh-clients
 
# connecting to the server
ssh -p 22 username@server_ip        # => Ex: ssh -p 2267 john@192.168.0.100
ssh -p 22 -l username server_ip
ssh -v -p 22 username@server_ip     # => verbose
 
# 2. Controlling the SSHd daemon
# checking its status
sudo systemctl status ssh       # => Ubuntu
sudo systemctl status sshd      # => CentOS
 
# stopping the daemon
sudo systemctl stop ssh       # => Ubuntu
sudo systemctl stop sshd      # => CentOS
 
# restarting the daemon
sudo systemctl restart ssh       # => Ubuntu
sudo systemctl restart sshd      # => CentOS
 
# enabling at boot time 
sudo systemctl enable ssh       # => Ubuntu
sudo systemctl enable sshd      # => CentOS
 
sudo systemctl is-enabled ssh       # => Ubuntu
sudo systemctl is-enabled sshd      # => CentOS
 
# 3. Securing the SSHd daemon
# change the configuration file (/etc/ssh/sshd_config) and then restart the server
man sshd_config
 
a) Change the port
Port 2278
 
b) Disable direct root login
PermitRootLogin no
 
c) Limit Users’ SSH access
AllowUsers stud u1 u2 john
 
d) Filter SSH access at the firewall level (iptables)
 
e) Activate Public Key Authentication and Disable Password Authentication
 
f) Use only SSH Protocol version 2
 
g) Other configurations:
ClientAliveInterval 300
ClientAliveCountMax 0
MaxAuthTries 2
MaxStartUps 3
LoginGraceTime 20

##########################
## Copying files using SCP and RSYNC
##########################
 
### SCP ###
# copying a local file to a remote destination
scp a.txt john@80.0.0.1:~
scp -P 2288 a.txt john@80.0.0.1:~       # using a custom port
 
# copying a local file from a remote destination to the current directory
scp -P 2290 john@80.0.0.1:~/a.txt .
 
# copying a local directory to a remote destination (-r)
scp -P 2290 -r projects/ john@80.0.0.1:~
 
 
### RSYNC ###
# synchronizing a directory
sudo rsync -av /etc/ ~/etc-backup/
 
# mirroring (deleting from destination the files that were deleting from source)
sudo rsync -av --delete /etc/ ~/etc-backup/
 
# excluding files
rsync -av --exclude-from='~/exclude.txt' source_directory/ destination_directory/
# exclude.txt:
# *.avi
# music/
# abc.mkv
 
rsync -av --exclude='*.mkv' --exclude='movie1.avi' source_directory/ destination_directory/
 
# synchronizing a directory over the network using SSH
sudo rsync -av -e ssh /etc/ student@192.168.0.108:~/etc-backup/ 
 
# using a custom port
sudo rsync -av -e 'ssh -p 2267' /etc/ student@192.168.0.108:~/etc-backup/ 

##########################
## WGET
##########################
# installing wget
apt install wget        # => Ubuntu
dnf install wget        # => CentOS
 
# download a file in the current directory
wget https://cdimage.kali.org/kali-2020.2/kali-linux-2020.2-installer-amd64.iso
 
# resuming the download 
wget -c https://cdimage.kali.org/kali-2020.2/kali-linux-2020.2-installer-amd64.iso
 
# saving the file into a specific directory
mkdir kali
wget -P kali/ https://cdimage.kali.org/kali-2020.2/kali-linux-2020.2-installer-amd64.iso
 
# limiting the rate (bandwidth)
wget --limit-rate=100k -P kali/ https://cdimage.kali.org/kali-2020.2/kali-linux-2020.2-installer-amd64.iso
 
# downloading more files 
wget -i urls.txt      # urls.txt contains urls
 
# starting the download in the background
wget -b -P kali/ https://cdimage.kali.org/kali-2020.2/kali-linux-2020.2-installer-amd64.iso
tail -f wget-log        # => checking its status
 
# getting an offline copy of a website
wget --mirror --convert-links --adjust-extension --page-requisites --no-parent http://example.org
wget -mkEpnp http://example.org
 
 
##########################
## NETSTAT and SS
##########################
# displaying all open ports and connections
sudo netstat -tupan
sudo ss -tupan
netstat -tupan | grep :80   # => checking if port 80 is open
 
##########################
## LSOF
##########################
# listing all files that are open
lsof
 
# listing all files opened by the processes of a specific user
lsof -u username
 
# listing all files opened by a specific process
lsof -c sshd
 
# listing all files that have opened TCP ports
lsof -iTCP -sTCP:LISTEN
lsof -iTCP -sTCP:LISTEN -nP
 
 
##########################
## Scanning hosts and networks using nmap
##########################
##** SCAN ONLY YOUR OWN HOSTS AND SERVERS !!! **##
## Scanning Networks is your own responsibility ##
 
# Syn Scan - Half Open Scanning (root only)
nmap -sS 192.168.0.1
 
# Connect Scan
nmap -sT 192.168.0.1
 
# Scanning all ports (0-65535)
nmap -p- 192.168.0.1
 
# Specifying the ports to scan
nmap -p 20,22-100,443,1000-2000 192.168.0.1
 
# Scan Version
nmap -p 22,80 -sV 192.168.0.1
 
# Ping scanning (entire Network)
nmap -sP 192.168.0.0/24
 
# Treat all hosts as online -- skip host discovery
nmap -Pn 192.168.0.0/24
 
# Excluding an IP
nmap -sS 192.168.0.0/24 --exclude 192.168.0.10
 
# Saving the scanning report to a file
nmap -oN output.txt 192.168.0.1
 
# OS Detection
nmap -O 192.168.0.1
 
# Enable OS detection, version detection, script scanning, and traceroute
nmap -A 192.168.0.1
 
# reading the targets from a file (ip/name/network separated by a new line or a whitespace)
nmap -p 80 -iL hosts.txt 
 
# exporting to out output file and disabling reverse DNS
nmap -n -iL hosts.txt -p 80 -oN output.txt
