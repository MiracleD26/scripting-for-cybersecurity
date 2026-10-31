#!/bin/bash

set -u

IOC_FILE="intel/iocs.txt"
MAX_MATCHES=3

if [ "$#" -ne 0 ]; then
    echo "usage: $0" >&2
    exit 2
fi

if [ ! -d case ] || [ ! -f "$IOC_FILE" ]; then
    echo "scan_all.sh: case/ or $IOC_FILE not found - run this from the lab10 directory" >&2
    exit 2
fi

TOTAL_MATCHES=0
LOGS_SCANNED=0

echo "=== IOC sweep over case/ ==="
echo

# Visit every log in the collection, including ones in nested directories.
while IFS= read -r -d '' LOG; do
    LOGS_SCANNED=$((LOGS_SCANNED + 1))

    LINES=$(wc -l < "$LOG" | tr -d '[:space:]')
    FAILED=$(grep -c "Failed password" "$LOG" 2>/dev/null || true)
    [ -n "$FAILED" ] || FAILED=0

    MATCHES=0
    MATCHED=""
    STOPPED_EARLY=""

    # Check every indicator in the intel file against this log.
    while IFS= read -r INDICATOR; do
        [ -z "$INDICATOR" ] && continue
        case "$INDICATOR" in \#*) continue ;; esac

        if grep -qwF -- "$INDICATOR" "$LOG"; then
            MATCHES=$((MATCHES + 1))
            MATCHED="$MATCHED $INDICATOR"

            # Stop checking this log once three indicators have matched.
            if [ "$MATCHES" -ge "$MAX_MATCHES" ]; then
                STOPPED_EARLY="yes"
                break
            fi
        fi
    done < "$IOC_FILE"

    echo "=== $LOG ==="
    echo "lines: $LINES"
    echo "failed logins: $FAILED"
    echo "IOC matches: $MATCHES"
    if [ -n "$MATCHED" ]; then
        echo "matched:$MATCHED"
    fi
    if [ -n "$STOPPED_EARLY" ]; then
        echo "note: check stopped early after $MAX_MATCHES indicators - more may be present"
    fi
    echo

    TOTAL_MATCHES=$((TOTAL_MATCHES + MATCHES))
done < <(find case -type f -name "*.log" -print0)

echo "=== summary ==="
echo "logs scanned: $LOGS_SCANNED"
echo "total IOC matches: $TOTAL_MATCHES"

if [ "$TOTAL_MATCHES" -gt 0 ]; then
    echo "verdict: indicators present - the collection needs investigating"
    exit 1
fi

echo "verdict: no indicators found - the collection looks clean"
exit 0
