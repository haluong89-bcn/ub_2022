###############################################
##########INTRODUCTION TO R####################
###############################################
###############################################


#TONI RODON
#www.tonirodon.cat
#@tonirodon

rm(list = ls())

library("rvest")
library("dplyr")

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


jop <- "https://doi.org/10.1086/706053"

jop_page <- xml2::read_html(jop)

# Step 2 - Using CSS selectors to scrap title
jop_css <- html_nodes(jop_page, ".citation__title")

# Step 3 - Converting title data to text
jop_title <- html_text(jop_css)
jop_title




# Scraping apsr ----------------------------------------------------------------


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


corpdf <- corpus(df, text_field = c("abstracts"))  
summary(corpdf)
corpdf[1]
corpdf[[1]]

library("qdap")
frequent_terms <- freq_terms(corpdf, 3)
plot(frequent_terms)


doc.tokens <- tokens(corpdf)

doc.tokens <- tokens_select(doc.tokens, stopwords('english'),selection='remove')
doc.tokens <- tokens_wordstem(doc.tokens)
doc.tokens <- tokens_tolower(doc.tokens)
doc.dfm.final <- dfm(doc.tokens)


head(kwic(doc.tokens, "vote", window = 3))

frequent_terms <- freq_terms(doc.tokens, 3)
plot(frequent_terms)




# Scraping amazon ---------------------------------------------------------


library("xml2") 
library("rvest")
library("stringr")

url <- "https://www.amazon.es/s?k=r+data+science&__mk_es_ES=%C3%85M%C3%85%C5%BD%C3%95%C3%91&ref=nb_sb_noss_2"

#Read content
webpage <- read_html(url)


#Let's get the titles
css_product <- ".s-line-clamp-4" # CSS selector

product_html <- html_nodes(webpage,css_product)
product_html <- html_text(product_html)
product_html

product_html <- str_replace_all(product_html, "[\r\n\t]" , "")
product_html

product_html <- str_trim(product_html)
product_html

df <- data.frame(product_html)




