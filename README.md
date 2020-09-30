# ncat-honeypot for ipset

Simple script-set for using ncat listener as honeypot for IPSet Iptables backend

*Auto Blacklist every attempt to reach port 22/tcp (ssh)

- port can be set in ncat-honeypot script
- ipset-report script is used to show statistics
- blacklist-check script can be used manually to find an IP in every configured IPSet lists
- Install.sh script is here for educational purpose on setting IPSet for Iptables and put scripts in place


minimum system impact (10 days working service):
```
USER    PID %CPU %MEM  START   TIME COMMAND
root  19824  0.0  0.0  sept.21 0:00 ncat...
```
KIS
