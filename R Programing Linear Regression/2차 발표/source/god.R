# JAVA 셋팅
Sys.setenv(JAVA_HOME="C:\\Program Files\\Java\\jre1.8.0_191")


# 패키지 로딩
library(KoNLP)
library(tidyverse)
library(stringr)
library(wordcloud)
library(RColorBrewer)


# 사전 로딩
useNIADic()


# 데이터 불러오기
txt <- readLines("god.txt", encoding="euc-kr")
head(txt)


# 특수문자 제거
txt <- str_replace_all(txt, "\\W", " ")


# 연설문에서 명사추출
nouns <- extractNoun(txt)


# 추출한 명사 list 를 문자열 벡터로 변환, 단어별 빈도표 생성
wordcount <- table(unlist(nouns))


# 데이터 프레임으로 변환
df_word <- as.data.frame(wordcount, stringsAsFactors = F)


# 변수명 수정
df_word <- rename(df_word,word = Var1,freq = Freq)


# 두 글자 이상 단어 추출
df_word <- filter(df_word, nchar(word) >= 2)
top_20 <- df_word %>% arrange(desc(freq)) %>% head(20)


# 단어 색상 목록 만들기
# Dark2 색상 목록에서 8 개 색상 추출
pal <- brewer.pal(8,"Dark2")


# 워드 클라우드 생성
set.seed(1234)                     # 난수 고정
wordcloud(words = df_word$word,    # 단어
          freq = df_word$freq,     # 빈도
          min.freq = 2,            # 최소 단어 빈도
          max.words = 400,          # 표현 단어 수
          random.order = F,        # 고빈도 단어 중앙 배치
          rot.per = .1,            # 회전 단어 비율
          scale = c(10, 0.3),       # 단어 크기 범위
          colors = pal)            # 색깔 목록

