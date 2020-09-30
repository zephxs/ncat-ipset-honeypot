# ncat-honeypot for ipset

Script set for using simple ncat listener as honeypot for IPSet Iptables backend

*Auto Blacklist every attempt to reach port 22/tcp (ssh)

- port can be set in ncat-honeypot script
- ipset-report script is used to show statistics
- blacklist-check script can be used manually to find an IP in every configured IPSet lists
- Install.sh script is here for educational purpose on setting IPSet for Iptables and put scripts in place
