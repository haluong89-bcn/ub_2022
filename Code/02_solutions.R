###############################################
##########INTRODUCTION TO R####################
###############################################
###############################################


#TONI RODON
#www.tonirodon.cat
#@tonirodon

#you will be working with a comparative dataset
#Extracted from V-Dem 
#https://www.v-dem.net/en/data/data-version-10/

rm(list=ls())

#Import the dataset into R (hint: library readstata13)
library("readstata13")
df <- read.dta13("Data/V-Dem.dta", nonint.factors = TRUE) 


#The codebook of the variables is the following: 
#country_name - Country name
#year - year of the observation
#v2x_polyarchy - polyarchy index To what extent is the ideal of electoral democracy in its fullest sense achieved? 0 -1
#0.0 as "Autocratic", 0.5 as "Electoral Authoritarian", and 1.0 as "Minimally Democratic".
#v2eltype_0 Legislative elections; lower, sole, or both chambers, first or only round (0=No, 1=Yes)
#v2eltype_0 Legislative elections; lower, sole, or both chambers, first or only round (0=No, 1=Yes)
#v2eltrnout In this national election, what percentage (%) of all registered voters cast a vote according to official results?
#v2elloelsy What was the electoral system used in this election for the lower or unicameral chamber of the legislature?
#majoritarian 0-4, mixed 5-6,  PR electoral systems are: 7-12 
#v2ddlexrf Referendums permitted 0 not allowed 1 allowed but non-binding 2 allowed and binding. 
#v2exl_legitideol To what extent does the current government promote a specific ideology or societal model (an officially codified set of beliefs used to justify a particular set of social, political, and
#economic relations; for example, socialism, nationalism, religious traditionalism, etc.) in order to justify the regime in place? scale indicator
#v2x_gender Women political empowerment index 0 -1
#v2x_elecreg Electoral regime index At this time, are regularly scheduled national elections on course, as stipulated by election law or well-established precedent?
#0 No 1 Yes
#e_migdpgro Gdp growth


#Use ggplot and create a histogram of the polyarchy index
library("tidyverse")
library("ggplot2")

ggplot(df,aes(v2x_polyarchy)) +
  geom_histogram() 

#Create the same histogram but, 
#this time, add a red dashed vertical line that corresponds 
#with the mean value (hint geom_vline)

ggplot(df,aes(v2x_polyarchy)) +
  geom_histogram() +
  geom_vline(xintercept = 0.3868, colour="red", 
             linetype="dashed")


ggplot(df,aes(v2x_polyarchy)) +
  geom_histogram() +
  geom_vline(xintercept = mean(df$v2x_polyarchy, na.rm = T), 
             colour="red")


#Turn v2eltype_0 into a factor and give it labels. 
#Then plot it.
df$electype <- factor(df$v2eltype_0,
                      levels = c(0,1),
                      labels = c("No", "Legislative election"))

plot(df$electype)

ggplot(df) +
  geom_bar(aes(electype))

#Create a scatterplot between polyarchy and turnout. 
#Is there a relationship?
ggplot(df, aes(y=v2x_polyarchy, x=v2eltrnout)) +
  geom_point(size=2, shape=23) +
  geom_smooth(method=lm)

#Extract the mean value of polyarchy and turnout by country
dfmean <- df %>% 
  group_by(country_name) %>% 
  summarise(meanpol=mean(v2x_polyarchy, na.rm = T),
            meanturnout=mean(v2eltrnout, na.rm = T))

#Create a factor so that 0 if meanpol<0.5 and 1 if meanpol>0.5
dfmean <- dfmean %>%  
  mutate(democracy = ifelse(meanpol > 0.5, 1, 0))

#Create two scatterplots, one for democracy =1 and the 
#other for democracy=0
ggplot(dfmean, aes(y=meanpol, x=meanturnout)) +
  geom_point(size=2, shape=23) +
  facet_grid(rows = vars(democracy)) +
  geom_smooth(method=lm) 
 
#back to the original (big) dataset. 
#Select 6 countries (free to choose!)
dfsix <- df %>% 
  filter(country_name == "Mexico" | 
           country_name == "Argentina" |
           country_name == "South Korea"| 
           country_name == "United States of America" | 
           country_name == "Canada" | 
           country_name == "Portugal")

