###############################################
##########INTRODUCTION TO R####################
###############################################
###############################################


#TONI RODON
#www.tonirodon.cat
#@tonirodon

rm(list = ls())



# EU withdrawal agreement ------------------------------------------------------

library("pdftools")
library("stringr")
library("readtext")
library("quanteda")
library("tabulizer")


draft <- pdftools::pdf_text("Figures/draft_withdrawal_agreement_0.pdf")
length(draft)

#First page
first <- draft[1]
first

#There are a few things to note. The text contains newline characters (`\n`) and
#an uniformative `& /en 1` at the bottom of the page. To remove them we'll use
#regular expressions in the base R (but check `stringr` package for newer implementation).

first <- gsub("[[:space:]]+", " ", first)
first

#remove page numbering
first <- gsub("& /en [0-9]{1,3}", "", first)
first

#let's apply the strategy to all
draft <- gsub("[[:space:]]+", " ", draft)
draft <- gsub("& /en [0-9]{1,3}", "", draft)
draft[3]

#Extract all the directives mentioned in teh agreement
pattern <- "Directive [0-9]{2,4}/[0-9]{2,3}/[A-Z]{2,3}"
pattern

# `base` R solution
directives1 <- regmatches(draft, gregexpr(pattern, draft))

# `stringr` solution
directives2 <- stringr::str_extract_all(draft, pattern)

directives <- unlist(directives1)
directives <- sort(table(directives), decreasing = TRUE)
sum(directives)
directives10 <- directives[1:10]


barplot(directives10, las = 2)


#Let's analyse some patterns
df <- as.data.frame(draft)

#We create a corpus
corpus <- corpus(df, text=c("draft"))
summary(corpus)

tokeninfo <- summary(corpus)

tokeninfo[which.max(tokeninfo$Tokens), ]



dfm <- dfm(corpus,
           remove = c(stopwords("english")),
           stem = T,
           remove_numbers = TRUE, 
           remove_punct = TRUE,
           remove_symbols = TRUE,
           verbose  = T)

topfeatures(dfm, 50)

kwic(corpus, pattern = "european", valuetype = "regex")
                        
library("quanteda.textstats")
tstat_lexdiv <- textstat_lexdiv(dfm)
tail(tstat_lexdiv, 5)

plot(tstat_lexdiv$TTR, type = "l", xaxt = "n", xlab = NULL, ylab = "TTR")
grid()
axis(1, at = seq_len(nrow(tstat_lexdiv)))

#https://github.com/hjmschoonvelde/ceu_ata_2019/blob/master/Solutions/String_Operations_Answer.pdf



# Wordscore ---------------------------------------------------------------

rm(list = ls())

corp_ger <- readRDS("Data/data_corpus_germanifestos.rds")
summary(corp_ger)

# tokenize texts
toks_ger <- tokens(corp_ger, remove_punct = TRUE)

# create a document-feature matrix
dfmat_ger <- dfm(toks_ger) %>% 
  dfm_remove(pattern = stopwords("de"))

# apply Wordscores algorithm to document-feature matrix
library("quanteda.textmodels")
tmod_ws <- textmodel_wordscores(dfmat_ger, y = corp_ger$ref_score, smooth = 1)
summary(tmod_ws)

#predict the Wordscores for the unknown virgin texts.
pred_ws <- predict(tmod_ws, se.fit = TRUE, newdata = dfmat_ger)

library("quanteda.textplots")
textplot_scale1d(pred_ws)



library("seededlda")
tmod_lda <- textmodel_lda(dfm, k = 10)

terms(tmod_lda, 10)
