import string

text = """Phishing is one of the most common ways that attackers gain access to a network. An attacker sends an email that looks like it came from a trusted source, such as a bank or an employer, and asks the reader to click a link or open an attachment. The link usually leads to a fake login page that records the password as soon as it is typed in.

Strong passwords are the first line of defence against these attacks. A good password is long, unique, and not based on a name or a date. Many people reuse the same password on several websites, which means that one leak can put every account at risk.

Two-factor authentication adds a second step to the login process. Even if an attacker steals a password, they still need a code from the phone of the real user. Security teams also train staff to report suspicious messages quickly, because a fast response can stop a small incident from becoming a serious breach."""


def get_words(text):
    words = []
    for w in text.split():
        w = w.strip(string.punctuation).lower()
        if w != "":
            words.append(w)
    return words


def get_numbers():
    return {1, 2, 3, 4, 5}


word_list = get_words(text)

number_set = get_numbers()
print(number_set)

# Add the elements of the list to the set
number_set.update(word_list)
print(number_set)