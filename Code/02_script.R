###############################################
##########INTRODUCTION TO R####################
###############################################
###############################################


#TONI RODON
#www.tonirodon.cat
#@tonirodon

rm(list = ls())

setwd("/")

#Open election results and population data
#install.packages("openxlsx")
library("openxlsx")
df_elec <- read.xlsx("Data/cat_2017.xlsx", sheet = "elections", na.strings = "..")
df_pop <- read.xlsx("Data/cat_2017.xlsx", sheet = "population", na.strings = "..")

install.packages("tidyverse")
library("tidyverse")

#join the datasets
df <- left_join(df_elec, df_pop)

#Select blanks, nulls and men
df2 <- select(df, blancs, nuls, homes)
df2 <- select(df, blancs:homes)

#Calculate % voters participated in the election
df$turnout <- (df$votants/df$electors)
hist(df$turnout)

#Create a dataset with municipalities where turnout was higher than 80%
df80 <- filter(df,turnout>0.799)
df80 <- arrange(df80,desc(turnout))

#Calculate percentage of women per municipality
dfw <- mutate(df, pwomen=((dones/total)*100),0)

#And now it's time of welcoming the use of pipe %>% 
dfnew <- df %>% 
        mutate(pblank=(blancs/electors)*100) %>% 
  arrange(desc(pblank))


dfaverage <- df %>% 
  group_by(nom_comarca) %>% 
  summarize(n()) 

dfaverage <- df %>% 
  group_by(nom_comarca) %>% 
  summarize(n(), mean_turnout = mean(turnout, na.rm = TRUE)) 

dfaverage <- df %>% 
  group_by(nom_comarca) %>%  #grouping by country
  add_tally() %>%  #adding the number of obs by county
  mutate(pyoung = (de0_14anys/total)*100) %>% 
  group_by(nom_comarca) %>% 
  summarize(n(), mean_young = mean(pyoung, na.rm = TRUE))


#Time to plot!
library("ggplot2")

ggplot(dfnew,aes(pblank)) +
  geom_histogram() 

ggplot(dfnew,aes(pblank)) +
  geom_histogram() +
  stat_bin(bins = 10)

ggplot(dfnew,aes(pblank)) +
  geom_histogram(aes(y = (..count..)/sum(..count..))) 

#What is the relationship between turnout and the percentage of women in a municipality?
names(df)

df <- df %>% 
  mutate(pwomen = (dones/total)*100)

hist(df$pwomen)

cor(df$pwomen, df$turnout, use = "complete.obs")
cor.test(df$pwomen, df$turnout, use = "complete.obs")

#Let's say we want to extract a correlation matrix of different columns
p <- df %>% 
  mutate_at(c(3:9), ~ ((./electors)*100)) %>% 
  select(c(1:9)) %>% 
  rename_at(c(3:9), ~paste0("p_",.))

z <- df %>% 
  mutate_at(c(3:9), ~ ((./electors)*100)) %>% 
  select(c(1:9)) %>% 
  rename(pcs = cs ,
         pjxcat = jxcat  ,
         perc = erc  ,
         ppsc = psc  ,
         ppodem = podem  ,
         pcup = cup  ,
         ppp = pp  )

df <- left_join(df,p)

#Let's visualize the data

ggplot(df, aes(x=p_erc, y=p_cs)) +
  geom_point(size=2, shape=23) +
  geom_smooth(method=lm) +
     geom_text(aes(label=municipi), size=3) 
  #geom_text(label=rownames(df$municipi)) +
#geom_smooth()


library("ggpubr")

ggscatter(df, x = "p_erc", y = "p_cs",
          add = "loess", conf.int = TRUE,
          cor.coef = TRUE, cor.method = "pearson",
          xlab = "ERC", ylab = "Cs")


library("Hmisc")
cor_2 <- rcorr(as.matrix(df[,26:32]))
cor_2

library("corrplot")

dfcor <- df[,26:32]
dfcor <- dfcor[complete.cases(dfcor), ]
dfcor <- as.matrix(dfcor)

corrplot(cor(dfcor), method="circle")

corrplot(cor(dfcor), method="square")

corrplot(cor(dfcor), method="ellipse")

corrplot(cor(dfcor), method="number")

#Let's work with different type of variables

glimpse(df)

library("skimr")
skim(df)


#Numeric
class(df$p_cup)
summary(df$p_cup)

#Character
class(df$municipi)

#Factor
class(df$turnout)
summary(df$turnout)
fivenum(df$turnout)

df$turnoutfactor <- NA
df$turnoutfactor[df$turnout>0.50 & df$turnout<0.82] <- 0
df$turnoutfactor[df$turnout>0.81 & df$turnout<0.87] <- 1
df$turnoutfactor[df$turnout>0.86 & df$turnout<0.97] <- 2
class(df$turnoutfactor)
hist(df$turnoutfactor)
plot(df$turnoutfactor)

df$test <- as.factor(df$turnoutfactor)
class(df$test)
levels(df$test)
plot(df$test)

table(df$turnoutfactor)

df$turnoutfactor <- factor(df$turnoutfactor,
                           levels = c(0,1,2),
                           labels = c("Low", "Moderate", "High"))

class(df$turnoutfactor)
levels(df$turnoutfactor)
plot(df$turnoutfactor)
table(df$turnoutfactor)


#Logical
df$logical <- df$turnout<0.84
class(df$logical)
table(df$logical)











