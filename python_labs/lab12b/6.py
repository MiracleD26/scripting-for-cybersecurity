numbers = [789, -4, 10, 20, 30, 50, 60, 80, 23]

smallest = numbers[0]
largest = numbers[0]

for n in numbers:
    if n < smallest:
        smallest = n
    if n > largest:
        largest = n

print("Smallest:", smallest)
print("Largest:", largest)