# BEFORE BREAK: 

#### CONDITIONALS - IF/ELSE STATMENTS ####
#if (condition is true){
#  perform an action 
#}

# if else statements:
# if (condition is true){
#   perform an action
# }else if(){
#}
#else { that is, if a condition is false, 
#   perform another action }

x <- 8
x
# LOGICALS OR BOOLEANS 
x == 8
x != 8
x > 10
x >= 10
x < 10
x <= 10 
sum(x == 8)

# STRING TOGETHER LOGICALS 
x > 5 & x < 10 
x > 9 | x == 8 # only one has to be true 
x > 9 & x == 8 # both have to be true 

if (x > 1){
  print('x is greather than 1')
}else if (x>5){
  print('x is greater than 5 but less than 10')
}else {print('x is less than  10')}

x <- 4==3
if (x){
  print('4 equals 3')
}else{
  print('4 does not equal 3')
}

cars = read.csv('~/Desktop/data/car-speeds-cleaned.csv', stringsAsFactors = FALSE)
class(cars)


# let's explore 
table(car$Color)
table(car$State)

# SUBSETTING DATA WITH LOGICALS 
cars$Color == 'Blue'
sum(cars$Color == 'Blue')
length(cars$Color == 'Blue')
dim(cars)

blue_cars = cars[cars$Color == 'Blue',]
dim(blue_cars)
table(blue_cars$Color)

# CHALLENGE: create a new data.frame called white_cars_utah that includes all 
# three columns of the data.frame cars, but only includes those that are white
# and in utah 
white_cars_utah = cars[cars$Color == 'White' & cars$State == 'Utah',]

# USING %IN% 
# say we wanted to subset car color on the states new mexico and arizona we could: 
cars$Color[cars$State == 'NewMexico' | cars$State == 'Arizona']
# we could also use %in% 
cars$Color[cars$State %in% c('NewMexico', 'Arizona')]

##### LOOPS #### 
# do something(s) until a condition is met 
# FOR LOOPS 

# for (iterator in a set of values){
# do a thing or things
#}

# Let's start with a simple example. in one of the simplest examples, you can 
# have it just print out the iterator 
1:10 
for(i in 1:10){
  print(i)
}

# you can also have it do something n times, regardless of the iterator i, such as print(i love cats)
for(i in 1:10){
  print('i love cats')
}



# for (items in my grocery cart){
# scan the item, get the value, add to total
#}

items = c('coffee', 'milk', 'eggs')
for(i in items){
  print(paste('scan', i))
  print(paste('get value of', i))
  print('add value of item to total')
}

prices = c(5, 2.50, 1.25)
names(prices) = items

# now we can index prices using the item names
prices['coffee']

# let's perform the actions we outlined above
for (i in items){
  print(paste('scan', i))
  value = prices[i]
  print(value)
}

# now lets keep a running total, first we'll need to intialize a total 
total = 0 

for (i in items){
  print(paste('scan', i))
  value = prices[i]
  print(value)
  total = total + value 
  print(total)
}

total

# CHALLENGE ANOTHER COUNTING EXAMPLE...
# Use a for loop to sum the numbers in the following vector: 
numbers = c(10,40,50,70,80)

count = 0 
for (n in numbers){
  count = count + n
}
print(count)
sum(numbers)

# now let's iterate through the states and find the max speed per state
states = unique(cars$State)
states
for (s in states){
  print(s)
  max_speed = max(cars$Speed[cars$State == s])
  print(max_speed)
}

# CHALLENGE: Combine if statements and for loops; 
# Modify what we did above where we iterate through states and get the max speed,
# and print "Cars go slow here in <state name>" if the max speed is less than 50. 
# Otherwise print "Cars go fast here in <state name>" 
for (s in states){
  print(s)
  max_speed = max(cars$Speed[cars$State == s])
  
  if(max_speed < 50){
    print(paste('Cars go slow here in',s))
  }else{
    print(paste('Cars go fast here in', s))
    }
}

