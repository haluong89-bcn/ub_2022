# Load the required libraries
library(janeaustenr)
#install.packages("tidytext")
library(tidytext)
library(dplyr)


library(stringr)

# Jane Austen's 6 completed from  janeaustenr package and transform them into a tidy formata one-row-per-line format 
original_books <- austen_books() %>%
  group_by(book) %>%
  mutate(linenumber = row_number(),
         chapter = cumsum(str_detect(text, regex("^chapter [\\divxlc]",
                                                 ignore_case = TRUE)))) %>%
  ungroup()

original_books


# Restructuring it to as one-token-per-row format

library(tidytext)
tidy_books <- original_books %>%
  unnest_tokens(word, text)

tidy_books


# We can manipulate it with tidy tools like dplyr.We can remove stop words with an anti_join.
data("stop_words")
cleaned_books <- tidy_books %>%
  anti_join(stop_words)


# Use count to find the most common words
cleaned_books %>%
  count(word, sort = TRUE)

library("textdata")
# Sentiment analysis to find the most common joy word un the novel Emma
nrcjoy <- get_sentiments("nrc") %>%
  filter(sentiment == "joy")

tidy_books %>%
  filter(book == "Emma") %>%
  semi_join(nrcjoy) %>%
  count(word, sort = TRUE)


# How sentiment changes during each novel

library(tidyr)
bing <- get_sentiments("bing")

janeaustensentiment <- tidy_books %>%
  inner_join(bing) %>%
  count(book, index = linenumber %/% 80, sentiment) %>%
  spread(sentiment, n, fill = 0) %>%
  mutate(sentiment = positive - negative)

# Plot these sentiment scores across the plot trajectory of each novel.
library(ggplot2)

ggplot(janeaustensentiment, aes(index, sentiment, fill = book)) +
  geom_bar(stat = "identity", show.legend = FALSE) +
  facet_wrap(~book, ncol = 2, scales = "free_x")

# Most common positive and negative words

bing_word_counts <- tidy_books %>%
  inner_join(bing) %>%
  count(word, sentiment, sort = TRUE) %>%
  ungroup()

bing_word_counts

# Visually we can pipe straight into ggplot2

bing_word_counts %>%
  filter(n > 150) %>%
  mutate(n = ifelse(sentiment == "negative", -n, n)) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(word, n, fill = sentiment)) +
  geom_bar(stat = "identity") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  ylab("Contribution to sentiment")



# Horror movies -----------------------------------------------------------


# Horror Movies 22/10/2019
# Source (YouTube): https://www.youtube.com/watch?v=yFRSTlk3kRQ
# Tidytuesdays source (Github) : https://github.com/rfordatascience/tidytuesday 
# Original code from David Robinson: https://github.com/dgrtwo/data-screencasts


library(tidyverse)
library(scales)
library(tidytext)
library(glmnet)
library(Matrix)
library(broom)
theme_set(theme_minimal())

# DATA --------------------------------------------------------------------
horror_movies_raw <- read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-10-22/horror_movies.csv")

# EDA ---------------------------------------------------------------------

# General
glimpse(horror_movies_raw)

# Better ratings
horror_movies_raw %>% 
  arrange(desc(review_rating)) %>% 
  View()

# Extract year
horror_movies <- horror_movies_raw %>% 
  arrange(desc(review_rating)) %>% 
  extract(title, "year", "\\((\\d\\d\\d\\d)\\)$", remove = FALSE, convert = TRUE) %>% 
  mutate(
    budget = parse_number(budget) #removing dollar format
  )

# No year
horror_movies %>% 
  filter(is.na(year)) %>% 
  pull(title)

# Distribution 
horror_movies %>% 
  filter(year >= 2005) %>% 
  ggplot(aes(year)) +
  geom_histogram() # Most of the movies are since 2012

# Other variables
horror_movies %>% 
  count(genres, sort = TRUE)

horror_movies %>% 
  count(language, sort = TRUE)

horror_movies %>% 
  count(budget, sort = TRUE)

horror_movies %>% 
  ggplot(aes(budget)) +
  geom_histogram() +
  scale_x_log10(labels = dollar) 

# Do higher budget movies end up higher rated? -> No relationship
horror_movies %>% 
  ggplot(aes(budget, review_rating)) +
  geom_point() +
  scale_x_log10(labels = dollar) +
  geom_smooth(method = "lm")

# How about movie rating and review
horror_movies %>% 
  count(movie_rating, sort = TRUE)

horror_movies %>% 
  mutate(
    movie_rating = fct_lump(movie_rating, 5)
  )

horror_movies %>% 
  mutate(
    movie_rating = fct_lump(movie_rating, 5),
    movie_rating = fct_reorder(movie_rating, review_rating, na.rm = TRUE)
  ) %>% 
  ggplot(aes(movie_rating, review_rating)) +
  geom_boxplot() +
  coord_flip()

