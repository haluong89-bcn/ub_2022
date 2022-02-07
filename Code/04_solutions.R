###############################################
##########INTRODUCTION TO R####################
###############################################
###############################################


#TONI RODON
#www.tonirodon.cat
#@tonirodon

#assign("last.warning", NULL, envir = baseenv())

#Go to the European Social Survey website and download a dataset for one country (stata version)
#https://www.europeansocialsurvey.org/data/country_index.html
rm(list=ls())

library("readstata13")
dfes <- read.dta13("Data/ESS9ES.dta", 
                   nonint.factors = TRUE) 


#Our outcome will be stflife: How satisfied with life as a whole
#Our explanatory variables will be the following:
#gndr gender
#agea age
#lrscale: LR position
#hinctnta household income 
#party R voted for. The variable name is different in each country. it always starts with prtv. For instance, prtvtees refers to Spain
#nwspol: News about politics and current affairs, watching, reading or listening, in minutes 

#Select these variables and put them into a new dataframe
dfes <- select(dfes, idno, stflife, gndr, agea, lrscale, 
               hinctnta, prtvtees, nwspol)


#Create a barplot of stflife
class(dfes$stflife)
dfes$stflife <- as.numeric(dfes$stflife)

dfes$sat[dfes$stflife==1] <- 0
dfes$sat[dfes$stflife==2] <- 1
dfes$sat[dfes$stflife==3] <- 2
dfes$sat[dfes$stflife==4] <- 3
dfes$sat[dfes$stflife==5] <- 4
dfes$sat[dfes$stflife==6] <- 5
dfes$sat[dfes$stflife==7] <- 6
dfes$sat[dfes$stflife==8] <- 7
dfes$sat[dfes$stflife==9] <- 8
dfes$sat[dfes$stflife==10] <- 9
dfes$sat[dfes$stflife==11] <- 10

summary(dfes$sat)
table(dfes$sat)

ggplot(dfes) +
  geom_bar(aes(stflife))

#Recode gender and turn it into a factor
table(dfes$gndr)
class(dfes$gndr)

dfes$gender[dfes$gndr=="Female"] <- "Woman"
dfes$gender[dfes$gndr=="Male"] <- "Man"
dfes$gender <- as.factor(dfes$gender)

table(dfes$gender)

#Convert age into a categorical variable
dfes$age_cat <- cut(dfes$agea, breaks=4)
table(dfes$age_cat)

#Create a scatterplot between household income and life satisfaction (we are going to assume H.income is continuous)
#don't worry. They are both semi-continuous variables. Add a regression line.

class(dfes$hinctnta)
table(dfes$hinctnta)

dfes$income <- as.numeric(dfes$hinctnta)
table(dfes$income)


ggplot(dfes,aes(x=income, y=sat)) +
  geom_point() +
  geom_smooth(method=lm)

#Calculate average value of life satisfaction for 
#each income level (remember missing values) and plot it

dfavg <- dfes %>% 
    group_by(income) %>% 
  summarise(sat = mean(sat, na.rm = T))

ggplot(dfavg, aes(y=sat, x= income)) +
  geom_bar(stat="identity") +
  theme_classic()

#Calculate average value of life satisfaction for each income level for men and for women (remember missing values) and plot it
#hint: to plot it, use the option fill and position=position_dodge()

dfavg <- dfes %>% 
  group_by(income, gender) %>% 
  summarise(sat = mean(sat, na.rm = T))

ggplot(dfavg, aes(y=sat, x= income, fill=gender)) +
  geom_bar(stat="identity", position=position_dodge()) 


#Recode party R voted for and turn it into a factor

table(dfes$prtvtees)

dfes$party[dfes$prtvtees=="PP"] <- "PP"
dfes$party[dfes$prtvtees=="PSOE"] <- "PSOE"
dfes$party[dfes$prtvtees=="Unidas Podemos"] <- "Podemos"
dfes$party[dfes$prtvtees=="VOX"] <- "Vox"

dfes$party <- as.factor(dfes$party)

plot(dfes$party)

#Recode news consumption into a binary indicator and turn it into a factor

hist(dfes$nwspol)
table(dfes$nwspol)
summary(dfes$nwspol)

dfes <- dfes %>% 
    mutate(newsbi = ifelse(nwspol > 60, 1, 0))

table(dfes$newsbi)

dfes$newsbi <- as.factor(dfes$newsbi)

#Use the janitor library to create a frequency table of the variable gender
library("janitor")

dfes %>%
  tabyl(gender) %>% 
  adorn_pct_formatting()

#Create the same table but for the variables sat, 
#age_cat and party

dfes %>%
  tabyl("gender") %>%  
  adorn_pct_formatting()

dfes %>% 
  tabyl("age_cat")  %>%  
  adorn_pct_formatting()

dfes %>% 
  tabyl("party")  %>%  
  adorn_pct_formatting()


#Is there a gender gap in your vote choice variable? and an age gap?

dfes %>%
  tabyl(party, gender) %>% 
  adorn_percentages("col") %>%
  adorn_pct_formatting(digits = 2) %>%
  adorn_ns() 

dfes %>%
  tabyl(age_cat, party) %>% 
  adorn_percentages("col") %>%
  adorn_pct_formatting(digits = 2) %>%
  adorn_ns() 

chisq.test(dfes$party, dfes$age_cat) 

#run a linear regression with one explanatory variable
out <- lm(sat ~ age_cat, data=dfes)
summary(out)

#run a linear regression with all  explanatory variable
out <- lm(sat ~ age_cat + gender + income + party + 
            newsbi, data=dfes)
summary(out)
plot(out)

#Export eh results using the stargazer library

#http://www.princeton.edu/~otorres/NiceOutputR.pdf
library("stargazer")
stargazer(out, type="text", no.space=T)

#Plot the predicted values of one of the variables
p <- ggpredict(out, terms="party")
plot(p)

mydf <- ggpredict(out, terms = c("party", "newsbi"))
plot(mydf)

plot(mydf, ci.style = "dot")

library("effects")
library("emmeans")
mydf <- ggemmeans(out, terms = "newsbi")
plot(mydf)

out <- lm(sat ~ age_cat*gender + income  + party + newsbi, data=dfes)
summary(out)

library("sjPlot")
plot_model(out, type = "pred", terms = c("age_cat", "gender"))

#Plot all the coefficients in a graph
library("jtools")
summ(out)

effect_plot(out, pred = party, interval = TRUE, plot.points = TRUE)

plot_summs(out,  inner_ci_level = .9)
