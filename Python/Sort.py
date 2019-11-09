# Data 생성
from scipy.stats import norm
x = [norm.rvs() * 5 + 170. for _ in range(10)]
x_1 = x
x_2 = x

# 정렬 함수
def sort_function (X) :
    # 주어진 데이터의 길이를 구한다.
    N = len(X)
    # 0부터 주어진 길이-1 까지 반복한다.
    for i in range(N-1):
        # 스위칭을 하기 위해 임시로 k라는 변수를 만든다.
        k = i
        # 위에 반복문에 해당하는 기준 숫자와 그 뒷숫자와 1대1로 비교하여 만약 뒷수자가 더 작으면 자리를 스위칭한다.
        for j in range(i+1,N) :
            # 인접한 두개의 숫자를 비교해서
            if X[k] > X[j] :  
                # 만약 뒷숫자가 더 작으면 인덱싱을 스위칭
                k = j
        # 스위칭된 인덱싱에 바뀐 값을 넣어준다.
        X[k],X[i] = X[i],X[k]
    # 정렬이 된 데이터를 반환한다.
    return X

# 사용자 정의 함수로 만든 데이터
print(sort_function(x_1))

# 파이썬에 내장된 함수
x_2.sort()
print(x_2)

