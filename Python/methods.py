# Str methods

s = 'Hello World!'
s.upper()         # 대문자로 변경
s.lower()         # 소문자로 변경
s.swapcase()      # 대문자는 소문자로, 소문자는 대문자로 변경
s.capitalize()    # 첫 문자를 대문자로 변경
s.title()         # 각 단어의 첫 글자를 대문자로 변경

s = '   Hello World!   '
s.strip()  # 문자열 양쪽 끝을 자른다. 제거할 문자를 인자로 전달 (디폴트는 공백)
s.lstrip() # 문자열 왼쪽을 자름
s.rstrip() # 문자열 오른쪽을 자름

s = 'Hello World!'
s.replace('World', 'Python') # 문자열 특정 부분을 변경 (대체)

'{} is very {}'.format('Python', 'good!') #  틀(포맷)을 만들어 놓고 문자열을 생성 

' and '.join(['Pyhon', 'C++', 'Java']) # 리스트 같은 iterable 인자를 전달하여 문자열로 연결

s.center(30)   # 문자열 가운데 정렬. (인자로 넓이를 지정, 채울 문자 선택 가능)
s.center(30, "*")
s.ljust(30)      # 문자열 왼쪽 정렬
s.rjust(30)      # 문자열 오늘쪽 정렬

phone ='010-1234-5678'

phone.partition('-')  # 전달한 문자로 문자열을 나눔(분리), 결과는 튜플(구분자도 포함)
phone.rpartition('-') # 뒤에서 부터 전달한 인자로 문자열을 나눔
phone.split('-')      # 전달한 문자로 문자열을 나눔, 결과는 리스트(구분자 포함 안됨)
phone.rsplit('-')     # 뒤에서 부터 전달한 문자로 문자열을 나눔
phone.rsplit('-',1) 

statement = '''Hello World!
Python is very powerful.
You must enjoy it.'''

statement

statement.splitlines()   # 라인 단위로 문자열을 나눔 

sentence = '''
In Python, both str and the basic numeric types such as
int are immutable that is, once set, their value cannot
be changed. At first this appears to be a rather strange
limitation, but Python’s syntax means that this is a
nonissue in practice.
'''

sentence

sentence.upper()
sentence.upper().split()
set(sentence.upper().split())
len(set(sentence.upper().split()))

# list 
L = list(range(10))       # Q: L = range(10)
L[0:2] = [10, 11]         # 두 값 교체
L[0:2] = [10]             # 두 값 교체 ( 항목 1 삭제 )
L[0:2] = []               # 두 항목 삭제
del L[1:]                 # 항목 삭제

a = [1,2]
a[1:1] =['a', 'b']        # 1 위치에 두 항목 삽입  Q: a[1] = ['a', 'b']
a[::2]                    # 확장 slicing

#  확장 slicing 이 왼쪽에 오는 경우는 항목 갯수가 일치하여야 한다.
a[::2] = list(range(5))   # 갯수 불일치, error

a = list(range(3))        # 갯수 불일치 but ok
s = [1, 2, 3]
t = ['a', s, 'b']
t                         # ['a', [1, 2, 3], 'b']   중첩리스트

# list methods

s = [1, 2, 3]
s.append(5)              # 리스트의 끝에 값 5 를 삽입
s.insert(3, 4)           # 3 위치에 4 삽입
s.index(3)               # 값 3 의 위치
s.count(2)               # 값 2 의 개수
s.reverse()              # 순서를 역으로 변경
s.sort()                 # 크기 순으로 정렬
s.remove(2)              # 값 2 삭제, 첫 번째만
s.extend([6, 7])         # 끝에 항목 추가


#   Stack: LIFO 구조
s = [10, 20, 30, 40, 50]
s.append(60)
s.pop()
s


s = [10, 20, 30, 40, 50]
s.pop(0)                  # 첫번째 요소 추출

s.sort()                  # ascending sort
s.sort(reverse = True)    # descending

#  sequence 형 자료로 list 를 만드는 방법
L = [ k*k for k in range(5) if k % 2 == 1]

# Same as above
L = []
for k in range(5):
    if k % 2 == 1 :
        L.append(k*k)

L = [ k*i for k in range(5) for i in range(3) ]

seq1 = 'abc'; seq2=(1,2,3)
[(x,y) for x in seq1 for y in seq2]


L = [[j+i for j in [10,20,30]] for i in [0,1,2]]  # array

L

L[1][2]


#   발생자(generator)

a = (k*k for k in range(5))    # () 이면 발생자 객체
a

sum(a)                         # 30

# list 내장보다 발생자가 효율적일 수 있다.
range(10)                      # 발생자 객체
range(5, 10)                   # 5 부터 9
range(5, 10, 2)                # 5 부터 2 간격으로

