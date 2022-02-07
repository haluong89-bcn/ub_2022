###############################################
##########INTRODUCTION TO R####################
###############################################
###############################################


#TONI RODON
#www.tonirodon.cat
#@tonirodon

rm(list=ls())

#Create an object named a that represents a vector of 4 
#elements which includes the 
#numbers 5 to 8 (both included).
a <- 5:8


#List the second element of the object
a[2]

#List the fourth element of the object
a[4]

#Multiply the second and the fourth element of the object
a[2]*a[4]


#Create a new object with the numbers 3 and 4. 
#Call the object b. After that, use b to extract the 
#third and fourth element of the object a.
b <- c(3,4)
a[b]

#Extract all elements in a except for the second one. 
a[-2]

#Extract all elements in a except for the third and 
#the fourth.
a[-c(3,4)]

#Create a matrix with 3 rows and 3 columns. 
#Do it in such a way that the first row includes numbers 
#from 1 to 3, second row from 4 to 6
#and third row from 7 to 9.
df <- matrix(1:9,ncol=3,byrow = T)

#Extract the value in the second row, second column
c[2,2]

#Extract AND LIST the value in the second row
c[2,]

#Extract and list all the values in the third column
c[,3]

#Convert the object created before (matrix) into a dataframe
d <- data.frame(c)

#Extract the second observation in the second variable
d[2,2]
d$X2[2]

#Extract all values from the second row
d[2,]

#Extract all values in the third variable
d$X3

#Create two ojects. 
#One with 4 numbers and the other one with two 'characters'
e <- c(3,4,5,6)
f <- c("a","b")

#Use the function list() to create an 
#object that consists of a list of the two previous objects
g <- list(e,f)
g

#Use the function names() to change the names of the 
#sub-objects you have just created
names(g) <- c("numbers", "letters")
g

#Create an object that contains a repetition of 
#even numbers from 1 to 50
rep(seq(2,50,2))


