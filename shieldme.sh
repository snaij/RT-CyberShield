#!/bin/bash
# This script should be deployed on your red team infrastructure to protect you from these pesky blue teams
# Tested on Debian/Centos
# author: op7ic

# do installation based on which package manager is available.
if VERB="$( which apt-get )" 2> /dev/null; then
   apt-get -y update
   apt-get install -y ipset iptables curl fontconfig libfontconfig
elif VERB="$( which yum )" 2> /dev/null; then
   yum -y update
   yum -y install ipset iptables curl fontconfig libfontconfig bzip2
fi

echo [+] adding openssl fix as per https://github.com/drwetter/testssl.sh/issues/1117
export OPENSSL_CONF=~/bin/etc/openssl.cnf

echo [+] Dropping script for phantomjs

cat >> 7.js << EOF
var page = require('webpage').create();
var system = require('system'); 
url = system.args[1] 
page.settings.loadImages = false;
page.settings.userAgent = 'Mozilla/5.0 (iPhone; U; CPU iPhone OS 4_0 like Mac OS X; en-us) AppleWebKit/532.9 (KHTML, like Gecko) Version/4.0.5 Mobile/8A293 Safari/6531.22.7';
page.open(url, function(status) {
    if (status === "success") {
        setTimeout(function() {
            console.log(page.content);
            phantom.exit();
        },10000);
    }
});
EOF

declare -A array
array[tencent]="https://bgp.he.net/search?search[search]=tencent&commit=Search"
array[alibaba]="https://bgp.he.net/search?search%5Bsearch%5D=alibaba&commit=Search"
array[digitalocean]="https://bgp.he.net/search?search[search]=digitalocean&commit=Search"
array[rackspace]="https://bgp.he.net/search?search%5Bsearch%5D=rackspace+&commit=Search"


tar xvjf phantomjs/phantomjs-2.1.1-linux-x86_64.tar.bz2
rm -rf idcips.txt
for i in "${!array[@]}"; do
    echo [+] downloading blocks for $i addresses from "${array[$i]}"
    phantomjs-2.1.1-linux-x86_64/bin/phantomjs 7.js ${array[$i]} | grep "a href" | grep -v "AS" | grep net | awk -F ">" '{print $3}' | awk -F "<" '{print $1}' | grep "/" > $i.txt
    cat $i.txt >>idcips.txt
done

echo [+] removing phantomjs folder && rm -rf phantomjs-2.1.1-linux-x86_64
