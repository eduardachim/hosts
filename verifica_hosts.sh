#!/bin/bash
# verifica_ip NUME IP DNS
# verifică dacă IP-ul din /etc/hosts corespunde cu cel dat de serverul DNS
verifica_ip() {
    local nume="$1"
    local ip="$2"
    local dns="$3"
    local ip_real
    ip_real=$(nslookup "$nume" "$dns" 2>/dev/null | awk '/^Name:/ {r=1} r && /^Address:/ {print $2}')
    if echo "$ip_real" | grep -qx "$ip"; then
        return 0
    else
        echo "Bogus IP for $nume in /etc/hosts!"
        return 1
    fi
}

cat /etc/hosts | while read ip nume rest; do
    if [[ ! "$ip" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        continue
    fi
    if [[ "$ip" == 127.* ]]; then
        continue
    fi
    verifica_ip "$nume" "$ip" 8.8.8.8
done
