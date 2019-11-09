import numpy as np

def magic_square(n) :
    
    # 입력 받은 숫자가 짝수일 경우 에러 출력
    if n % 2 == 0 :
        print("Number is not odd!!!")
        
        return 0
    
    # nXn의 0으로 채워진 행렬 생성
    matrix = np.zeros((n,n))
    
    # 초기값 지정
    x, y, value = 0, int(n/2), 1
    
    # 시작 위치 1 지정
    matrix[x,y] = value
    
    # 나머지 칸 채우기 : 2 ~ 25
    for value in range(2, n*n+1) :
        
        # 위로 한 칸 상승, 왼쪽으로 한 칸 이동
        x, y = x-1, y-1
        
        # 더이상 왼쪽으로 이동할 수 없는 경우 반대편으로 이동
        if x < 0 and y >= 0 :
            x = n-1
            
        # 더 이상 위로 올라갈 수 없는 경우 반대편으로 이동
        elif x >= 0 and y < 0 :
            y = n-1
            
        # 가야할 자리가 맨 왼쪽 위 대각선인 경우 원래 자리에서 한 칸 아래로 이동
        elif x < 0 and y < 0 :
            x = x+2
            y = y+1
            
        # 가야할 곳이 빈자리가 아닌 경우 원래 자리에서 한 칸 아래로 이동
        elif matrix[x,y] != 0 :
            x = x+2
            y = y+1
            
        # 값 채워 넣기
        matrix[x,y] = value
        
    # 마방진 출력
    for i in range (n) :
        for j in range (n) :
            print("%2d" %matrix[i][j], end="\t")
        print ()
        
    # 행렬 반환
    return matrix

# 5X5 마방진
magic_square(5)