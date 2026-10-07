# Exit codes:
#   0  term was found in the log
#   1  term was NOT found in the log
#   2  wrong number of arguments
#   3  log file does not exist
#   4  log file is not a regular file
#   5  log file is not readable
#   6  search term is empty


FIREWALL_LOG="case/logs/firewall.log"
IOC_FILE="intel/iocs.txt"

# Lab 7 risk thresholds for "Failed password" events
HIGH_THRESHOLD=15
MEDIUM_THRESHOLD=5
LOW_THRESHOLD=1

# Lab 7, Part 5 account lists (from what I can see, just says try it with alice etc....)
CURRENT_ACCOUNTS=(alice)
LEGACY_ACCOUNTS=(admin root backup oracle guest)


if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <log_file> <search_term>" >&2
    exit 2
fi

LOG_FILE="$1"
TERM_ARG="$2"

if [ ! -e "$LOG_FILE" ]; then
    echo "Error: '$LOG_FILE' does not exist." >&2
    exit 3
fi
if [ ! -f "$LOG_FILE" ]; then
    echo "Error: '$LOG_FILE' is not a regular file." >&2
    exit 4
fi
if [ ! -r "$LOG_FILE" ]; then
    echo "Error: '$LOG_FILE' is not readable." >&2
    exit 5
fi
if [ -z "$TERM_ARG" ]; then
    echo "Error: search term must not be empty." >&2
    exit 6
fi

# count_lines <pattern-file-or-stream>: grep -c prints 0 on no match (and
# returns 1), so I'm only keeping the number it prints.

classify_risk() {
    local n="$1"
    if   [ "$n" -ge "$HIGH_THRESHOLD" ];   then echo "HIGH"
    elif [ "$n" -ge "$MEDIUM_THRESHOLD" ]; then echo "MEDIUM"
    elif [ "$n" -ge "$LOW_THRESHOLD" ];    then echo "LOW"
    else echo "NONE"
    fi
}

in_array() {
    local needle="$1"; shift
    local item
    for item in "$@"; do
        [ "$item" = "$needle" ] && return 0
    done
    return 1
}

# Main code

TOTAL=$(grep -cwF -- "$TERM_ARG" "$LOG_FILE")
echo "=== Investigating '$TERM_ARG' in $LOG_FILE ==="
echo "Occurrences in log: $TOTAL"

if echo "$TERM_ARG" | grep -Eq '^[0-9]+(\.[0-9]+){3}$'; then
    echo "Type: IP address"

    FAILED=$(grep -F "Failed password" "$LOG_FILE" | grep -cwF -- "$TERM_ARG")
    RISK=$(classify_risk "$FAILED")
    echo "Failed password events: $FAILED  -> risk: $RISK"

    echo "--- Firewall lines ($FIREWALL_LOG) ---"
    if [ -r "$FIREWALL_LOG" ]; then
        if ! grep -wF -- "$TERM_ARG" "$FIREWALL_LOG"; then
            echo "(no firewall entries for this address)"
        fi
    else
        echo "(firewall log not found or unreadable)"
    fi

    echo "--- IOC list ($IOC_FILE) ---"
    if [ -r "$IOC_FILE" ]; then
        if grep -qxF -- "$TERM_ARG" "$IOC_FILE"; then
            echo "$TERM_ARG IS listed in the IOC list."
        else
            echo "$TERM_ARG is NOT listed in the IOC list."
        fi
    else
        echo "(IOC file not found or unreadable)"
    fi
else
    echo "Type: username"

    FAILED=$(grep -F "Failed" "$LOG_FILE" | grep -cwF -- "$TERM_ARG")
    ACCEPTED=$(grep -F "Accepted" "$LOG_FILE" | grep -cwF -- "$TERM_ARG")
    echo "Failed logins:   $FAILED"
    echo "Accepted logins: $ACCEPTED"

    if in_array "$TERM_ARG" "${CURRENT_ACCOUNTS[@]}"; then
        echo "Account status: CURRENT"
    elif in_array "$TERM_ARG" "${LEGACY_ACCOUNTS[@]}"; then
        echo "Account status: LEGACY"
    else
        echo "Account status: UNKNOWN"
    fi
fi

# Exit 0 if found, 1 if not
if [ "$TOTAL" -gt 0 ]; then
    exit 0
else
    echo "Result: term NOT found in log."
    exit 1
fi
