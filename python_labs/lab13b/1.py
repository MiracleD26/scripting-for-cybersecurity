def same_elements(list1, list2):
    # Work on copies so the original lists are not changed
    list1 = list1.copy()
    list2 = list2.copy()

    # Loop through a copy of list1 (we delete from list1 inside the loop)
    for item in list1.copy():
        if item in list2:
            list1.remove(item)   # delete from both lists
            list2.remove(item)

    # If either list still has elements, they don't contain the same elements
    if len(list1) != 0 or len(list2) != 0:
        return False
    return True


# Lists used:
# list1 = [1,2,3,4,5], list2 = [5,4,3,2,1]   -> True
# list1 = [1,2,3],     list2 = [1,2,4]       -> False
# list1 = [1,2,3],     list2 = [1,2,3,4]     -> False
# list1 = [1,1,2],     list2 = [1,2,2]       -> False

list1 = [1, 2, 3, 4, 5]
list2 = [5, 4, 3, 2, 1]
print(same_elements(list1, list2))

list1 = [1, 2, 3]
list2 = [1, 2, 4]
print(same_elements(list1, list2))

list1 = [1, 2, 3]
list2 = [1, 2, 3, 4]
print(same_elements(list1, list2))

list1 = [1, 1, 2]
list2 = [1, 2, 2]
print(same_elements(list1, list2))

# It loops through list1, and if the element is also in list2, it removes it from both.
# At the end, if either list is not empty, the lists don’t match, so it returns False. Otherwise it returns True.
# The loop goes over list1.copy() because removing items from a list while looping over that same list skips elements and gives wrong results.
# .remove() only deletes one occurrence, so duplicates are handled correctly. That’s why [1,1,2] and [1,2,2] give False.