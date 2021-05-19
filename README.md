RT-CyberShield
===============

Protecting Red Team infrastructure with red cyber shield. This simple bash script will block known ranges for cloud providers and some security vendors.

## Prerequisites for Debian/Ubuntu based installations
The script will execute the following to get necessary packages installed:
```
apt-get -y update
apt-get install -y ipset iptables curl fontconfig libfontconfig
```

## Prerequisites for Red Hat/Centos based installations
The script will execute the following to get necessary packages installed:
```
yum -y update
yum -y install ipset iptables curl fontconfig libfontconfig bzip2
```

## Installation
```
git clone git@github.com:snaij/RT-CyberShield.git
cd RT-CyberShield
chmod +x shieldme.sh
./shieldme.sh
```

## [shieldme.sh](shieldme.sh) filter rules

The following providers/IP ranges are currently blocked:

- Digital Ocean
- IBM
- Rackspace
- Verizon
- Cisco
- Symantec
- ForcePoint
- Palo Alto
- L3
- AWS
- TOR exit nodes
- Azure
- Cloudflare
- Avast
- Bitdefender
- Fireeye
- Fortinet
- Kaspersky
- ESET
- McAfee
- Sophos
- OVH
- WatchGuard
- Webroot
- Microsoft
- Rapid7
- Splunk
- Raytheon
- Mimecast
- Lockheed Martin
- Accenture
- KPMG
- BAE Systems
- F-Secure
- Trend Micro
- NCC
- eSentire
- Alibaba
- Hornetsecurity
- InteliSecure
- Masergy
- NTT Security
- Check Point
- Atos 
- CGI
- SecureWorks
- TCS
- Unisys

## CRON job

In order to auto-update the blocks, copy the following code into /etc/cron.d/update-cybershield. Don't update the list too often or some providers will ban your IP address. Once a week should be sufficient. 
```
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
MAILTO=root
0 0 * * 0      root /tmp/RT-CyberShield/shieldme.sh
```

## Check for dropped packets
Using iptables, you can check how many packets got dropped using the filters:
```
iptables -L INPUT -v --line-numbers
```

The table should look similar to this: 

```
Chain INPUT (policy ACCEPT 191 packets, 11656 bytes)
num   pkts bytes target     prot opt in     out     source               destination
1        0     0 DROP       all  --  any    any     anywhere             anywhere             match-set ncc src
2        0     0 DROP       all  --  any    any     anywhere             anywhere             match-set trendmicro src
3        0     0 DROP       all  --  any    any     anywhere             anywhere             match-set fsecure src
4        0     0 DROP       all  --  any    any     anywhere             anywhere             match-set bae src
5        0     0 DROP       all  --  any    any     anywhere             anywhere             match-set kpmg src
6        0     0 DROP       all  --  any    any     anywhere             anywhere             match-set accenture src
7        0     0 DROP       all  --  any    any     anywhere             anywhere             match-set lockheed src
8        0     0 DROP       all  --  any    any     anywhere             anywhere             match-set mimecast src
9        0     0 DROP       all  --  any    any     anywhere             anywhere             match-set raytheon src
10       0     0 DROP       all  --  any    any     anywhere             anywhere             match-set Rapid7 src
11       0     0 DROP       all  --  any    any     anywhere             anywhere             match-set Splunk src
12       0     0 DROP       all  --  any    any     anywhere             anywhere             match-set Microsoft src
13       0     0 DROP       all  --  any    any     anywhere             anywhere             match-set Webroot src
14       0     0 DROP       all  --  any    any     anywhere             anywhere             match-set WatchGuard src
15       0     0 DROP       all  --  any    any     anywhere             anywhere             match-set OVH src
16       0     0 DROP       all  --  any    any     anywhere             anywhere             match-set McAfee src
17       0     0 DROP       all  --  any    any     anywhere             anywhere             match-set Sophos src
18       0     0 DROP       all  --  any    any     anywhere             anywhere             match-set ESET src
19       0     0 DROP       all  --  any    any     anywhere             anywhere             match-set kaspersky src
20       0     0 DROP       all  --  any    any     anywhere             anywhere             match-set fortinet src
21       0     0 DROP       all  --  any    any     anywhere             anywhere             match-set fireeye src
22       0     0 DROP       all  --  any    any     anywhere             anywhere             match-set bitdefender src
23       0     0 DROP       all  --  any    any     anywhere             anywhere             match-set avast src
24       0     0 DROP       all  --  any    any     anywhere             anywhere             match-set l3 src
25       0     0 DROP       all  --  any    any     anywhere             anywhere             match-set barracuda src
26       0     0 DROP       all  --  any    any     anywhere             anywhere             match-set paloalto src
27       0     0 DROP       all  --  any    any     anywhere             anywhere             match-set forcepoint src
28       0     0 DROP       all  --  any    any     anywhere             anywhere             match-set symantec src
29       0     0 DROP       all  --  any    any     anywhere             anywhere             match-set rackspace src
30       0     0 DROP       all  --  any    any     anywhere             anywhere             match-set verizon src
31       0     0 DROP       all  --  any    any     anywhere             anywhere             match-set cisco src
32       0     0 DROP       all  --  any    any     anywhere             anywhere             match-set cloudflare4 src
33       0     0 DROP       all  --  any    any     anywhere             anywhere             match-set azure src
34       1    76 DROP       all  --  any    any     anywhere             anywhere             match-set digitalocean src
35       0     0 DROP       all  --  any    any     anywhere             anywhere             match-set ibm src
36       0     0 DROP       all  --  any    any     anywhere             anywhere             match-set aws src
37       1    76 DROP       all  --  any    any     anywhere             anywhere             match-set tor-individual-ip2 src
38       0     0 DROP       all  --  any    any     anywhere             anywhere             match-set tor-individual-ip1 src
```

