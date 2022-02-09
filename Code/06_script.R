###############################################
##########INTRODUCTION TO R####################
###############################################
###############################################


#TONI RODON
#www.tonirodon.cat
#@tonirodon

rm(list = ls())

library("rvest")


# Scrape wikipedia --------------------------------------------------------



#Let's scrape some tables from the web
url <- "http://en.wikipedia.org/wiki/List_of_U.S._states_and_territories_by_population"
table <- read_html(url) 
table <- table %>% 
  html_nodes('#mw-content-text table tbody') %>% 
  html_table(fill=T)

table <- table[[1]] %>% as.data.frame()




# Scrape wikipedia 2 ------------------------------------------------------


url <- "https://ca.wikipedia.org/wiki/Refer%C3%A8ndum_d%27independ%C3%A8ncia"
table <- read_html(url) 

table <- table %>% 
  html_nodes('.wikitable') %>% 
  html_table(fill=T)


table <- table %>% as.data.frame()


# Scraping abstract -----------------------------------------------------------


jop <- "https://www.journals.uchicago.edu/doi/full/10.1086/706053"

jop_page <- xml2::read_html(jop)

# Step 2 - Using CSS selectors to scrap title
jop_css <- html_nodes(jop_page, ".citation__title")

# Step 3 - Converting title data to text
jop_title <- html_text(jop_css)
jop_title




# Scraping ----------------------------------------------------------------


apsr <- "https://www.cambridge.org/core/journals/american-political-science-review/latest-issue"

issues.root.html <- read_html(apsr)
issue.urls <- issues.root.html %>%
  html_nodes(".part-link") 
print(issue.urls)


issue.urls <- issues.root.html %>%
  html_nodes(".part-link") %>% 
  html_attr("href") %>% # extract the links specified by `href`
  data.frame() 


issue.urls <- paste0("https://www.cambridge.org", issue.urls$.)
print(head(issue.urls))


#Extracting years of publication

pattern <- "(1|2)\\d{3}"

library("stringr")
issue.years <- issues.root.html %>%
  html_nodes(".published") %>% 
  html_text %>% # extract the links specified by `href`
    data.frame() %>% 
  mutate(years=as.numeric(str_extract(.,"(1|2)\\d{3}") )) %>% 
  select(-.) 

#Combine it
issue.df <- data.frame(issue = issue.urls, year = issue.years)
print(head(issue.df))


#construct a function that returns the abstract article given an article URL.



(read_html(issue.urls[1]) %>%
    html_nodes("p") %>%
    html_text())[3]

GetAbstract <- function (article.url) {
  (read_html(article.url) %>%
     html_nodes("p") %>%
     html_text())[3]
}


GetArticleURLs <- function (issue.url) {
  issue.html <- read_html(issue.url)
  article.urls <- issue.html %>% 
    html_nodes(".part-link") %>% 
    html_attr("href") %>% # extract the links specified by `href`
  paste0("https://www.cambridge.org", .) # transform relative urls
}

abstracts <- sapply(GetArticleURLs("https://www.cambridge.org/core/journals/american-political-science-review/latest-issue"), GetAbstract)

#abstracts <- abstracts[2:length(abstracts)] # the first abstract is empty (Front Matter)
df <- data.frame(abstracts)


library("quanteda")
corp <- corpus(abstracts, docvars = data.frame(abstracts = names(abstracts)))

print(corp)

summary(corp)

corp <- tokens(corp, remove_punct = TRUE)

dfmat_corp <- dfm(corp)


ndoc(dfmat_corp)
nfeat(dfmat_corp)

head(docnames(dfmat_corp), 3)

topfeatures(dfmat_corp, 10)


toks <- tokens(abstracts)
toks_nostop <- tokens_select(toks, pattern = stopwords("en"), selection = "remove")


toks <- tokens(abstracts, remove_punct = TRUE)
toks_ngram <- tokens_ngrams(toks, n = 2:4)
head(toks_ngram[[1]], 30)



toks <- tokens(corp, remove_punct = TRUE, remove_url = T) %>% 
  tokens_remove(c(stopwords("english")))
dfmat <- dfm(toks)

library("quanteda.textstats")

tstat_freq <- textstat_frequency(dfmat, n = 5)
tstat_freq

dfmat %>% 
  textstat_frequency(n = 15) %>% 
  ggplot(aes(x = reorder(feature, frequency), y = frequency)) +
  geom_point() +
  coord_flip() +
  labs(x = NULL, y = "Frequency") +
  theme_minimal()

library("quanteda.textplots")
set.seed(132)
textplot_wordcloud(dfmat, max_words = 10)
