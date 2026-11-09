a = [10, 20, 30, 20, 10, 50, 60, 40, 80, 50, 40]

unique = []
for item in a:
    if item not in unique:
        unique.append(item)

print(unique)