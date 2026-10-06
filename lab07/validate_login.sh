# --- Part 1: Read username ---
read -p "Enter username: " USERNAME

# --- Part 2: Empty check -> stderr + exit 1 ---
if [ -z "$USERNAME" ]; then
  echo "Error: username cannot be empty" >&2
  exit 1
fi

# --- Part 3: Determine account source (reuses account_source.sh) ---
INTEL="intel/users.csv"
LEGACY="case/backups/users.old"

SOURCE="UNKNOWN"
ROLE=""
STATUS=""

if [ -f "$INTEL" ] && grep -q "^$USERNAME," "$INTEL"; then
  SOURCE="CURRENT"
  ROLE=$(grep "^$USERNAME," "$INTEL" | head -1 | cut -d',' -f2)
  STATUS=$(grep "^$USERNAME," "$INTEL" | head -1 | cut -d',' -f3)
elif [ -f "$LEGACY" ] && grep -q "^$USERNAME" "$LEGACY"; then
  SOURCE="LEGACY"
fi

echo "Account: $USERNAME"
echo "Source:  $SOURCE"
if [ "$SOURCE" = "CURRENT" ]; then
  echo "Role:    $ROLE"
  echo "Status:  $STATUS"
fi

# --- Part 4: Count failed/accepted logins ---
AUTHLOG="case/logs/auth.log"
FAILED=0
ACCEPTED=0
if [ -f "$AUTHLOG" ]; then
  FAILED=$(grep -c "Failed password for $USERNAME " "$AUTHLOG")
  ACCEPTED=$(grep -c "Accepted password for $USERNAME " "$AUTHLOG")
fi
echo "Failed logins:   $FAILED"
echo "Accepted logins: $ACCEPTED"

# --- Part 5: Classify failed count with risk_level.sh ---
RISK=$(bash scripts/risk_level.sh "$FAILED" 2>/dev/null || echo "UNKNOWN")
echo "Risk level: $RISK"

# --- Part 6: Situation-specific warnings ---
# a) disabled current account with ANY accepted login
if [ "$SOURCE" = "CURRENT" ] && [ "$STATUS" = "disabled" ] && [ "$ACCEPTED" -gt 0 ]; then
  echo "WARNING: disabled current account '$USERNAME' has $ACCEPTED accepted login(s)"
fi

# b) legacy/unknown account targeted by failed logins (name guessing)
if { [ "$SOURCE" = "LEGACY" ] || [ "$SOURCE" = "UNKNOWN" ]; } && [ "$FAILED" -gt 0 ]; then
  echo "WARNING: $SOURCE account '$USERNAME' was targeted by $FAILED failed login(s) (attacker is guessing names)"
fi

# c) current account with accepted logins
if [ "$SOURCE" = "CURRENT" ] && [ "$ACCEPTED" -gt 0 ] \
   && grep -q "^$USERNAME:" case/evidence/passwords.txt 2>/dev/null; then
  echo "WARNING: current account '$USERNAME' has accepted logins AND plaintext credentials in passwords.txt"
fi

# --- Part 7: Exit code by source ---
case "$SOURCE" in
  CURRENT) exit 0 ;;
  LEGACY)  exit 2 ;;
  UNKNOWN) exit 3 ;;
esac
