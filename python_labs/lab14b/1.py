import string

text = """Excavations in the 1990s demonstrated that the Rock was first settled in the 9th century when a hill fort or dún was constructed on the site. The first known settlement on the rock was Dun Masc, or Masc’s Fort, an early Christian settlement that was pillaged in 842 by the Vikings. In 845 the Vikings of Dublin attacked the site and the abbot of Terryglass, Aed son of Dub dá Chrích, was killed there.[3] There is no clear evidence of 10th–11th century occupation.

The castle was built in the second half of the 12th century.

When the Normans arrived in Ireland in the late 12th century, Dunamase became the most important Hiberno-Norman fortification in Laois. It was Dunamase where Dermot Mac Morrough, King of Leinster, brought the wife of O'Rourke, the King of Breifne, after kidnapping her. Enlisting the help of the O'Connor clan, the O'Rourkes and O'Connors drove MacMurrough from Dunamase and he fled Ireland. MacMurrough gave Dunamase and his daughter Aoife in marriage to the Norman conqueror Strongbow in 1170 as part of a deal to enlist his help to regain his lands. The Norman invasion of Ireland then followed when Strongbow accompanied MacMurrough, along with many men, to attack and regain MacMurrough's lands"""

# Split the text into clean, lowercase words
words = []
for w in text.split():
    w = w.strip(string.punctuation).lower()
    if w != "":
        words.append(w)

# Dictionary: key = word, value = tuple of positions
positions = {}
for i in range(len(words)):
    word = words[i]
    if word not in positions:
        positions[word] = []
    positions[word].append(i)

word_positions = {}
for word, pos_list in positions.items():
    word_positions[word] = tuple(pos_list)

# 1. Print the dictionary
print(word_positions)

# 2. Average position of "the" and "in"
for target in ["the", "in"]:
    p = word_positions[target]
    print("Average position of", target, "=", sum(p) / len(p))

# 3. Set of words longer than 4 characters
longer_than_4 = set()
for word in words:
    if len(word) > 4:
        longer_than_4.add(word)

# 4. Set of words shorter than 7 characters
shorter_than_7 = set()
for word in words:
    if len(word) < 7:
        shorter_than_7.add(word)

# 5. Intersection of the two sets
print(longer_than_4 & shorter_than_7)