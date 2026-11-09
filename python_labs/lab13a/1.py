a = 20
b = 30
c = 40
d = 50

number = int(input("Enter a number between 20 and 50: "))

if a <= number <= d:
    print("The number falls in the range of a and d")
    if number <= b:
        print("The number is between a and b")
    elif number <= c:
        print("The number is between b and c")
    else:
        print("The number is between c and d")
else:
    print("The number is outside the range of a and d")