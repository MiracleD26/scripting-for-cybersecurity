a = [2023, "setu", "Carlow"]
b = ["kilkenny road", "Co Carlow"]

# extend(): add elements of b to a
a.extend(b)
print(a)

# insert(): put "R93 V960" in the 2nd position
a.insert(1, "R93 V960")
print(a)

# pop(): remove the last item and print it
removed = a.pop()
print(removed)

# index(): index of "setu"
print(a.index("setu"))

# count(): how many times "setu" appears
print(a.count("setu"))

# copy(): create a copy (c) of a
c = a.copy()
print(c)