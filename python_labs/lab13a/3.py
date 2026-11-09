def replace_vowels(list1):
    vowels = ['a', 'e', 'i', 'o', 'u', 'A', 'E', 'I', 'O', 'U']
    counter = 1          # the integer, starts at 1
    list2 = []
    for item in list1:
        if item in vowels:
            list2.append(counter)
            counter += 1  # incremented each time it replaces a vowel
        else:
            list2.append(item)
    return list2

# Tests
list1 = ['a', 'b', 'c', 'd', 'e']
print(replace_vowels(list1))

list1 = ['a', 'a', 'a']
print(replace_vowels(list1))