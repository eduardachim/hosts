#!/bin/bash
cat /etc/hosts | while read ip nume rest; do
        [[ -z "$ip" || "$ip" == \#* ]] && continue
        [[ -z "$nume" ]] && continue
        [[ "$ip" == *:* || "$ip" == 127.* ]] && continue
        
        if ! nslookup "$nume" 8.8.8.8 | awk '/^Name:/ {r=1} r && /^Address:/ {print $2}' | grep -qx "$ip"; then
                echo "Bogus IP for $nume in /etc/hosts!"
        fi
done
