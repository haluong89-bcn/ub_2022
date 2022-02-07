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


#How many vaccines have been administered? (variable "recompte")



#What is the most prevalent vaccine producer? (variable "fabricant")


#What is the most prevalent vaccine producer by gender? cross-tab showing absolute numbers


#What is the most prevalent vaccine producer by gender? cross-tab showing column-wise %




#With the variable "recompte" (number vaccines), create a histogram (ggplot)


#Create the log of "recompte" and plot a histogram


#Create a dataframe with the count of vaccine producers


#Plot a bar graph (use geom_bar and stat='identity')


#Calculate the percentage of vaccine type over the total number of vaccines administered


#Plot a bar graph with these percentages


#Create a dataframe with the number of vaccines administered every day


#Create a graph showing the evolution of vaccines administered every day
# https://www.r-graph-gallery.com/line-chart-ggplot2.html
# warning: convert DATA to date



#Back to the original dataset.Create a new dataset with 
#Count the number of vaccines by municipality.
#Count the number of men
#keep the MUNICIPI_CODI variable


#What is the municipality with the highest number of vaccines administered


#What is the municipality with the lowest number of vaccines administered


#DIFFICULT EXERCISE! (or not... we'll see)

#Remember the dataset cat_2017? Let's import it (population tab)


#We now want to merge the population dataset with the newly created dataset on vaccines at the municipality level
#WARNING: THE VACCINE DATASET HAS FEWER CASES.
#WARNING 2: the unique code is not the same. We need to add a leading zero in the vaccine dataset and remove the last digit in the population dataset
#WARNING 3: remove missing in vaccine dataset (two missing in municipality code)




#With the new dataset, calculate the % of men vaccinated


#plot a scatterplot between the % of men vaccinated and the % of young people


#final exercise: create a gem density ridge with comarca(county) and the log of vaccines
#https://www.r-graph-gallery.com/294-basic-ridgeline-plot.html





