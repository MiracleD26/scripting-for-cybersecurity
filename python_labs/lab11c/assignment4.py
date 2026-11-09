import math

a = 7
b = 5

a = a - 2          # subtract 2 from a -> 5
b = b + 5          # add 5 to b -> 10

C = math.sqrt(a**2 + b**2)
print(C)           # 11.180339887498949

D = C // 3         # floor division by 3
print(D)           # 3.0

E = D % 2          # modulo by 2
print(E)           # 1.0