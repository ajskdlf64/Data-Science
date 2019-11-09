# Fibonacci Sequence
def Fibonacci(n) :
    if n == 1 or n == 2 :     
        return 1
    else :
        return Fibonacci(n-1) + Fibonacci(n-2)

# Print Sequence
for i in range(1,11,1) :     
    if i == 1 : 
        print("Fibonacci Sequence")
    print("{}" .format(Fibonacci(i)), end="  ")


print("")


def Fibonacci_Ignition() : 
    
    result = []
    
    for n in range(1,21,1) : 
        ROOT_FIVE = 5 ** 0.5
        SEQUENCE = (1/(ROOT_FIVE)) * (((1+ROOT_FIVE)/2)**n - ((1-ROOT_FIVE)/2)**n)
        SEQUENCE = int(SEQUENCE)
        result.append(SEQUENCE)
    return result

print(Fibonacci_Ignition())


