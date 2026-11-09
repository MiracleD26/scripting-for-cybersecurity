text = "The quick brown fox jumps over the lazy dog"

words = text.split()
print(words)

long_words = []
for word in words:
    if len(word) > 3:
        long_words.append(word)

print(long_words)