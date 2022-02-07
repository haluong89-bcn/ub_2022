###############################################
##########INTRODUCTION TO R####################
###############################################
###############################################


#TONI RODON
#www.tonirodon.cat
#@tonirodon


#Go to the European Social Survey website and download a dataset for one country (stata version)
#https://www.europeansocialsurvey.org/data/country_index.html



#Our outcome will be stflife: How satisfied with life as a whole
#Our explanatory variables will be the following:
#gndr gender
#agea age
#lrscale: LR position
#hinctnta household income 
#party R voted for. The variable name is different in each country. it always starts with prtv. For instance, prtvtees refers to Spain
#nwspol: News about politics and current affairs, watching, reading or listening, in minutes 

#Select these variables and put them into a new dataframe



#Create a barplot of stflife


#Recode gender and turn it into a factor


#Convert age into a categorical variable



#Create a scatterplot between household income and life satisfaction (we are going to assume H.income is continuous)
#don't worry. They are both semi-continuous variables. Add a regression line.


#Calculate average value of life satisfaction for each income level (remember missing values) and plot it


#Calculate average value of life satisfaction for each income level for men and for women (remember missing values) and plot it
#hint: to plot it, use the option fill and position=position_dodge()




#Recode party R voted for and turn it into a factor



#Recode news consumption into a binary indicator and turn it into a factor



#Use the janitor library to create a frequency table of the variable gender


#Create the same table but for the variables sat, age_cat and party



#Is there a gender gap in your vote choice variable? and an age gap?



#run a linear regression with one explanatory variable


#run a linear regression with all  explanatory variable


#Export eh results using the stargazer library



#Plot the predicted values of one of the variables


#Plot all the coefficients in a graph