# range 객체는 순차적인 값을 할당하는데도 사용

Sun, Mon, Tue, Wed, Thu, Fri, Sat = range(7)
Sun, Mon, Sat


# tuple: immutable sequence 형 자료
t = ()                 # 빈 tuple
t = 1,                 # t = (1,)

t = 1, 2, 3            # t = (1,2,3)
t * 2                  # (1,2,3,1,2,3)
t + ('a', 'b')         # (1,2,3,’a’,’b’)
t[0], t[1:3]           # (1, (2,3)) 중첩 tuple
len(t)                 # 길이, 3
1 in t                 # 멤버 검사 True
t[0] = 100             # error
t.count(2)             # 2 몇개?
t.index(2)             # 2 의 위치


#  패킹, 언패킹

# 치환
x, y, z = 1, 2, 3

(x1, y1), (x2, y2) = (1,2), (3,4)


#  패킹 : 한 데이터에 여러 개의 데이터 치환

t = 1, 2, 'Hello'

# 언패킹 : 여러 개의 데이터를 하나의 데이터로 치환
x, y, x = t

L = [1,2,3]       # list 도 언패킹 가능
x, y, x = L
T = 1, 2, 3, 4, 5

a, *b = T         # *b 는 나머지 전부를 의미
# a = 1, b = [2,3,4,5]

*a, b = T         # error

#  tuple 의 활용

# 함수가 하나 이상의 값을 반환할 때
def add_prod(a, b):
    return a + b, a * b

x, y = add_prod(2, 3)

# tuple 값을 함수의 인수로 사용할 때
args = (2, 3); add_prod(*args)

# tuple 과 list 는 내장함수 list() 와 tuple() 을 이용하여 상호 변환 가능
L = list(T)
T = tuple(L)

# tuple 의 예제

# tuple 을 이용한 경로명
import os
p = os.path.abspath('LargeScale.pdf')   # 절대경로 반환
p                                       # ’/home/seung/test.tex’

os.path.exists(p)              # 파일 존재 여부 검사
os.path.getsize(p)             # 파일 크기 반환
os.path.split(p)               # 파일명과 경로 분리
                               # (’/home/seung’, ’test.tex’)


#  tuple 을 이용한 URL
                               
from urllib.parse import urlparse
url='https://en.wikipedia.org/wiki/Limits_of_computation'
r = urlparse(url)
r

# set: 여러 값을 순서 및 중복없이 모아 놓은 자료형
# set: mutable; frozenset: immutable

s1 = set()                 # 빈 set 객체 생성
s2 = {1, 2, 3}
s3 = s2.copy()             # s2 복사
s4 = set((1,2,3))          # tuple 또는 list 로 생성
s5 = set('abc')            # {’a’, ’b’, ’c’}
set({'one':1, 'two':2})    # 사전으로 생성
                           # {’one’, ’two’} # 키만 반환
{[1,2],[2,3]}              # error


s = {1,2,3}
len(s)                    # 원소의 개수
s.add(4)                  # {1,2,3,4}
s.update([3,4])           # s cup {3,4}
s.update({3,4})           # same as above
s.clear()                 # 전체 원소 제게
s5 = set('abc')           # {’a’, ’b’, ’c’}
s.discard(3)              # 원소 3 제거, 없어도 ok
s.remove(3)               # 원소 3 제거, 없으면 예외 발생
s.pop()                   # 원소 하나를 제거하면서 이를 반환


#   disctionary
#  임의 객체의 집합적 매핑형 자료 (key 에 의해 값을 접근 )
#  값은 임의의 객체가 될 수 있으나 key 는 immutable

member = {'basketball':5, 'soccer':11}
member['basketball']        # 호출 5


member['baseball'] = 9       # 멤버 추가
del member['baseball']       # 멤버 삭제

# 함수를 key나 값으로 활용할 수 있다.

def add(a, b):
    return a + b

def sub(a, b):
    return a - b

action = {0:add, 1:sub}
action[0](4,5)

dict(one=1, two=2)          # dict 함수에 의한 생성


# disctionary method
# 사전의 method(Let D be a dictionary)

D = dict(one=1, two=2)          
D.clear()                       # 모든 항목 삭제
D.copy()                        # 사전 복사
D.get('three', 'two')           # 값이 존재하면 D[key] 아니면 x
D.pop('two')                      # key 의 값을 반환하고 삭제

#  사전의 내장
{w:1 for w in 'abc'} # {’a’:1, ’b’:1,’c’:1}

a1 ='abc'; a2=(1,2,3)
{x:y for x,y in zip(a1, a2)}

