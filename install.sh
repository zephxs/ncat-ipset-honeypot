
#!/bin/bash

# check prerequisite
if ! command -v ipset &> /dev/null; then echo "ipset could not be found" && exit 1; fi
if ! command -v ncat &> /dev/null; then echo "ncat could not be found" && exit 1; fi

# IPTables create chain "blocklists"
Iptables -N blocklists
# make chain in 1st position :
# delete if needed : iptables -D INPUT -j blocklists
for _CHX in INPUT OUTPUT FORWARD; do
iptables -I "$_CHX" 1 -j blocklists
done
# create ipset list "honeypot"
ipset create honeypot ip:hash
# add ipset to the blocklists chain :
iptables -A blocklists -m set --match-set honeypot src -j DROP
iptables -A blocklists -m set --match-set honeypot dst -j DROP


mkdir /root/blacklist

cat > ncat-honeypot <<EOF
#!/bin/bash
# open ncat listener on port 22
while true; do
ncat -vl --keep-open 22 --exec "/usr/local/bin/honeypot-banscript" &>> /root/blacklist/honeypot.log 
done
EOF


cat > /usr/local/bin/honeypot-banscript <<EOF
#!/bin/bash
_XLOG="/root/blacklist/honeypot.log"
_XPOR="/root/blacklist/horny-banlist"
_TMP1=$(mktemp /root/blacklist/.hotmp1.XXX)
_TMP2=$(mktemp /root/blacklist/.hotmp2.XXX)

# get IP address from honeypot log
cat "\$_XLOG"|grep from > "\$_TMP1"
sed -i 's/Ncat\://g' "\$_TMP1"
cat "\$_TMP1"|grep ':'|awk '{print \$3}'|awk -F':' '{print \$1}'|uniq > "\$_TMP2"
# check if not already in a Blacklist and add to "honeypot" blacklist
for i in \$(cat "\$_TMP2"); do
blacklist-check \$i > /dev/null 2>&1 || ipset add honeypot "\$i" && echo "\$i ## \$(date)" >> "\$_XPOR"
done
EOF


cat > /usr/local/bin/blacklist-check <<EOF
#!/bin/bash
IP1=\$1
ipset list -terse|grep Name|grep -v white|awk '{print \$2}' >/root/blacklist/ipset-list

# Credits is_IP function :  https://github.com/marios-zindilis/Scripts/blob/master/Bash/is_ip.sh
function is_IP() {
if [ \$(echo "\$1" | grep -o '\.' | wc -l) -ne 3 ]; then
 echo "'\$1' does not look like an IP Address (does not contain 3 dots).";
 echo "### Usage ###"
 echo "\$(basename \$0) ip.ad.dr.es"
 exit 1;
elif [ \$(echo "\$1" | tr '.' ' ' | wc -w) -ne 4 ]; then
 echo "'\$1' does not look like an IP Address (does not contain 4 octets).";
 echo "### Usage ###"
 echo "\$(basename \$0) ip.ad.dr.es"
 exit 1;
else
for OCTET in \$(echo \$1 | tr '.' ' '); do
if ! [[ "\$OCTET" =~ ^[0-9]+\$ ]]; then
 echo "'\$1' is not an IP Address (octet '\$OCTET' is not numeric).";
 echo "### Usage ###"
 echo "\$(basename \$0) ip.ad.dr.es"
 exit 1;
elif [[ "\$OCTET" -lt 0 || "\$OCTET" -gt 255 ]]; then
 echo "'\$1' is not an IP Address (octet '\$OCTET' in not in range 0-255).";
 echo "### Usage ###"
 echo "\$(basename \$0) ip.ad.dr.es"
 exit 1;
fi
done
fi
return 0;
}

# Search for IP address in every blacklist configured in IPSET and exit 0 for scripts
if is_IP "\$IP1"; then
 for i in \$(cat /root/blacklist/ipset-list); do 
  ipset test \$i \$IP1 && exit 0
 done
else
 echo "### Usage ###"
 echo "\$(basename \$0) ip.ad.dr.es"
fi
EOF


cat > /etc/systemd/system/honeypot.service <<EOF
[Unit]
Description=honeypot ncat daemon
After=network.target syslog.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/ncat-honeypot
RemainAfterExit=true
ExecStop=/usr/local/bin/killhony
#StandardOutput=journal

[Install]
WantedBy=multi-user.target 
EOF

cat > /usr/local/bin/killhony <<EOF
#!/bin/bash
killall ncat-honeypot
EOF

systemctl daemon-reload
Systemctl start honeypot.service
