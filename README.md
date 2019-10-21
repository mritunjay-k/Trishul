# Trishul
Automated recon for web application bug hunting.

# Usage
`./trishul.sh target.com`

[example link](http://example.com/)

# Dependencies
- [Nmap](https://nmap.org/download.html)
- [Sublist3r](https://github.com/aboul3la/Sublist3r)
- [curl](https://curl.haxx.se/download.html)
- [dig](https://toolbox.googleapps.com/apps/dig/)
- [BASH](https://www.linux.org/pages/download/)

# About
This tool is written in bash. It helps in gaining some serious information about an intended target. This tool automates the first step of every bug hunters' approach. 

# Features
1. Gathers all the subdomains using sublist3r.
2. Separates the alive hosts from the list of subdomains.
3. Checks the mx records for the alive hosts.
4. Checks the cname records for 404 not-found hosts.
5. Scans each alive host for open ports using nmap. 
6. Creates a new directory (over-writes if previously present) named recon (in the present working directory), containing text files named all_hosts, alive_hosts and open_ports (which depicts the original purpose of their presence).

#### Happy Hunting :)
