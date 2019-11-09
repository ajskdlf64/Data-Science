# Data 생성
from scipy.stats import norm
from pip._vendor.urllib3 import add_stderr_logger
x = [norm.rvs() * 5 + 170. for _ in range(100)]

# R 흉내내기
def SUMMARY(x) : 
    
    # 결과 저장소
    result = []
    
    # 데이터 정렬하기
    def sort_function (X) :
        N = len(X)
        for i in range(N-1):
            k = i
            for j in range(i+1,N) :
                if X[k] > X[j] :  
                    k = j
                    X[k],X[i] = X[i],X[k]
        return X
    
    # 정렬 실행
    x = sort_function(x)
    
    # 데이터의 길이
    N = len(x)
    
    # 데이터들의 합
    def SUM_FUNCTION(x) :
        SUM = 0
        for i in range(N) : 
            SUM = SUM + x[i]
        return SUM
    SUM  = SUM_FUNCTION(x)
    
    # 데이터들의 제곱합
    def SUM_2_FUNCTION(x) :
        SUM_2 = 0
        for i in range(N) : 
            SUM_2 = SUM_2 + x[i]*x[i]
        return SUM_2
    SUM_2  = SUM_2_FUNCTION(x)
    
    # 최솟값
    def MIN_FUNCTION(x) : 
        return x[0]
    MIN = MIN_FUNCTION(x)
    result.append(MIN)
    
    # 최댓값
    def MAX_FUNCTION(x) : 
        return x[N-1]
    MAX = MAX_FUNCTION(x)
    result.append(MAX)
    
    # 평균 
    def MEAN_FUNCTION(x) : 
        return SUM / N
    MEAN = MEAN_FUNCTION(x)
    result.append(MEAN)
    
    # 중앙값
    NN = int((N+1)/2)
    def MEDIAN_FUNCTION(x) : 
        return x[NN]
    MEDIAN = MEDIAN_FUNCTION(x)
    result.append(MEDIAN)
    
    # 분산
    def VAR_FUNCTION(x) :
        return SUM_2/N - MEAN*MEAN
    VAR = VAR_FUNCTION(x)
    result.append(VAR)
    
    # 표준편차
    def STD_FUNCTION(x):
        return VAR**0.5
    STD = STD_FUNCTION(x)
    result.append(STD)
    
    # 결과 출력
    NAME = ["MIN", "MAX", "MEDIAN", "MEAN", "VAR", "STD"]
    print("== Summary of X ==")
    for i in range(6) : 
        print("{}: {:.4f}". format(NAME[i], result[i]))
    
    # 결과는 리스트 반환
    return result

# 프로그램 실행    
SUMMARY(x)

