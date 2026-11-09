marks = {}

marks[frozenset({"John", "C00012322"})] = (84, 45)
marks[frozenset({"Aoife", "C00045671"})] = (72, 90)
marks[frozenset({"Sean", "C00098123"})] = (55, 63)

print(marks)

# Look up a student's marks
print(marks[frozenset({"John", "C00012322"})])