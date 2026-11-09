squares = {5: 25, 6: 36, 7: 49}

reversed_dict = {}
for key, value in squares.items():
    reversed_dict[value] = key

print(reversed_dict)