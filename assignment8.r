library(quanteda)
library(tm)
library(ggplot2)
library(ggdendro)
library(cluster)
library(fpc) 
library(lda)
library(dplyr)
require(magrittr)
library(stringr)
library(openNLP)
library(LDAvis)
library(servr)


#books review data, data source:https://www.cs.jhu.edu/~mdredze/datasets/sentiment/index2.html
book<-read.csv("assignment8/review.csv",header=T,stringsAsFactors = F)
dim(book)
review<-book$review

#create stop word set, including general stop word and "book"
stop_words=stopwords("SMART")
stop_words=c(stop_words,"book")
stop_words=tolower(stop_words)


review <- gsub("'", "", review) # remove apostrophes
review <- gsub("[[:punct:]]", " ", review)  # replace punctuation with space
review <- gsub("[[:cntrl:]]", " ", review)  # replace control characters with space
review <- gsub("^[[:space:]]+", "", review) # remove whitespace at beginning of documents
review <- gsub("[[:space:]]+$", "", review) # remove whitespace at end of documents
review <- gsub("[^a-zA-Z -]", " ", review) # allows only letters
review <- tolower(review)  # force to lowercase

review<-review[review!=""]

doc.list<-strsplit(review,"[[:space:]]+")

#create dictionary
term.table <- table(unlist(doc.list))
term.table <- sort(term.table, decreasing = TRUE)

# remove terms that are stop words or occur fewer than 5 times:
del <- names(term.table) %in% stop_words | term.table < 5
term.table <- term.table[!del]
term.table <- term.table[names(term.table) != ""]
vocab <- names(term.table)

get.terms <- function(x) {
  index <- match(x, vocab)
  index <- index[!is.na(index)]
  rbind(as.integer(index - 1), as.integer(rep(1, length(index))))
}
documents <- lapply(doc.list, get.terms)

K <- 20 #topic number
G <- 5000 #iteration number 
alpha <- 0.02
eta <- 0.02

set.seed(357)
t1 <- Sys.time()
fit <- lda.collapsed.gibbs.sampler(documents = documents, K = K, vocab = vocab, 
                                   num.iterations = G, alpha = alpha, 
                                   eta = eta, initial = NULL, burnin = 0,
                                   compute.log.likelihood = TRUE)
t2 <- Sys.time()
t2-t1

#document-term distribution matrix
theta <- t(apply(fit$document_sums + alpha, 2, function(x) x/sum(x)))
#term-word distribution matrix
phi <- t(apply(t(fit$topics) + eta, 2, function(x) x/sum(x)))
doc.length <- sapply(documents, function(x) sum(x[2, ])) 

# create the JSON object to feed the visualization:
json <- createJSON(phi = phi,
                     theta = theta,
                     doc.length = doc.length,
                     vocab = vocab,
                     term.frequency = term.frequency)

serVis(json, out.dir = 'vis', open.browser = TRUE)

