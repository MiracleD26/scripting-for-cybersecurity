import string

text = """Excavations in the 1990s demonstrated that the Rock was first settled in the 9th century when a hill fort or dún was constructed on the site. The first known settlement on the rock was Dun Masc, or Masc’s Fort, an early Christian settlement that was pillaged in 842 by the Vikings. In 845 the Vikings of Dublin attacked the site and the abbot of Terryglass, Aed son of Dub dá Chrích, was killed there.[3] There is no clear evidence of 10th–11th century occupation.

The castle was built in the second half of the 12th century.

When the Normans arrived in Ireland in the late 12th century, Dunamase became the most important Hiberno-Norman fortification in Laois. It was Dunamase where Dermot Mac Morrough, King of Leinster, brought the wife of O'Rourke, the King of Breifne, after kidnapping her. Enlisting the help of the O'Connor clan, the O'Rourkes and O'Connors drove MacMurrough from Dunamase and he fled Ireland. MacMurrough gave Dunamase and his daughter Aoife in marriage to the Norman conqueror Strongbow in 1170 as part of a deal to enlist his help to regain his lands. The Norman invasion of Ireland then followed when Strongbow accompanied MacMurrough, along with many men, to attack and regain MacMurrough's lands"""


def get_words(text):
    words = []
    for w in text.split():
        w = w.strip(string.punctuation).lower()
        if w != "":
            words.append(w)
    return words


word_list = get_words(text)
print(word_list[:10])