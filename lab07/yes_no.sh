read -p "Enter yes or no: " ANSWER

ANSWER_LOWER="${ANSWER,,}"
if [ "$ANSWER_LOWER" = "yes" ]; then
    echo "Confirmed."
elif [ "$ANSWER" = "no" ]; then
    echo "Cancelled."
else
    echo "Unrecognised answer: '$ANSWER'"
fi
