## For loops
For loops perform the same action for each item in a list of things. 

Some examples where for loops can be useful in real life:
- Test each gene for differential expression
- Count the number of mutations in each gene
- Performing quality control on many different samples

Why are loops useful?
- They save you a bunch of time!
- They reduce the opportunity for error that is associated with manually performing repetative tasks
- They improve the reproducability of your work

For loops in R take the form: 

```
for (iterator in a set of values){
 do a thing or things
}
```

Let's start with a simple example. In one of the simplest examples, you can have it just print out the iterator 
1:10

```
for(i in 1:10){
  print(i)
}
```

Now, let's do something a little more interesting with the loop variable i
```
for(i in 1:10){
  print(i*i)
}
```

Now lets do one that is a little more complex. For each item in our grocery cart, let's say we want to scan the item, get the value, and add it to the total. 

```
for (items in my grocery cart){
 scan the item, get the value, add to total
}
```

```
items = c('coffee', 'milk', 'eggs')

for(i in items){
  print(paste('scan', i))
  print(paste('get value of', i))
  print(paste('add value of', i, 'to total'))
}
```

```
prices = c(5, 2.50, 1.25)
names(prices) = items
```

Now we can index prices using the item names

``
prices['coffee']
``

Ok, let's perform the actions we outlined above: 

```
for (i in items){
  print(paste('scan', i))
  value = prices[i]
  print(value)
}
```

Now lets keep a running total, first we'll need to intialize a total.

```
total = 0 

for (i in items){
  print(paste('scan', i))
  value = prices[i]
  print(value)
  total = total + value 
  print(total)
}

total
```

**Exercise**: 
Use a for loop to sum the numbers in the following vector: 
numbers = c(10,40,50,70,80)

Solution: 

```
numbers = c(10,40,50,70,80)

count = 0 
for (n in numbers){
  count = count + n
}
print(count)

sum(numbers) # see if we got the right answer
```


Now let's go back to our cars dataset, iterate through the states,  and find the max speed per state

```
states = unique(cars$State)
states
for (s in states){
  print(s)
  max_speed = max(cars$Speed[cars$State == s])
  print(max_speed)
}
```

**Exercise**: Combine if statements and for loops. Modify what we did above where we iterate through states and get the max speed, and print "Cars go slow here in <state name>" if the max speed is less than 50. Otherwise print "Cars go fast here in <state name>" 

Solution: 

```
for (s in states){
  print(s)
  max_speed = max(cars$Speed[cars$State == s])
  
  if(max_speed < 50){
    print(paste('Cars go slow here in',s))
  }else{
    print(paste('Cars go fast here in', s))
    }
}
```

Now let's store the max speed in a vector. First, we initialize a vector max_speed 

```
max_speed_store = rep(NA, length(states))

for (s in 1:length(states)){
  print(s)
  max_speed = max(cars$Speed[cars$State == states[s]]) # now we need to index states
  print(max_speed)
  max_speed_store[s] = max_speed
}
max_speed_store
```
