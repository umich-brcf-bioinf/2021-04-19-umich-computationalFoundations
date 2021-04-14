## Conditionals 

### Introduction to conditionals 
Conditional statements are when we check to see if some condition is true or not. 

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
sum(x == 8)
```

We can also string together conditional statements to see if multiple conditions are true. 

```
x > 5 & x < 10 
x > 9 | x == 8 # only one has to be true 
x > 9 & x == 8 # both have to be true 
```

### Conditionals in if/else statements 

If/else statements use conditionals to control the flow of a program. They use the following format: 

```
if (condition is true){
   perform an action
 }else if(){
}
else { that is, if a condition is false, 
   perform another action }
```

Let's try one out with the variable we made, x. 

```
if (x > 1){
  print('x is greather than 1')
}else if (x>5){
  print('x is greater than 5 but less than 10')
}else {print('x is less than  10')}
```

Here is another version where we make x a logical.

```
x <- 4==3
if (x){
  print('4 equals 3')
}else{
  print('4 does not equal 3')
}
```

Now that we've played with some conditional statments using a variable, let's try applying conditionals with data. 

First, let's read in our data, which can be downloaded [here](http://swcarpentry.github.io/r-novice-inflammation/setup.html). 

```
cars <- read.csv('~/Desktop/data/car-speeds-cleaned.csv', stringsAsFactors = FALSE)
class(cars)
```

Let's explore some of the key variables in our data that we will be using. Remember the $ operator from this morning?

```
table(car$Color)
table(car$State)
```

Now let's use what we learend about conditional statements to subset our cars data. 

```
cars$Color == 'Blue'
sum(cars$Color == 'Blue')
length(cars$Color == 'Blue')
dim(cars)
```

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
