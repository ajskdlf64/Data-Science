def mSquare ( n ) : # n : an odd number
    
    nsqr = n * n
    
    M = [[0 for col in range (n)] for row in range (n)]
    i = 0
    j = int ((n+1)/2) - 1
    M[i][j] = 1
    
    for k in range (2, nsqr+1) :
        i = i - 1
        j = j - 1
        
        if (i >= 0) & (j >= 0) :
            
            if (M[i][j] != 0 ) :
                i = i + 2
                j = j + 1
                
        else :
            
            if (i == -1) :
                if ( j == -1):
                    i = i + 2
                    j = j + 1
                    
                else : i = n - 1
                
            else : j = n - 1
            
        M[i][j] = k
        
    for i in range (n) :
        
        for j in range (n) :
        
            print ("%2d" %(M[i][j]), end="\t")
        
        print()
        
    return M

# 마방진
mSquare(5)

