# 클래스 생성
class Univariate :
    
    def __init__(self, x) :
        self.x = x
        
    @staticmethod
    def sort_fn(x) :
        n = len(x)   
        for i in range(n-1):
            k = i
            for j in range(i+1,n) :
                if x[k] > x[j] : 
                    k = j
            x[k], x[i] = x[i], x[k]
        return x
    
    @staticmethod
    def quantile_fn(x,q) :
        n = len(x)
        nq = n*q
        t = int(nq)
        g = nq - t
        return (1-g)*x[t-1] + g*x[t]
    
    @staticmethod
    def summary_fn(x) :
        n = len(x)
        xbar,s2 = 0,0
        
        for i in range(n) :
            xbar = xbar + x[i]
            s2 = s2 + x[i]*x[i]
        
        # Sort
        x = Univariate.sort_fn(x)
        
        # 평균    
        xbar = xbar/n
        
        # 분산
        s2 = (s2 - n*xbar*xbar)/(n-1)
        
        # 분위수
        median = Univariate.quantile_fn(x,0.5)
        Q1 = Univariate.quantile_fn(x,0.25)
        Q3 = Univariate.quantile_fn(x,0.75)
        
        return {"Mean":round(xbar,2),"Var":round(s2,2),"Q1":round(Q1,2),"Median":round(median,2),"Q3":round(Q3,2),"Min":round(x[0],2), "Max":round(x[n-1],2)}
    
    # Hist plot    
    def histogram_plot(self, kkh=0, PLOT_LENGTH = 100):
        import math                                                               # 라이브러리 Math
        n = len(self.x)                                                           # 데이터의 길이
        if kkh == 0 :                                                             # 가장 적절한 구간의 수
            kkh = 1 + int(math.log2(n) + 0.5)                                  
        x = Univariate.sort_fn(self.x)                                            # 데이터 정렬
        D = (x[n-1] - x[0]) / kkh                                                 # 구간의 크기
        nobs = [0 for _ in range(kkh)]                                            # 정답 리스트 생성
        for i in range(0,n-1)  :                                                  # 각각의 데이터를 확인
            k = int((x[i] - x[0]) / D)                                            # 몇번째 구간인지 체크
            nobs[k] = nobs[k] + 1                                                 # 해당 구간 값에 +1
        N_MAX = max(nobs)                                                         # 구간의 최대 길이 체크
        DECO = "I" + "-"*(PLOT_LENGTH-N_MAX) + "I"                                # 위아래 장식 모양
        print("  ",DECO)                                                          # 위 장식
        for i in range(kkh) :                                                     # 정답 리스트를 돌면서
            S = "I" + "*"*nobs[i] + " "*((PLOT_LENGTH-N_MAX) - nobs[i]) + "I"     # 내용물 생성
            print("{:2} {}". format(nobs[i],S))                                   # 별 그리기
        print("  ",DECO)                                                          # 아래 장식
        return nobs
# 난수 생성
import numpy as np
x = np.random.normal(loc=170., scale=5.0, size = 100)

# Summary 함수 실행
print (Univariate.summary_fn(x))

# Hist Plot 실행
aClass = Univariate(x)
aClass.histogram_plot()