dfsix <- df %>% 
  filter(country_name %in% c("Mexico", "Argentina", "South Korea",
                             "United States of America", "Canada", "Portugal"))

#Create a graph that shows the evolution of gdp 
#growth over time 
#(hint: geom_line and remember to use group)

dfsix$country <- as.factor(dfsix$country_name)

library("hrbrthemes")
library("ggthemes")

ggplot(dfsix) +
  geom_line(aes(x=year, y=e_migdpgro, 
                group=country, colour=country)) +
  theme(legend.position="bottom") +
  theme_classic()


#  theme_wsj()
  #theme_economist()
#  theme_ipsum() 
#

#Create the same graph but one for each of the six 
#countries (hint: facet_wrap)

ggplot(dfsix) +
  geom_line(aes(x=year, y=e_migdpgro)) +
  facet_wrap(~country) 


#Create exactly the same graph, but this time it 
#should be a point graph (geom_point) and add a 
#loess curve (hint: geom_smooth)

ggplot(dfsix,aes(x=year, y=e_migdpgro)) +
  geom_point() +  
  facet_wrap(~country) +
  geom_smooth(method = "loess", color="blue") 


#Create a dataset with the mean of ideology, gender, 
#polyarchy and gdp growth (remember the missing values) by country
dfmean <- df %>% 
  group_by(country_name) %>% 
summarise(meanidol = mean(v2exl_legitideol, na.rm = T),
          meangender = mean(v2x_gender, na.rm = T),
          meanpoly = mean(v2x_polyarchy, na.rm = T),
          meangdp = mean(e_migdpgro, na.rm = T))

#Check if there are missing values
table(is.na(dfmean))

#Drop rows with missing
dfmean <- dfmean[complete.cases(dfmean), ]

#Calculate the correlation between all the variables in this dataset (remember Hmisc!)
library("Hmisc")

rcorr(as.matrix(dfmean[,2:5]))

#Create a correlation plot with squares
library("corrplot")
corrplot(cor(dfmean[,2:5]), method="square")

#Almost at the end of this script. 
#Recode the variable electoral system and give it three values
#Remember:v2elloelsy majoritarian 0-4, mixed 5-6,  PR electoral systems are: 7-12 
#Remember 2: you also need to turn it into a factor

df$esystem[df$v2elloelsy<5] <- 0
df$esystem[df$v2elloelsy>=5 & df$v2elloelsy<=6] <- 1
df$esystem[df$v2elloelsy>6] <- 2
table(df$esystem)
class(df$esystem)

df$esystem <- as.factor(df$esystem)

#Calculate the average value of polyarchy and turnout by electoral system type
dfavg <- df %>% 
  group_by(country_name,esystem) %>% 
  summarise(meanpol = mean(v2x_polyarchy, na.rm = T),
         meanturnout = mean(v2eltrnout, na.rm = T)) 

#Plot the relationship between polyarchy and turnout in majoritarian, mixed and proportional systems
ggplot(dfavg,aes(x=meanturnout, y=meanpol)) +
  geom_point() +  
  facet_wrap(~esystem) +
  geom_smooth(method = "loess", color="blue") 

#Describe data
library("psych")
describe(dfavg)

#Regression
out <- lm(v2x_polyarchy ~ e_migdpgro + v2exl_legitideol + esystem ,data=df)
summary(out)

library("broom")
tidy(out)            
augment(out)

library("jtools")
summ(out)

#let's turn the data from long to wide
#subset dfsix
dfsixsmall <- select(dfsix, country_name, year, v2x_polyarchy, v2x_gender)

#keep three years
dfsixsmall <- dfsixsmall %>% 
          filter(year>2016) %>% 
        rename(polyarchy = v2x_polyarchy,
              gender = v2x_gender)

#from long to wide
wide <- dfsixsmall %>%
  pivot_wider(names_from = "country_name", values_from = polyarchy:gender)


wide <- dfsixsmall %>%
  pivot_wider(names_from = "year", values_from = polyarchy:gender)


#From wide to long
p <-  dfsixsmall %>%
  gather(country_name, "Year", starts_with("*_"))
