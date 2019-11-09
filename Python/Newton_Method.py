import math

# 함수 f
def f(x) : 
    return math.exp(-abs(x)) - x/(1 + x*x)

# 함수 f의 미분
def f_d(x) : 
    xsqr = x*x
    fp = (xsqr - 1)/((1+xsqr)*(1+xsqr)) + -math.exp(-x) if x>0 else math.exp(x)
    return(fp)
    
# Newton Method
def newton(x,f,f_d,eps=0.00001):
    fx=f(x)
    for _ in range(30):
        x = x - fx/f_d(x)
        fx = f(x)
        if abs(fx) < eps :
            return x
    print("no solution")
    return()

# Test Run
print(newton(x=1, f=f, f_d=f_d))
