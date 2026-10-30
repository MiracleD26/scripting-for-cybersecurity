#!/bin/bash
#
# file_survey.sh - Lab 09, Part 7: Investigation Challenge.

set -u

if [ "$#" -ne 0 ]; then
    echo "usage: $0" >&2
    exit 2
fi

IOC_FILE="intel/iocs.txt"

if [ ! -d case/evidence ] || [ ! -d case/scripts ] || [ ! -d case/logs ]; then
    echo "file_survey.sh: case/ not found - run this from the lab09 directory" >&2
    exit 1
fi

# ---- intel ----

IOCS=()
if [ -f "$IOC_FILE" ]; then
    while IFS= read -r IND || [ -n "$IND" ]; do
        IND=${IND%$'\r'}
        case "$IND" in
            ''|'#'*) continue ;;
        esac
        IOCS+=("$IND")
    done < "$IOC_FILE"
else
    echo "file_survey.sh: warning: $IOC_FILE not found - IOC counts will be 0" >&2
fi
IOC_COUNT=${#IOCS[@]}

sha256_of() {
    if command -v sha256sum >/dev/null 2>&1; then
        sha256sum -- "$1" | cut -d' ' -f1
    else
        shasum -a 256 -- "$1" | cut -d' ' -f1
    fi
}

SURVEYED=0
FLAGGED=0
IOC_INDICATORS=0
IOC_MATCHES=0

# ----- survey ----
for DIR in case/evidence case/scripts case/logs; do
    for FILE in "$DIR"/*; do
        # 1. Regular files only.
        [ -f "$FILE" ] || continue

        SURVEYED=$((SURVEYED + 1))

        TYPE=$(file -b "$FILE")
        SIZE=$(wc -c < "$FILE" | tr -d '[:space:]')

        # 2. File name, size and detected type.
        echo "=== $FILE ==="
        echo "size: $SIZE bytes"
        echo "type: $TYPE"

        # 3. Line count, only when file -b reports text.
        if [[ "$TYPE" == *text* ]]; then
            echo "lines: $(wc -l < "$FILE" | tr -d '[:space:]')"
        fi

        # 4. SHA-256 hash.
        echo "sha256: $(sha256_of "$FILE")"

        # 5. Extension vs detected type (magic_check.sh logic and the
        #    .sh/.py expectations from the earlier exercise).
        EXPECT=""
        case "$FILE" in
            *.png)      EXPECT="PNG" ;;
            *.zip)      EXPECT="Zip" ;;
            *.txt|*.md) EXPECT="text" ;;
            *.sh)       EXPECT="shell script" ;;
            *.py)       EXPECT="Python script" ;;
        esac

        if [ -z "$EXPECT" ]; then
            echo "extension check: ?? no expectation for this extension"
        elif [[ "$TYPE" == *"$EXPECT"* ]]; then
            echo "extension check: OK ($EXPECT)"
        else
            echo "extension check: !! expected $EXPECT, detected: $TYPE"
            FLAGGED=$((FLAGGED + 1))
        fi

        # 6. Indicator for .log files.
        if [[ "$FILE" == *.log ]]; then
            DISTINCT=0
            HITS=0
            for IND in ${IOCS[@]+"${IOCS[@]}"}; do
                N=$(grep -Fwc -- "$IND" "$FILE" 2>/dev/null || true)
                [ -n "$N" ] || N=0
                if [ "$N" -gt 0 ]; then
                    DISTINCT=$((DISTINCT + 1))
                    HITS=$((HITS + N))
                fi
            done
            echo "ioc check: $DISTINCT of $IOC_COUNT indicators present ($HITS matching lines)"
            IOC_INDICATORS=$((IOC_INDICATORS + DISTINCT))
            IOC_MATCHES=$((IOC_MATCHES + HITS))
        fi

        echo
    done
done

# ---- totals ----
echo "=== survey totals ==="
echo "files surveyed: $SURVEYED"
echo "files flagged: $FLAGGED"
echo "total IOC matches: $IOC_MATCHES"
echo "distinct indicators seen (summed per log): $IOC_INDICATORS"
