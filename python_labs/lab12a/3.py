charset = ['f', 'a', 'b', 'c', 'j', 'i', 'e', '*', ')', '£', '2', '/', 's', 'o']

# Using a for loop
found = False
for c in charset:
    if c == 'e':
        found = True
        break

if found:
    print("for loop: the list contains 'e'")
else:
    print("for loop: the list does not contain 'e'")

# Using a while loop
found = False
i = 0
while i < len(charset):
    if charset[i] == 'e':
        found = True
        break
    i += 1

if found:
    print("while loop: the list contains 'e'")
else:
    print("while loop: the list does not contain 'e'")