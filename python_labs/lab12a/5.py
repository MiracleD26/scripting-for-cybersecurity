a = []
n = int(input("How many numbers? "))
for i in range(n):
    a.append(int(input("Enter a number: ")))

new_list = [a[0], a[-1]]
print(new_list)