## Modify the blacklists you want to use

Edit [shieldme.sh](shieldme.sh) and add/remove specific lists. You can see URLs which this script feeds from. Simply modify them or comment them out.
If you for some reason want to ban all IP addresses from a certain country, have a look at [IPverse.net's](http://ipverse.net/ipblocks/data/countries/) aggregated IP lists which you can simply add to the list already implemented. 

## I don't want to run this script

IP blocks do not change that often so just copy [ipset.conf](ipset-config/ipset.conf) to your local copy: 
```
cp ipset-config/ipset.conf /etc/ipset.conf
```
You will then need to run following commands to ensure that ranges are dropped via iptables: 
```
iptables -I INPUT -m set --match-set tor-individual-ip1 src -j DROP
iptables -I INPUT -m set --match-set tor-individual-ip2 src -j DROP
iptables -I INPUT -m set --match-set aws src -j DROP
iptables -I INPUT -m set --match-set ibm src -j DROP
iptables -I INPUT -m set --match-set digitalocean src -j DROP
iptables -I INPUT -m set --match-set azure src -j DROP
iptables -I INPUT -m set --match-set cloudflare4 src -j DROP
iptables -I INPUT -m set --match-set cisco src -j DROP
iptables -I INPUT -m set --match-set verizon src -j DROP
iptables -I INPUT -m set --match-set rackspace src -j DROP
iptables -I INPUT -m set --match-set symantec src -j DROP
iptables -I INPUT -m set --match-set forcepoint src -j DROP
iptables -I INPUT -m set --match-set paloalto src -j DROP
iptables -I INPUT -m set --match-set barracuda src -j DROP
iptables -I INPUT -m set --match-set l3 src -j DROP
iptables -I INPUT -m set --match-set avast src -j DROP
iptables -I INPUT -m set --match-set bitdefender src -j DROP
iptables -I INPUT -m set --match-set fireeye src -j DROP
iptables -I INPUT -m set --match-set fortinet src -j DROP
iptables -I INPUT -m set --match-set kaspersky src -j DROP
iptables -I INPUT -m set --match-set ESET src -j DROP
iptables -I INPUT -m set --match-set Sophos src -j DROP
iptables -I INPUT -m set --match-set McAfee src -j DROP
iptables -I INPUT -m set --match-set OVH src -j DROP
iptables -I INPUT -m set --match-set WatchGuard src -j DROP
iptables -I INPUT -m set --match-set Webroot src -j DROP
iptables -I INPUT -m set --match-set Microsoft src -j DROP
iptables -I INPUT -m set --match-set Splunk src -j DROP
iptables -I INPUT -m set --match-set Rapid7 src -j DROP
iptables -I INPUT -m set --match-set raytheon src -j DROP
iptables -I INPUT -m set --match-set mimecast src -j DROP
iptables -I INPUT -m set --match-set lockheed src -j DROP
iptables -I INPUT -m set --match-set accenture src -j DROP
iptables -I INPUT -m set --match-set kpmg src -j DROP
iptables -I INPUT -m set --match-set bae src -j DROP
iptables -I INPUT -m set --match-set fsecure src -j DROP
iptables -I INPUT -m set --match-set trendmicro src -j DROP
iptables -I INPUT -m set --match-set ncc src -j DROP
iptables -I INPUT -m set --match-set eSentire src -j DROP
iptables -I INPUT -m set --match-set alibaba src -j DROP
iptables -I INPUT -m set --match-set hornetsecurity src -j DROP
iptables -I INPUT -m set --match-set InteliSecure src -j DROP
iptables -I INPUT -m set --match-set Masergy src -j DROP
iptables -I INPUT -m set --match-set NTTSecurity src -j DROP
iptables -I INPUT -m set --match-set checkpoint src -j DROP
iptables -I INPUT -m set --match-set atos src -j DROP
iptables -I INPUT -m set --match-set CGI src -j DROP
iptables -I INPUT -m set --match-set SecureWorks src -j DROP
iptables -I INPUT -m set --match-set TCS src -j DROP
iptables -I INPUT -m set --match-set Unisys src -j DROP
```
## TODO
- [ ] IPv6 filter and ranges (ipset errors a lot right now)

## Limitations

- This script relies heavily on https://bgp.he.net portal.
- If you have VPS-To-VPS communication (i.e. Cobalt Strike to Fronting Server on OVH) the range might get blocked. Be careful where/how you set this script up or comment out specific ranges from config file
- The script relies on precompiled version of phantomjs
- Need some "for" loops in there. Its very crude script for now.