# now let's store the max speed in a vector: 
# first, we initialize a vector max_speed 
max_speed_store = rep(NA, length(states))

for (s in 1:length(states)){
  print(s)
  max_speed = max(cars$Speed[cars$State == states[s]]) # now we need to index states
  print(max_speed)
  max_speed_store[s] = max_speed
}
max_speed_store

# CHALLENGE: For each car color, find the mean car speed and store in a vector
# called mean_speed_per_color 


# processing multiple files
# sort of like grep - which Zena alluded to earlier!
#We are studying inflammation in patients who have been given a new treatment
#for arthritis, and need to analyze the first dozen data sets of their daily 
#inflammation. The data sets are stored in CSV format (comma-separated values): 
#each row holds information for a single patient, and the columns represent 
#successive days. The first few rows of our first file look like this:
  
  
list.files(path = '~/Desktop/data', pattern = 'csv')
list.files(path = '~/Desktop/data', pattern = 'inflammation')
list.files(path = '~/Desktop/data', pattern = 'inflammation', full.names = T)

filenames <- list.files(path = "~/Desktop/data", pattern = "inflammation.*csv", full.names = TRUE)
filenames <- filenames[1:3]
for (f in filenames) {
  dat = read.csv(f)
  print(dim(dat))
  print(rowMeans(dat)) #row is a patient, avg inflammation 
  hist(rowMeans(dat), main = f)
}


#### AFTER BREAK: PLOTTING #### 
data = read.csv('~/Desktop/data/sample.csv', stringsAsFactors = FALSE)
class(data)

hist(data$Aneurisms_q1)

#bin sizes 
hist(data$Aneurisms_q1, 100) #breaks = a single number giving the number of cells for the histogram
?hist
hist(data$Aneurisms_q1, seq(0,300,5)) #bins of size 5 going from 0 to 300 

# if you don't know the range of your data 
hist(data$Aneurisms_q1, seq(0,max(data$Aneurisms_q1),5))

# adding labels 
hist(data$Aneurisms_q1, seq(0,max(data$Aneurisms_q1),5), 
     main = 'Distribution of aneurism sizes', 
     xlab = 'Size (mm)') 

# COMPARING TWO DISTRIBUTIONS 
hist(data$Aneurisms_q1, seq(0,max(data$Aneurisms_q1),5), 
     main = 'Distribution of aneurism sizes', 
     xlab = 'Size (mm)', 
     col = rgb(1,0,0,0.5)) 

hist(data$Aneurisms_q4, seq(0,max(data$Aneurisms_q4),5), 
     main = 'Distribution of aneurism sizes', 
     xlab = 'Size (mm)', 
     col = rgb(0,0,1,0.5), add = TRUE) 

# HEATMAPS
#install.packages(pheatmap)
library(pheatmap)


data_subset = data[,grep('An', colnames(data))]
row.names(data_subset) = data$ID
annots = data.frame(group = data$Group)
row.names(annots) = row.names(data_subset)

pheatmap(data_subset, 
         annotation_row = annots)

# CHALLENGE - Put gender annotation on heatmap in addition to group 
annots = data.frame(group = data$Group, gender = data$Gender)
row.names(annots) = row.names(data_subset)
pheatmap(data_subset, 
         annotation_row = annots)

# Clean the data using gsub 
data$Gender = gsub('f','F',data$Gender)
data$Gender = gsub('m','M',data$Gender)

annots = data.frame(group = data$Group, gender = data$Gender)
row.names(annots) = row.names(data_subset)
pheatmap(data_subset, 
         annotation_row = annots)

# SUBSET DATA ON FEMALES
female_bp = data$BloodPressure[data$Gender == 'F']
male_bp = data$BloodPressure[data$Gender == 'M']

#make a boxplot 
boxplot(female_bp, male_bp)

# CHALLENGE: plot age vs. blood pressure (scatterplot) for the females in the control group 
table(data$Group)
plot(data$Age[data$Gender == 'F' & data$Group == 'Control'], 
     data$BloodPressure[data$Gender == 'F' & data$Group == 'Control'])
