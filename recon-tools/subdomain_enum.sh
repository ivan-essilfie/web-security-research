#!/bin/bash

url=$1

if [ ! -d "$url" ];then
        mkdir $url
fi

if [ ! -d "$url/recon" ];then
        mkdir $url/recon
fi

if [ ! -d "$url/recon/httprobe" ];then
        mkdir $url/recon/httprobe
fi

echo "[+] Harvesting subdomains with assetfinder..."
assetfinder $url >> $url/recon/assets.txt
cat $url/recon/assets.txt | grep $1 >> $url/recon/final.txt
rm $url/recon/assets.txt

echo "[+] Probing for alive domains..."
cat $url/recon/final.txt | sort -u | httprobe -s -p https:443 | sed 's/https\?:\/\///' | tr -d ':443' >> $url/recon/httprobe/a.txt
sort -u $url/recon/httprobe/a.txt > $url/recon/httprobe/alive.txt
rm $url/recon/httprobe/a.txt
