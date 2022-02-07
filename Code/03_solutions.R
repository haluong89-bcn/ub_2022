###############################################
##########INTRODUCTION TO R####################
###############################################
###############################################


#TONI RODON
#www.tonirodon.cat
#@tonirodon

#Take-home exercise

#I am sorry but we will use covid data!

#Go to the repository of the Catalan government including number of vaccinations by municipality
#The website. Download the csv file
#https://dadescovid.cat/descarregues
#The dataset is this one "Vacunació per a COVID-19: dosis administrades per municipi"

#Open the dataset
df <- read.csv("Data/vacunacio_municipi.csv", header = TRUE)

#How many vaccines have been administered? (variable "recompte")
summary(df$RECOMPTE)
sum(df$RECOMPTE)

#What is the most prevalent vaccine producer? (variable "fabricant")
table(df$FABRICANT)

#What is the most prevalent vaccine producer by gender? cross-tab showing absolute numbers
table(df$FABRICANT, df$SEXE)

#What is the most prevalent vaccine producer by gender? cross-tab showing column-wise %
prop.table(table(df$FABRICANT, df$SEXE), 2)

#http://rstudio-pubs-static.s3.amazonaws.com/6975_c4943349b6174f448104a5513fed59a9.html
source("http://pcwww.liv.ac.uk/~william/R/crosstab.r")
crosstab(df, row.vars = "FABRICANT", col.vars = "SEXE", type = "c")
crosstab(df, row.vars = "FABRICANT", col.vars = "SEXE", type = "r")

#With the variable "recompte" (number vaccines), create a histogram (ggplot)
library("ggplot2")

ggplot(df) +
  geom_histogram(aes(RECOMPTE)) 

#Create the log of "recompte" and plot a histogram
df$logcount <- log(df$RECOMPTE)

ggplot(df) +
  geom_histogram(aes(logcount)) 

#Create a dataframe with the count of vaccine producers
dfdata <- df %>% 
        group_by(FABRICANT) %>% 
      summarise(count = sum(RECOMPTE))

#Plot a bar graph (use geom_bar and stat='identity')
ggplot(dfdata) +
  geom_bar(aes(x=FABRICANT, y=count),stat='identity') 

dfdata$FABRICANT <- factor(dfdata$FABRICANT,      
                  levels = dfdata$FABRICANT[order(dfdata$count, 
                                                  decreasing = TRUE)])
ggplot(dfdata) +
  geom_bar(aes(x=FABRICANT, y=count),stat='identity') 

#Calculate the percentage of vaccine type over the total number of vaccines administered
sum(dfdata$count)
dfdata$total <- 6297158
dfdata$ptype <- (dfdata$count * 100) / dfdata$total

#Plot a bar graph with these percentages
ggplot(dfdata) +
  geom_bar(aes(x=FABRICANT, y=ptype),stat='identity') 

#Create a dataframe with the number of vaccines administered every day
dfevol <- df %>% 
  group_by(DATA) %>% 
  summarise(count = sum(RECOMPTE))

#Create a graph showing the evolution of vaccines administered every day
# https://www.r-graph-gallery.com/line-chart-ggplot2.html
# warning: convert DATA to date

dfevol$date <- as.Date(dfevol$DATA, format =  "%d/%m/%Y")
  
ggplot(dfevol, aes(x=date, y=count)) +
  geom_line( color="blue",  alpha=0.9) +
  theme_ipsum() +
  ggtitle("Evolution of vaccination")

#Back to the original dataset.Create a new dataset with 
#Count the number of vaccines by municipality.
#Count the number of men
#keep the MUNICIPI_CODI variable
dfmun <- df %>% 
  group_by(MUNICIPI) %>% 
  summarise(count = sum(RECOMPTE),
            countmen = sum(SEXE_CODI),
            munid = max(MUNICIPI_CODI))

#What is the municipality with the highest number of vaccines administered
max(dfmun$count)
dfmun %>% slice_max(count)

#What is the municipality with the lowest number of vaccines administered
min(dfmun$count)
dfmun %>% slice_min(count)

#DIFFICULT EXERCISE! (or not... we'll see)

#Remember the dataset cat_2017? Let's import it (population tab)
df_pop <- read.xlsx("Data/cat_2017.xlsx", sheet = "population", na.strings = "..")

#We now want to merge the population dataset with the newly created dataset on vaccines at the municipality level
#WARNING: THE VACCINE DATASET HAS FEWER CASES.
#WARNING 2: the unique code is not the same. We need to add a leading zero in the vaccine dataset and remove the last digit in the population dataset
#WARNING 3: remove missing in vaccine dataset (two missing in municipality code)

library("stringr")
dfmun$munid <- str_pad(dfmun$munid, 5, pad = "0")
df_pop$codi <- str_pad(df_pop$codi, 6, pad = "0")

df_pop$codi <- substr(df_pop$codi, start = 1, stop = 5)

dfmun <- na.omit(dfmun, cols="munid")

df <- left_join(df_pop, dfmun, by=c("codi"="munid"))


#With the new dataset, calculate the % of men vaccinated
df$vaccinated <- (df$countmen *100)/df$total
hist(df$vaccinated)

#plot a scatterplot between the % of men vaccinated and the % of young people
df$young <- (df$de0_14anys*100) / df$total

hist(df$young)

ggplot(df, aes(x=young, y=vaccinated)) +
  geom_point(size=2) +
  geom_smooth(method=lm) 

#final exercise: create a gem density ridge with comarca(county) and the log of vaccines
#https://www.r-graph-gallery.com/294-basic-ridgeline-plot.html
df$logcount <- log(df$count)

library("ggridges")

ggplot(df, aes(x = logcount, y = nom_comarca, fill = nom_comarca)) +
  geom_density_ridges() +
  theme_ridges() + 
  theme(legend.position = "none")