horror_movies %>% 
  filter(!is.na(movie_rating)) %>% 
  mutate(
    movie_rating = fct_lump(movie_rating, 5)
  ) %>% 
  lm(review_rating ~ movie_rating, data = .) %>% 
  anova() #F value an p value show it's not by chance

# Genres
horror_movies %>% 
  count(genres, sort = TRUE) #Films have several genres at the same time

horror_movies %>% 
  separate_rows(genres, sep = "\\| ") %>% #duplicates movies with several genres
  select(title, year, genres) %>% 
  count(genres, sort = TRUE)

horror_movies %>% 
  separate_rows(genres, sep = "\\| ") %>% #duplicates movies with several genres
  mutate(
    genre = fct_lump(genres, 5),
    genre = fct_reorder(genre, review_rating, na.rm = TRUE)
  ) %>% 
  ggplot(aes(genre, review_rating)) +
  geom_boxplot()


#text mining
horror_movies %>% 
  head() %>% 
  pull(plot)

horror_movies %>% 
  mutate(
    plot = str_remove(plot, "Directed.*?\\.") #Begins with Directed and ends with dot
  ) %>% 
  head() %>% 
  pull(plot)

horror_movies %>% 
  separate(plot, c("director", "cast_sentence", "plot"), 
           extra = "merge", sep = "\\. ", fill = "right") %>% 
  head() %>% 
  pull(plot)

# Tidytext
horror_movies2 <- horror_movies %>% 
  separate(plot, c("director", "cast_sentence", "plot"), 
           extra = "merge", sep = "\\. ", fill = "right") %>% 
  distinct(title, .keep_all = TRUE) # There are duplicated tittles

horror_movies_unnested <- horror_movies2 %>% 
  unnest_tokens(word, plot) %>% 
  anti_join(stop_words, by = "word") %>% 
  filter(!is.na(word))

horror_movies_unnested %>% 
  count(word, sort = TRUE)

horror_movies_unnested %>% 
  filter(!is.na(review_rating)) %>% 
  group_by(word) %>% 
  summarize(
    movies = n(),
    avg_rating = mean(review_rating)
  ) %>% 
  arrange(desc(movies)) %>% 
  filter(movies >= 100) %>% 
  mutate(
    word = fct_reorder(word, avg_rating)
  ) %>% 
  ggplot(aes(avg_rating, word)) +
  geom_point()


#MODEL: LASSO REGRESSION

#Lasso regression for predicting review rating based on words in plot

# Duplicated tittles?
horror_movies2 %>% 
  count(title, sort = TRUE) # Yes, corrected in previous steps

movie_word_matrix <- horror_movies_unnested %>% 
  filter(!is.na(review_rating)) %>% 
  add_count(word) %>% 
  filter(n >= 20) %>% 
  count(title, word) %>% 
  cast_sparse(title, word, n)

dim(movie_word_matrix)

rownames(movie_word_matrix)

rating <- horror_movies2$review_rating[match(rownames(movie_word_matrix), 
                                             horror_movies2$title)]
qplot(rating)

# glmnet
lasso_model <- cv.glmnet(movie_word_matrix, rating)

lasso_model$glmnet.fit
tidy(lasso_model$glmnet.fit) 


# Lambda (penalty parameter)
lasso_model$glmnet.fit
tidy(lasso_model$glmnet.fit) %>% 
  filter(term %in% c("friends", "evil", "college", "haunted", "mother")) %>% 
  ggplot(aes(lambda, estimate, color = term)) + 
  geom_line() +
  scale_x_log10() +
  geom_hline(yintercept = 0, lty = 2)

plot(lasso_model)

lasso_model$lambda.min

tidy(lasso_model$glmnet.fit) %>% 
  filter(lambda == lasso_model$lambda.min,
         term != "(Intercept)") %>% 
  mutate(term = fct_reorder(term, estimate)) %>% 
  ggplot(aes(term, estimate)) +
  geom_col() +
  coord_flip()

lasso_model$glmnet.fit
tidy(lasso_model$glmnet.fit) %>% 
  filter(term %in% c("quickly", "seek", "army", "teacher", "unexpected",
                     "friends", "evil")) %>% 
  ggplot(aes(lambda, estimate, color = term)) + 
  geom_line() +
  scale_x_log10() +
  geom_hline(yintercept = 0, lty = 2) +
  geom_vline(xintercept = lasso_model$lambda.min)

#Throwing everything into a linear model: director, cast, genre, rating, plot words

horror_movies2 %>% 
  select(title, genres, director, cast) %>% 
  mutate(director = str_remove(director, "Directed by ")) %>% 
  count(director, sort = TRUE)


horror_movies2 %>% 
  select(title, genres, director, cast) %>% 
  mutate(director = str_remove(director, "Directed by ")) %>%
  gather(type, value, -title) 

horror_movies2 %>% 
  select(title, genres, director, cast) %>% 
  mutate(director = str_remove(director, "Directed by ")) %>%
  gather(type, value, -title) %>% 
  separate_rows(value, sep = "\\| ?") %>%  # ? means space is optional
  count(type, value, sort = TRUE) %>% 
  View()


