import math

# 함수 지정하기
def f(x) : return math.exp(-abs(x)) - x/(1+x*x)

# Bisection Method
def bisection(x0, x1, eps=0.00001) :
    # 초기값 지정
    fx0, fx1 = f(x0), f(x1)
    # 두 수 사이에 해가 존재하지 않음
    if (fx0 * fx1) > 0 : print("Wrong guess")
    # 두 수의 차이가 오차(eps=0.00001)보다 작을 때 까지 계속 반복
    while abs(x0 - x1) > eps : 
        # 두 수 사이의 가운데 값 생성
        x2 = (x0 + x1) / 2
        fx2 = f(x2)
        # 왼쪽 오른쪽 중 해가 있는 곳을 찾아 다시 분할하기
        if (fx0 * fx2) < 0 : x1,fx1 = x2,fx2  
        else : x0, fx0 = x2, fx2
    return (x0 + x1)/2

# 함수 실행
print(bisection(0,2))
    