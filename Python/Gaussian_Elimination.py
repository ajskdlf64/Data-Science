A = [[3,1,-1],[1,4,1],[2,1,2]]
B = [2,12,10]
X = [0,0,0]
N = 3


for i in range(N-1) : 
    
    for k in range(i+1,N) : 
        
        piv = -A[k][i] / A[i][i]
        
        for j in range(i+1,N) : 
            
            A[k][j] = A[k][j] + piv * A[i][j]

        B[k] = B[k] + piv * B[i]
        
A[1][0], A[2][0], A[2][1] = 0, 0, 0

X[N-1] = B[N-1] / A[N-1][N-1] 

for i in range(N-2, -1, -1) : 
    
    xsum = 0
    
    for k in range(i+1, N) : 
        
        xsum = xsum + A[i][k] * X[k]
    
    X[i] = (B[i] - xsum) / A[i][i]
    
print(X)