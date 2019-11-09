# 클래스 생성
class Rectangle :
    
    count = 0 # class variable
    
    # 초기자(initializer)
    def __init__(self, width, height): 
        self.width = width 
        self.height = height
        Rectangle.count += 1
        
    # instance method    
    def calcArea(self): 
        area = self.width * self.height
        return area

# rect(instance 객체) 생성
rect = Rectangle(10, 20)
print(rect.count)
print(rect.calcArea())

# 새로운 인스턴스 생성
rect2 = Rectangle(100,200)
print(rect.count, rect2.count, Rectangle.count)