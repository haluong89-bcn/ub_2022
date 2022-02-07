###############################################
##########INTRODUCTION TO R####################
###############################################
###############################################


#TONI RODON
#www.tonirodon.cat
#@tonirodon

#you will be working with a comparative dataset
#Extracted from V-Dem https://www.v-dem.net/en/data/data-version-10/

#Import the dataset into R (hint: library readstata13)



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


#Use ggplot and create and histogram of the polyarchy index


#Create the same histogram but, this time, add a red dashed vertical line that corresponds with the mean value (hint geom_vline)


#Turn v2eltype_0 into a factor and give it labels. Then plot it.


#Create a scatterplot between polyarchy and turnout. Is there a relationship?


#Extract the mean value of polyarchy and turnout by country


#On the previous dataset, create a factor so that 0 if meanpol<0.5 and 1 if meanpol>0.5


#Create two scatterplots, one for democracy =1 and the other for democracy=0


#back to the original (big) dataset. Select 6 countries (free to choose!)



#Create a graph that shows the evolution of gdp growth over time (hint: geom_line and remember to use group)



#Create the same graph but one for each of the six countries (hint: facet_wrap)



#Create exactly the same graph, but this time it should be a point graph (geom_point) and add a loess curve (hint: geom_smooth)




#Create a dataset with the mean of ideology, gender, polyarchy and gdp growth (remember the missing values)


#Check if there are missing values

#Drop rows with missing

#Calculate the correlation between all the variables in this dataset (remember Hmisc!)


#Create a correlation plot with squares


#Almost at the end of this script. 
#Recode the variable electoral system and give it three values
#Remember:v2elloelsy majoritarian 0-4, mixed 5-6,  PR electoral systems are: 7-12 
#Remember 2: you also need to turn it into a factor




#Calculate the average value of polyarchy and turnout by electoral system type


#Plot the relationship between polyarchy and turnout in majoritarian, mixed and proportional systems


#Extra exercise. Describe data using describe from psych library




