###############################################
##########INTRODUCTION TO R####################
###############################################
###############################################


#TONI RODON
#www.tonirodon.cat
#@tonirodon


#this is our first R thing

5+2
7+48374598365
  
#Variable or object types
#character
a <- "toni"
class(a)

#integer
b <- c(1:10)
b
class(b)

#numeric
c <- c(1,2.4,5.6)
class(c)

#factor
sex <- factor(c("male", "female", "female", "male"))
class(sex)
levels(sex)
nlevels(sex)

#logical
x <- 1
y <- 2   
z <- x > y      # is x larger than y? 
z              # print the logical value 
class(z)       # print the class name of z 

#Date/time
today <- Sys.Date()
d <- as.Date("23/04/1985")
d <- as.Date("23-04-1985",format = "%d-%m-%Y")
d <- as.Date('1/15/2001',format='%m/%d/%Y')


#working directory
getwd()
setwd()

#if we need help?
help.start()

#more help
help("lm")
help.search("regression")
?lm
??lm

#Let's continue with vectors
a <- 5

d <- "a"

d <- a #warning!

importantstatement <- "I love R"

#It can be as long as you want.
#https://www.whitehouse.gov/briefings-statements/remarks-president-trump-turning-point-action-address-young-americans/
longanduselesstext <- c("THE PRESIDENT:  Thank you very much.  Thank you.

AUDIENCE:  USA!  USA!  USA!

THE PRESIDENT:  Thank you very much.  Go ahead.  Sit down.  We’ll be here for a little while.  Sit down.

Thank you also, Lee Greenwood.  Thank you to Lee Greenwood.

But I’m thrilled to be in Arizona with thousands of patriotic, young Americans who stand up tall for America and refuse to kneel to the radical left.  (Applause.)  That’s true.  That’s true.

There is something going on.  You feel it, right?  You feel the spirit?

You know, the other night, a speech I made on Saturday night in a very good place, and we had a great evening and the ratings came out — you saw that — on television.  It was the number one show in Fox history for a Saturday night.  (Applause.)  Unbelievable.  Ratings.  For them, it’s all about the ratings.  I know that the other folks back there — CNN and MSDNC —

AUDIENCE:  Booo —

THE PRESIDENT:  I know they’re very happy.  No, no, they’re very happy to see that Fox had the number one show.  This is the number one show in the history of Fox News.  That’s pretty good.  Saturday night.

Let us also show our appreciation to my good friend, Charlie.  I’ll tell you, Charlie is some piece of work — (applause) — who is mobilizing a new generation of pro-American student activists.  That’s what you are, and really smart.  And you’ll be up here someday.  Somebody in that audience, maybe a few of you, you’re going to be up here, right here — who are tough and smart and determined and truly unstoppable.  You are.

I want to thank also Kimberly, and I want to thank my son — boy, I watched my son.  I got here — wow.  I said, “What’s this all about?”  He’s good.  And people like him.  People like him a lot.")

#Any restriction? Yes, memory (and RAM, power)

#Other common functions
ls()

rm(a) #think twice before using it!

#Let's create two objects
a <- 5
b <- 4

a+b

#or a bit more useful
c <- a+b

#But not everything is possible
d <- "z"
a+d

5+2 
5-2 
5*2 
5/2
5^2 
(5+2)*(8/4) 

#Let's create our first vector
a <- c(1,2,3,4)
a

#If numbers are consecutive, we can speed this up
z <- 3:20
z

#We can also be a bit more sophisticated. Let's say we need to create a vector that includes 25 fives.
x <- rep(5, times=25)
x

y <- rep("b", times=25)
y

#We can create repetitions of more than one number
x <- rep(1:5, times=4)
x

#we can recreate the alphabet
y <- rep(letters, 4)
y

y <- rep(LETTERS[1:8], 4)
y

#there are many variations of this. 
#For instance, create a list of numbers from 1 to 5 in which each number is repeated 6 times. 
#and let's do this 6 times.
x <- rep(1:5, each=6, times=5)
x

#or we can impose further restrictions. odd numbers from 1 to 50
p <- seq(from=1, to=50, by=2)

#let's go back to operations. 
a
a+4

b <- a/4
b

c <- c(1,2,3)
a*c

#what if we mix different types in a single vector?
d <- c(1,2,3,"k")
d #Why?
class(d)

#Let's learn how to extract elements from a vector (it will be useful for our datasets!)
z <- seq(1,200,3)
z
length(z)

#We want to extract the 6th element
z[6]

#Now the 6th, 8th and 40th
z[c(6,8,40)]

#we can even do it in two steps, defining first a vector.
b <- c(6,8,40)
z[b]

#Extract all the elements except the second one
z[-2]
length(z[-2])

#if we want to combine values, we use again [] and ()
z[-c(6,8,40)]

#Vectors are by definition unidimensional. Let's start using what we normally use. A matrix!
rm(list = ls())
a <- 1:8
d <- matrix(a, ncol=2, byrow=TRUE)
d

#Extract everything except for the third row
d[-3,]

#now we exclude first column
d[,-2]


#We can create lists
t <- 10:20
u <- rep(LETTERS)

#List
g <- list(t,u)
g

#names
names(g) <- c("numbers", "lettersc")
g




#Datasets in R are called dataframes
d <- matrix(a, ncol=2, byrow=TRUE)
f <- data.frame(d)
f
class(f)






#Let's create a more useful dataset
g <- data.frame(Name=c("Marina", "Queralt", "Andreu", "Harold"),
                ideol=c(2,9,5,6),
                goals=c(10,9.5,1,0))
class(g)

#Extract second column
g[,2]

#Extract first row
g[1,]

#Extract third row, second column
g[3,2]

#we can call variables directly
g$ideol
g$goals

#and combine several instructions
g$goals[4]

min(g$goals)
max(g$goals)

#What do these commands do?
length(g)
nrow(g)
ncol(g)
dim(g)

#Basic operations
s <- data.frame(A=1:10, B=81:90)
s

mean(s$A)

sd(s$A)

var(s$A)

median(s$B)

min(s$B)

max(s$B)

summary(s$A)

summary(s)

#RECAP

#Numeric
num_vec <- c(150, 178, 67.7, 905, 12)
print(num_vec)
class(num_vec)

#Character
char_vec <- c("apple", "pear", "plum", "pineapple", "strawberry")
length(char_vec)
print(char_vec)
class(char_vec)

#Logical (boolean)
log_vec <- c(FALSE, FALSE, FALSE, TRUE, TRUE)
log_vec
length(log_vec)
print(log_vec)
class(log_vec)

#factor 
#A factor is similar to a character vector, but here each unique element 
#is associated with a numerical value which represents a category:
fac_vec <- as.factor(c("a", "b", "c", "b", "b", "c"))
fac_vec
length(fac_vec)
print(fac_vec)
class(fac_vec)

#date
#A date is similar to a numeric vector, as it stores the number of days, 
#but it can assume a variety of forms:
date_vec <- as.Date(c("2001/07/06", "2005/05/05", "2010/06/05", "2015/07/05", "2017/08/06"))
date_vec
print(date_vec)
class(date_vec)
format(date_vec, "%d/%m/%Y")







