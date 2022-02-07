###############################################
##########INTRODUCTION TO R####################
###############################################
###############################################


#TONI RODON
#www.tonirodon.cat
#@tonirodon

rm(list = ls())



# Wikipedia -----------------------------------------------------------



library("wikipediatrend")

# Extraer datos

trend_data <- 
  wp_trend(
    page = c("Universitat de Barcelona", "Universitat Pompeu Fabra"), 
    lang = c("ca"), 
    from = "2019-01-01",
    to   = "2022-02-01"
  )

plot(trend_data)


# get pageviews
library("pageviews")

perearagones <-
  article_pageviews(
    project = "ca.wikipedia",
    article = "Pere Aragonès i Garcia",
    user_type = "user",
    start = "2020010100",
    end = "2020123100"
  )
head(perearagones)

lauraborras <-
  article_pageviews(
    project = "ca.wikipedia",
    article = "Laura Borràs i Castanyer",
    user_type = "user",
    start = "2020010100",
    end = "2020123100"
  )
head(lauraborras)


df <- rbind(perearagones,lauraborras)

library("ggplot2")
ggplot(df) +
  geom_line(aes(x=date,y=views,colour=article))




# Google trends -----------------------------------------------------------


library("gtrendsR")
library("tidyverse")
library("dplyr")

res <- gtrends(c("Barcelona", "Girona"))

dfs <- res$interest_over_time

dfs2020 <- dfs %>% 
  filter(date > as.Date("2020-01-01"))

dfs2020 %>% 
  ggplot() + geom_line(aes(x = date,
                           y = hits,
                           color = keyword)) +
  theme_minimal() +
  labs(title = "Barcelona vs Girona - in 2020",
       subtitle = "Google Trends Report",
       caption = "Courtesy: gtrendsR package")



# Twitter -----------------------------------------------------------------


library("rtweet")

result <- lookup_users("tonirodon")

library("dplyr")
result <- lookup_users("tonirodon")
glimpse(result)


dftania <- get_timeline(user="taniaverge", n=50)


tv_rtweet <- search_tweets("Tània Verge", include_rts = T, lang = "ca")
va_rtweet <- search_tweets("_VictoriaAlsina", include_rts = T, lang = "ca")


library("lubridate")
library("ggplot2")

# First, we will combine both dataframes
tweets_all <- bind_rows(tv_rtweet %>% 
                          mutate(entity="Tània Verge"),
                        va_rtweet %>% 
                          mutate(entity="Victòria Alsina")) 

# Next, we will aggregate tweets into the hour-long unit of time and count the time variable by hours
tweets_hours <- tweets_all %>% 
  mutate(time_floor = floor_date(created_at, unit = "hour")) %>% 
  count(entity, time_floor)

# Now, we are ready to visualize the time-series data counting tweets by hours
tweets_hours %>%
  ggplot(aes(x=time_floor, y=n, color=entity)) +
  geom_line() +
  theme_bw() +
  labs(x = NULL, y = "Hourly Sum",
       title = "Twitter activity",
       subtitle = "Tweets were aggregated in 1-hour intervals. Retweets were excluded.")



rstats_tweets_rtweet <- search_tweets("#RStats", n = 1800, include_rts = FALSE) # Gather tweets from anywhere

# And create lat(latitude) and lng(longtitude) variables using all avaiable geolocation info.
rstats_tweets_rtweet_b <- lat_lng(rstats_tweets_rtweet) %>% 
  group_by(lng,lat) %>% 
  summarise(sum = n()) %>% 
  filter(!is.na(lng)|!is.na(lat))



## preview users data
users_data(rstats_tweets_rtweet)

## plot time series (if ggplot2 is installed)
ts_plot(rstats_tweets_rtweet)

ts_plot(rstats_tweets_rtweet, "3 hours") +
  ggplot2::theme_minimal() +
  ggplot2::theme(plot.title = ggplot2::element_text(face = "bold")) +
  ggplot2::labs(
    x = NULL, y = NULL,
    title = "Frequency of #rstats Twitter statuses from past 9 days",
    subtitle = "Twitter status (tweet) counts aggregated using three-hour intervals",
    caption = "\nSource: Data collected from Twitter's REST API via rtweet"
  )
 

library("emoji")
library("tidyr")
library("tidytext")
library("stringr")


e <- rstats_tweets_rtweet %>%
  mutate(emoji = emoji_extract(text)) %>%
  unnest(cols = c(emoji)) %>%
  count(emoji, sort = TRUE) %>%
  top_n(10)


h <- rstats_tweets_rtweet %>% 
  unnest_tokens(hashtag, text, "tweets", to_lower = FALSE) %>%
  count(hashtag, sort = TRUE) %>%
  top_n(10)



words <- rstats_tweets_rtweet %>%
  mutate(text = str_remove_all(text, "&amp;|&lt;|&gt;"),
         text = str_remove_all(text, "\\s?(f|ht)(tp)(s?)(://)([^\\.]*)[\\.|/](\\S*)"),
         text = str_remove_all(text, "[^\x01-\x7F]")) %>% 
  unnest_tokens(word, text, token = "tweets") %>%
  filter(!word %in% stop_words$word,
         !word %in% str_remove_all(stop_words$word, "'"),
         str_detect(word, "[a-z]"),
         !str_detect(word, "^#"),         
         !str_detect(word, "@\\S+")) %>%
  count(word, sort = TRUE)


library("wordcloud") 
words %>% 
  with(wordcloud(word, n, random.order = FALSE, max.words = 100, colors = "#F29545"))







