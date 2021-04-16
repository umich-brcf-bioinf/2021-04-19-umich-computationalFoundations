## Conditionals 

### Introduction to conditionals 
Conditional statements are when we check to see if some condition is true or not, before deciding what code to execute.

What are some examples for when conditionals might be useful?
- Checking that the data you read in from a file is what you expect (e.g. sequencing data and not you're grocery list)
- Checking that the data is good to work with (e.g. number of sequencing reads meeting a minimum quality threshold)
- Allowing similar code to have slightly different behaviors depending on user preferences (e.g. plot in color or gray-scale)

These statements generate a value is of type "logical":
- The value is TRUE if the condition is satisfied
- The value is FALSE if the condition is not satisfied

Note: These aren’t the strings “TRUE” and “FALSE”. They are a special type of value. 

Let's look at some operators we use in conditional statements. 

First, create a variable named x that is equal to the value 8. 
```
x <- 8
x
```

Then, see if x meets certain conditions.

```
x == 8
x != 8
x > 10
x >= 10
x < 10
x <= 10 
```

Logical vectors can also be treated as numeric for the purposes of seeing how many times a condition is satisfied
```
x == 8
sum(x == 8)
```

We can also string together conditional statements to see if multiple conditions are true. 

```
x > 5 & x < 10 # both have to be true
x > 9 | x == 8 # only one has to be true 
x > 9 & x == 8 # both have to be true 
```

### Conditionals in if/else statements 

If/else statements use conditionals to control the flow of a program. They use the following format: 

```
if (condition is true)
{

   perform an action

}else{  

   perform an alternative action 

}
```

Let's try one out with the variable we made, x. 

```
if (x < 1)
{

  print('x is less than 1')

}else{

   print('x is greater than  or equal to 1')
  
 }
```

Note - you can add as many sub-conditions as you want!

```

if (x < 1)
{

  print('x is less than 1')

}else if(x >=1 & x <8){

   print('x is between 1 and 7, inclusive')

}else{

   print('x is greater than 7')
  
 }
```

Now that we've played with some conditional statments using a variable, let's try applying conditionals with data. 

First, let's read in our data, which can be downloaded [here](http://swcarpentry.github.io/r-novice-inflammation/setup.html). 

```
#READ IN THE CARS CSV FILE
cars <- read.csv('~/Desktop/data/car-speeds-cleaned.csv', stringsAsFactors = FALSE)

#SEE WHAT TYPE OF VARIABLE CARS IS
class(cars)
```

Let's explore some of the key variables in our data that we will be using. Remember the $ operator from this morning?

```
#LET'S SEE WHAT THE COLUMNS OF cars ARE
str(cars)

#LET'S USE TABLE TO SEE THE DIFFERENT COLORS AND STATES REPRESENTED IN cars
table(car$Color)
table(car$State)

#LET'S USE min AND max TO SEE THE RANGE OF SPEEDS
min(cars$Speed)
max(cars$Speed)
```

Now let's use what we learend about conditional statements to explore the data. 

```
#LET'S CHECK OUT HOW LONG COLORS IS
cars$Color
length(cars$Color)

#HOW LONG IS THE LOGICAL CHECKING IF THE COLOR OF EACH CAR IS BLUE
cars$Color == 'Blue'
length(cars$Color == 'Blue')

#NOW, LET'S SEE HOW MANY CARS ARE BLUE BY TREATING THE LOGICAL AS NUMERIC
sum(cars$Color == 'Blue')
sum(cars$Color == 'blue') 

#TRY SOME OTHER COLORS ON YOUR OWN!
```


Next we are going to use logicals to subset our data frame to focus on the data we are interested in
```
blue_cars = cars[cars$Color == 'Blue',]
dim(blue_cars)
table(blue_cars$Color)
```

**Exercise**: Create a new data.frame called white_cars_utah that includes all three columns of the data.frame cars, but only includes those that are white and in utah 

Solution: 
```
white_cars_utah = cars[cars$Color == 'White' & cars$State == 'Utah',]
```

#### %in%, a special operater 

If we wanted to subset car color on the states new mexico and arizona we could: 

```cars$Color[cars$State == 'NewMexico' | cars$State == 'Arizona']```

However, we could also use the %in% operator 

```cars$Color[cars$State %in% c('NewMexico', 'Arizona')]```
