
# Multiplication Table

for i in range(0,8,3) : 
    
    for j in range(1,10,1) : 
        
        for k in range(1,4,1) : 
            
            print("{} X {} = {:2}" .format(k+i,j,(k+i)*j), end="\t")
            
        print()
                
    print()

