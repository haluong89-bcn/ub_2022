###############################################
##########INTRODUCTION TO R####################
###############################################
###############################################


#TONI RODON
#www.tonirodon.cat
#@tonirodon

rm(list = ls())

#European Social Survey. UK. 2018. Round 9 https://www.europeansocialsurvey.org/data/country.html?c=united_kingdom
library("rio")
dfuk <- import("Data/ESS9GB.sav")

names(dfuk)

library("tidyverse")
#Select a few variables.
dfuks <- select(dfuk, idno, lrscale, gndr, agea, euftf, 
                prtclcgb, imbgeco, 
                hinctnta,dweight)
rm(dfuk)

#let's turn ideol into categorical
dfuks$ideol_cat[dfuks$lrscale<3] <- 0
dfuks$ideol_cat[dfuks$lrscale==3 | dfuks$lrscale==4] <- 1
dfuks$ideol_cat[dfuks$lrscale==5] <- 2
dfuks$ideol_cat[dfuks$lrscale==6 | dfuks$lrscale==7] <- 3
dfuks$ideol_cat[dfuks$lrscale>7] <- 4
table(dfuks$ideol_cat)

dfuks$ideol_cat <- factor(dfuks$ideol_cat, levels=c(0,1,2,3,4),
                          labels=c("Extreme left", "Left",
                                   "Centre", "Right", "Extreme right"))

plot(dfuks$ideol_cat)

#Recode variables
dfuks$gender[dfuks$gndr==2] <- 0
dfuks$gender[dfuks$gndr==1] <- 1
dfuks$gender <- as.factor(dfuks$gender)
plot(dfuks$gender)
table(is.na(dfuks$gender))

#age
hist(dfuks$agea)
summary(dfuks$agea)

#european integration position
table(dfuks$euftf)

ggplot(dfuks) +
  geom_bar(aes(euftf))

#Party voted for in last national election, United Kingdom 
table(dfuks$prtclcgb)

dfuks$party[dfuks$prtclcgb==1] <- 1 #Conservative
dfuks$party[dfuks$prtclcgb==2] <- 2 #Labour
dfuks$party[dfuks$prtclcgb==3] <- 3 #Libdem
dfuks$party[dfuks$prtclcgb>3] <- 4 #Rest

dfuks$party <- factor(dfuks$party, levels=c(1,2,3,4),
                          labels=c("Con", "Lab", "Libdem", "else"))

#imbgeco: Immigration bad or good for country's economy 
ggplot(dfuks) + 
  geom_density(aes(x = imbgeco)) +
  geom_rug(aes(x = imbgeco, y = 0), position = position_jitter(height = 0)) +
  scale_x_continuous(breaks = c(0, 10),
                     labels = c("Bad for the economy", "Good for the economy")) +
  theme_minimal()

#hinctnta household income Household's total net income, all sources 
table(dfuks$hinctnta)

dfuks$income[dfuks$hinctnta<4] <- 1 #Low
dfuks$income[dfuks$hinctnta>3 & dfuks$hinctnta<7] <- 2 #Medium
dfuks$income[dfuks$hinctnta>6] <- 3 #High


dfuks$income <- factor(dfuks$income, levels=c(1,2,3),
                      labels=c("Low", "Medium", "High"))


table(dfuks$income)

#Cross-tabs
table(dfuks$income, dfuks$gender)
xtabs(~income + gender, dfuks)
xtabs(dweight~income + gender, dfuks)


prop.table(table(dfuks$income, dfuks$gender),2)

round(prop.table(table(dfuks$income, dfuks$gender),2)*100,2)

#ftable(table(dfuks$income, dfuks$gender)) 

library("summarytools")

ctable(dfuks$gender, dfuks$income)
ctable(dfuks$gender, dfuks$income, prop = "c")
ctable(dfuks$gender, dfuks$income, prop = "c", weights = dfuks$dweight)

view(dfSummary(dfuks))

#https://www.rdocumentation.org/packages/gmodels/versions/2.18.1/topics/CrossTable

library("janitor")

dfuks %>%
  tabyl(ideol_cat) %>% 
  adorn_pct_formatting()

dfuks %>%
  tabyl(party, income) %>% 
  adorn_percentages("col") %>%
  adorn_pct_formatting(digits = 2) %>%
  adorn_ns()


#Regression
out <- lm(lrscale ~ gender + income + euftf + imbgeco + agea, data=dfuks, weights = dweight)
summary(out)

out <- lm(lrscale ~ gender + income + euftf + imbgeco*agea, data=dfuks, weights = dweight)
summary(out)

library("ggeffects")
library("stargazer")
library("broom")

stargazer(out, type="text", no.space=T)

p <- tidy(out,  conf.int = TRUE)
p <- p %>% 
  filter(term!="(Intercept)")

ggplot(p, aes(estimate, term, color = term)) +
  geom_point() +
  geom_errorbarh(aes(xmin = conf.low, xmax = conf.high)) +
  geom_vline(xintercept = 0) +
  theme(panel.background = element_rect(fill = "white", colour = "grey50"), 
        axis.title.x = element_text(size = 14), axis.title.y = element_text(size = 14), 
        axis.text.x = element_text(size = 14),axis.text.y = element_text(size = 14),
        legend.position="bottom",legend.direction = "horizontal",
        legend.title = element_text(size =14), legend.text = element_text(size = 14) , 
        plot.title = element_text(face="bold", size=10, hjust = 0.5),
        panel.grid.major = element_blank(),
        strip.text.x = element_text(size =18),
        panel.grid.minor = element_blank()) + guides(fill=guide_legend(reverse=TRUE), 
                                                     colour=guide_legend(reverse=TRUE)) 

glance_cv <- glance(out)


p <- ggpredict(out, terms="euftf")
plot(p)
class(p)

p <- ggpredict(out, terms="imbgeco")
plot(p)



