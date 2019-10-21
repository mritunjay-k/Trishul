#!/bin/bash

echo
echo "$(tput setaf 6)################################################"
echo "       _____ ___ ___ ___ _  _ _   _ _    
      |_   _| _ \_ _/ __| || | | | | |   
        | | |   /| |\__ \ __ | |_| | |__ 
        |_| |_|_\___|___/_||_|\___/|____|
                                    "
echo "################################################"
echo

if [[ $# -ne 1 ]]; then
	echo "Usage: ./trishul.sh <domain>"
	echo "Example: ./trishul.sh target.com"
	exit 1
fi

if [ ! -d "recon" ]; then
	mkdir recon
fi

if [[ -f "recon/alive_hosts" ]]; then
    rm recon/alive_hosts
fi

echo "$(tput setaf 6) Gathering subdomains with sublister..."
sublist3r -d $1 -o recon/all_hosts

echo 
echo "$(tput setaf 6)[i] Enumerating found subdomains for juicy info..."

for domain in $(cat recon/all_hosts); do
	response=`curl --head --location --connect-timeout 5 --write-out %{http_code} --silent --output /dev/null "$domain"`

	if [[ response -eq 000 ]]
    then
        echo "$(tput sgr0)[-] $domain -----> [Address Unresponsive]"
    else
        if [[ response -eq 404 ]]
        then
    		cname=`dig $domain | grep -m 1 CNAME | cut -f 5 | rev | cut -c 2- | rev`
    		if [[ -z "$cname" ]]
    		then
            	echo "$(tput setaf 2)[-] $domain ------> $response ------> CNAME: NOT FOUND"

            else
            	echo "$(tput setaf 1)[!] $domain ------> $response ------> CNAME:" $cname
            fi

        elif [[ response -eq 200 ]]
        then
        	mx=`dig $domain mx | grep MX | sed -n 2p | cut -f 6 | cut -c 3-`
        	if [[ -z "$mx" ]]
        	then
                echo "$(tput setaf 1)[!] $domain ------> $response ------> MX: NOT FOUND"
            else
            	echo "$(tput setaf 2)[i] $domain ------> $response ------> MX:" $mx
            fi
			echo "$domain" >> recon/alive_hosts

		else
			echo "$(tput setaf 2)[-] $domain -----> "$response
        fi
    fi
done

echo
echo "$(tput setaf 6)[i] Scanning every alive host for open ports..."
echo '[i] This may take a few minutes..!!'
nmap -iL recon/alive_hosts -oN recon/open_ports
