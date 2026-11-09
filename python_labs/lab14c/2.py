import string

letters = string.ascii_lowercase

pair_codes = {}
for i in range(0, len(letters), 2):
    first = letters[i]
    second = letters[i + 1]
    pair_codes[(first, second)] = (ord(first), ord(second))

print(pair_codes)