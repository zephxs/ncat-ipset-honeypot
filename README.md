# ncat-honeypot for ipset

Simple Bash script-set for using ncat listener as honeypot for IPSet Iptables backend

### Auto Blacklist every attempt to reach port 22/tcp (ssh)

- port can be set in **ncat-honeypot** script
- **ipset-report** script is used to show statistics
- **blacklist-check** script can be used manually to find an IP in every configured IPSet lists
- **Install.sh** script is here for educational purpose to set IPSet for Iptables Blacklist and put scripts in place
- **ncat** package from the nmap team is used : `ncat` on debian, `nmap-ncat` on centos..


minimum system impact after 7 days:
```
USER    PID %CPU %MEM  START   TIME COMMAND
root  19824  0.0  0.0  sept.21 0:00 ncat...
```

ipset-report sample:

```
#######################################
####### configured ipset lists: #######
#######################################

...
#######################################
### IPSet list : geoblock
### - 66274 IP/subnets blocked
### - rejected traffic:
# >source
-Packets: 37431   -Bytes: 1904K
# >dest
-Packets: 663   -Bytes: 39780

#######################################
### IPSet list : honeypot
### - 152 IP/subnets blocked
### - rejected traffic:
# >source
-Packets: 5985   -Bytes: 353K
# >dest
-Packets: 1406   -Bytes: 69840

#######################################
### Blocklists chain global drop :
Chain INPUT (policy DROP 4684 packets, 271K bytes)
num   pkts bytes target     prot opt in     out     source               destination
1    1065K  310M blocklists  all  --  *      *       0.0.0.0/0            0.0.0.0/0
Chain OUTPUT (policy ACCEPT 0 packets, 0 bytes)
num   pkts bytes target     prot opt in     out     source               destination
1     766K  277M blocklists  all  --  *      *       0.0.0.0/0            0.0.0.0/0
Chain FORWARD (policy ACCEPT 0 packets, 0 bytes)
num   pkts bytes target     prot opt in     out     source               destination
1     603K  182M blocklists  all  --  *      *       0.0.0.0/0            0.0.0.0/0

#######################################
### blocked ip :
- 7 days ago: 21 IP addess blocked
- 6 days ago: 16 IP addess blocked
- 5 days ago: 14 IP addess blocked
- 4 days ago: 9 IP addess blocked
- 3 days ago: 10 IP addess blocked
- 2 days ago: 7 IP addess blocked
- 1 days ago: 13 IP addess blocked
- 0 days ago: 10 IP addess blocked

#######################################
```

KIS
