# jiangshiying.github.io
topic model of book review

The result of LAD visualization: [http://jiangshiying.github.io/vis](http://jiangshiying.github.io/vis)

**Data collection**

Books review data from Amazon which includes 3189 positive and negative reviews.
Data source: [https://www.cs.jhu.edu/~mdredze/datasets/sentiment/index2.html](https://www.cs.jhu.edu/~mdredze/datasets/sentiment/index2.html)

`#books review data, data source:https://www.cs.jhu.edu/~mdredze/datasets/sentiment/index2.html

book<-read.csv("assignment8/review.csv",header=T,stringsAsFactors = F)

dim(book)

review<-book$review`

**Data preprocessing**

First of all, we need to create a stopword list. In this case, besides words in stopwords dictionary I add "book" in stopwords list.  

`#create stop word set, including general stop word and "book"

stop_words=stopwords("SMART")
stop_words=c(stop_words,"book")
stop_words=tolower(stop_words)`

Then , tokenize the text, remove the stopwords and remove the words that occur less than 5 times.

`review <- gsub("'", "", review) # remove apostrophes
review <- gsub("[[:punct:]]", " ", review)  # replace punctuation with space
review <- gsub("[[:cntrl:]]", " ", review)  # replace control characters with space
review <- gsub("^[[:space:]]+", "", review) # remove whitespace at beginning of documents
review <- gsub("[[:space:]]+$", "", review) # remove whitespace at end of documents
review <- gsub("[^a-zA-Z -]", " ", review) # allows only letters
review <- tolower(review)  # force to lowercase

review<-review[review!=""]

doc.list<-strsplit(review,"[[:space:]]+")`






