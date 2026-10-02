#!/bin/bash

# 1 & 2: need a filename argument
if [ $# -lt 1 ]; then
    echo "Usage: $0 <logfile>" >&2
    exit 1
fi

log="$1"

# 3: file must exist
if [ ! -f "$log" ]; then
    echo "Error: file not found: $log" >&2
    exit 2
fi

# 4: total failed password events (grep -c prints 0 if none)
echo "Total failed password events: $(grep -c 'Failed password' "$log")"

# 5: single IP with the most failed attempts
echo "Top attacker IP:"
grep 'Failed password' "$log" \
    | grep -oE 'from [0-9.]+' \
    | awk '{print $2}' \
    | sort | uniq -c | sort -rn | head -1 | awk '{print $2}'

# 6: three busiest source IPs, reusing top3.sh
echo "Three busiest source IPs:"
"$(dirname "$0")/top3.sh" "$log"

# 7: three most-targeted usernames
echo "Three most-targeted usernames:"
grep 'Failed password' "$log" \
    | sed -nE 's/.*Failed password for (invalid user )?([^ ]+) from .*/\2/p' \
    | sort | uniq -c | sort -rn | head -3

# 8: success
exit 0
