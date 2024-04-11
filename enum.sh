#!/bin/bash

# Function to perform subdomain enumeration
enumerate_subdomains() {
    local target_domain="$1"
    
    # Run subfinder
    echo "Running subfinder..."
    subfinder -d "$target_domain" -all -recursive > sub.txt
    
    sleep 2

    # Run Sublist3r
    echo "Running Sublist3r..."
    sublist3r -n -d "$target_domain"
    
    sleep 2

    # Run github-subdomains
    echo "Running github-subdomains..."
    github-subdomains -d "$target_domain" -t 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,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,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
    
    sleep 2

    # Query crt.sh
    echo "Querying crt.sh..."
    curl -s "https://crt.sh/?q=%25.$target_domain&output=json" | jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u

    sleep 2

    # Query HackerTarget
    echo "Querying HackerTarget..."
    curl -s "https://api.hackertarget.com/hostsearch/?q=$target_domain" | sed 's/\.se.*/.se/' | sort -u >> sub.txt
    
# Merge and sort subdomains
cat sub.txt | grep -Eo "([a-zA-Z0-9._-]+\.)*$domain" | sort -u > subs.txt
sleep 1
rm sub.txt

    echo "Subdomain enumeration completed. Results saved in subs.txt"
}

# Main script
if [[ $# -eq 0 ]]; then
    echo "Usage: $0 -T <target_domain>"
    exit 1
fi

while getopts ":T:" opt; do
    case ${opt} in
        T )
            target_domain="${OPTARG}"
            enumerate_subdomains "$target_domain"
            ;;
        \? )
            echo "Invalid option: $OPTARG" 1>&2
            exit 1
            ;;
        : )
            echo "Invalid option: use $OPTARG nigger" 1>&2
            exit 1
            ;;
    esac
done
