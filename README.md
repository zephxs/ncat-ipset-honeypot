# ncat-honeypot for ipset/iptables firewall

Simple Bash script-set for using ncat listener as honeypot for IPSet Iptables firewall backend.

### Auto Blacklist every attempt to reach port 22/tcp (ssh)

- Use **ncat** package from the nmap team : `ncat` on debian, `nmap-ncat` on centos..
- port can be set in **ncat-honeypot** script
- **blacklist-check** script can be used manually to find an IP in every configured IPSet lists
- **ipset-report** script is used to show statistics
- **Install.sh** script is here for educational purpose to set IPSet for Iptables Blacklist and put scripts in place


minimum system impact after 7 days on a frontal reverse proxy server:
```
USER  PID    %CPU %MEM  START   TIME COMMAND
root  15243  0.0  0.0   déc.08  0:00 ncat -vl --keep-open 22 --exec /usr/local/bin/honeypot-banscript
```

ipset-report script output sample:

```
#######################################
####### configured ipset lists: #######
#######################################
...
#######################################
### IPSet list : geoblock
### - 66275 IP/subnets blocked
### - rejected traffic:
# >source
-Packets: 19201   -Bytes: 1186K
# >dest
-Packets: 10   -Bytes: 842

#######################################
### IPSet list : hony
### - 976 IP/subnets blocked
### - rejected traffic:
# >source
-Packets: 3455   -Bytes: 199K
# >dest
-Packets: 784   -Bytes: 40644

#######################################
### Blocklists chain global drop :

Chain INPUT (policy DROP 11372 packets, 853K bytes)
num   pkts bytes target     prot opt in     out     source               destination
1     799K  192M blocklists  all  --  *      *       0.0.0.0/0            0.0.0.0/0
Chain OUTPUT (policy ACCEPT 1309K packets, 1318M bytes)
num   pkts bytes target     prot opt in     out     source               destination
1    1310K 1318M blocklists  all  --  *      *       0.0.0.0/0            0.0.0.0/0
Chain FORWARD (policy DROP 105 packets, 6696 bytes)
num   pkts bytes target     prot opt in     out     source               destination
1     638K 1203M blocklists  all  --  *      *       0.0.0.0/0            0.0.0.0/0
#######################################
### blocked ip the last days :
- 7 days ago: 9 IP addess blocked
- 6 days ago: 6 IP addess blocked
- 5 days ago: 8 IP addess blocked
- 4 days ago: 8 IP addess blocked
- 3 days ago: 15 IP addess blocked
- 2 days ago: 14 IP addess blocked
- 1 days ago: 12 IP addess blocked
- 0 days ago: 0 IP addess blocked
#######################################
```

KIS
