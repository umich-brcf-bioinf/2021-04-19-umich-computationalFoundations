# [Intro R for genomics](https://datacarpentry.org/R-genomics/)

#### Intro to RStudio ####
- Console, scripts, environments, plots
- Code and workflow more reproducible if we document everything we do


Create a project following [these](https://datacarpentry.org/R-genomics/00-before-we-start.html) instructions.
- `File` ->  `New project` -> `New directory` -> save
- Using `Files` tab on right of screen, `New Folder` -> data
- Save on Desktop
- New R script

#### Programming Basics ####
- **Variables** - store information
- **Functions** - procedure or routine
- **Conditionals** - true or false
- **Loops** - instructions repeated until condition reached

Start by showing example script?? - No

#### Intro to R ####
##### Math
```
# Adding
3+5
# Dividing
12/7
# If you get stuck, use Esc
I'm stuck
```
##### Variables

Sometimes we want to store information to:
- Save for later reference
- More easily manipulate them
- Variables can be thought of as a box
```
# Assigning values to variables
# assign 10 to temp_f
temp_f <- 10 # 10 goes into temp_f
# what is temp_f?
temp_f
# add 5 to temp_f
temp_f + 5
temp_f
```
**Exercise:**
- Find the temperature of temp_f in celcius (use google if you need to)
**Solution:**
```
temp_c <- (temp_f - 32) * 5/9
temp_c
```

```
# how about kelvin to celcius? - celcius to kelvin??
#temp_c <- temp_k - 273.15
temp_k <- temp_c + 273.15
```

**Shortcut:** `Alt`+`-` to write `<-`.

**Exercises:**
1. Change `temp_f` to 87. What is temp_c now?
2. If you only change `temp_f` in the script but not in the console, what do you get?

Notes about naming variables:
- Can't start variable names with number
- R is case sensitive
- Best to avoid dots (`.`) within a variable name because they sometimes have a special meaning (for methods)
- Best to use nouns for variable names (they are a thing) and verbs for function names (we'll learn about that soon)

Can force print by using parentheses:
```
# Assigns a value to a variable
genome_size_mb <- 35

# Assigns a value to a variable and prints it out on the console
(genome_size_mb <- 35)

# Prints out the value of a variable on the console
genome_size_mb
```

**Exercises & Solutions:**
- Create a variable `genome_length_mb` and assign it the value `4.6`.
```
genome_length_mb <- 4.6
genome_length_mb
 ```
- Convert this to the weight of the genome in picograms (978Mb = 1picogram; 10^-15kg). Divide the genome length in Mb by 978 and store this value in `genome_weight_pg`.
```
genome_weight_pg <- genome_length_mb / 978.0
genome_weight_pg
```
- Change `genome_length_mb` to 3000 (for the human genome). What is `genome_weight_pg`?
```
genome_length_mb <- 3000.0
genome_weight_pg # same as before - didn't change (doesn't update like a spreadsheet)
```
- Determine the weight of the human genome.
```
genome_length_mb / 978.0
```
Strings
- You can also assign words to a variable.
- To do this, you have to put single or double quotes around the word so that R knows it's not a variable (or variables)
```
my_favorite_bacteria <- 'Klebsiella pneumoniae'
my_favorite_bacteria

path <- '~/Desktop/data_carpentry'
```

##### Functions
- Built in procedure that automates something for you.
- You input *arguments* to a function and the function usually returns a *value*.
- For example, `sqrt()` takes a number and returns the square root of that number.
```
# square root function
sqrt(4)
a <- 31
sqrt(a)
```
- Most functions take multiple arguments, but often there are *defaults* that are used if you don't specify anything for that argument.
```
# round a number
round(3.14159) # default is to round to nearest number
# look at arguments for round function
args(round)
# look at help for function
?round
# change number of digits to 2
round(3.14159, digits=2)
# if you provide the arguments in the exact same order as they are defined, you don't have to name them
round(3.14159, 2) # better practice to include argument name for readability (and order doesn't matter)
```

**Exercises & Solutions:**
- Using the `log` function, find the log of 10. Is this what you expected? What log is this?
```
log(10)
```
- How can you get log base 10 of 10?
```
log10(10)
```
- What about log base 3 of 10?
```
log(10, base=3)
```

##### Vectors and data types

A vector is a list of values (numbers or characters)
```
# Vector of genome lengths
glengths <- c(4.6, 3000, 50000) #megabases, I think
glengths

# Vector of species
species <- c("ecoli", "human", "corn")
species

# How many elements are in a vector
lenth(glengths)
length(species)

# You can name elements in a vector
names(glengths)
names(glengths) <- species
glengths

# Doing math with vectors:
5 * glengths
new_lengths <- glengths + glengths
new_lengths

# Type of element of the vector
class(glengths)
class(species)

# Overiew of object and elements
str(glengths)
str(species)

# Can add elements to vector using the c() function
lengths <- c(glengths, 90) # adding at the end
lengths <- c(30, glengths) # adding at the beginning
lengths
```

BREAK?

**Exercises & Solutions:**

- Get 5 random numbers from a normal distribution using the function `rnorm` by using the command `rnorm(5)` and assign it to the variable `rand1`. What are the default mean and standard deviation for the `rnorm` function?
```
rand1 <- rnorm(5)
?rand1 # mean = 0, sd = 1
```
What class are the elements in `rand1`? Print the values in `rand1`.
```
class(rand1)
rand1
```
- Get 5 more random numbers from a normal distribution and assign it to the variable `rand2`.
```
rand2 <- rnorm(5)
rand2
```
- Combine (join) the two vectors together into the variable `all_rand`. What is the length of `all_rand`?
```
all_rand = c(rand1, rand2)
length(all_rand)
```
- Multiply all_rand by 2 and save it to the variable `double_all_rand`
```
double_all_rand <- all_rand * 2
```
- What is the mean of all of the elements in `double_all_rand`. Hint: use the `mean` function. Is it close to what you'd expect it to be? Why or why not?
```
mean(all_rand)
```
- Compare your answer with your neighbor. Did you get the same answer? Why or why not?

Advanced: `set.seed`.

BREAK

##### Subsetting vectors
```
# Vector of 1st 10 letters of alphabet
ten_letters <- c('a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j')
# R indexing starts at 1
# Get 2nd letter
ten_letters[2]
# Get multiple letters
ten_letters[c(1,7)]
# Get multiple consecutive letters
ten_letters[3:6]
# Get letters going backwards
ten_letters[10:1]
# Get subset of letters
ten_letters[c(2, 8:10)]
```

**Exercises & Solutions:**
- Make a word by subsetting ten_letters
```
ten_letters[c(10,1:2)]
ten_letters[c(8:9,7:8)]
```
- Select every other element in `ten_letters` # maybe skip
```
ten_letters[c(1,3,5,7,9)]
```

SKIP
```
# seq function creates sequences of numbers
seq(1,10,by=2)
seq(20,4,by=-3)
```

**Exercise:**
Select the even elements in `ten_letters` using the seq() function. `ten_letters[_______]`
```
ten_letters[seq(2,10,by=2)]
```

#### Starting with Data ####

##### The data
- *E. coli* population (Ara-3) from Richard Lenski's LTEE
- Propagated for > 40,000 generations in glucose-limited minimal medium supplemented with citrate, which *E. coli* can't metabolize
- Spontaneous citrate-using mutants (Cit+) appeared at ~31,000 generations
- Genome size is made up

```
# Download data
list.files()
dir.create()
download.file("https://raw.githubusercontent.com/datacarpentry/R-genomics/gh-pages/data/Ecoli_metadata.csv", "data/Ecoli_metadata.csv")

# Load data into memory (as a dataframe)
metadata <- read.csv('data/Ecoli_metadata.csv')
# check class
class(metadata)
# look at beginning of data - discuss columns (each column is a vector)
head(metadata)
# dimensions of the dataframe
dim(metadata)
# column names
colnames(metadata)
# look at the structure of the dataframe
str(metadata)
# summary statistics for each column
summary(metadata)
# In RStudio
View(metadata)
```

##### Factors
- Represent categorical data
- Stored as integers (levels)

##### Data frames
- Extract data by specifying "coordinates"
- Row number then column number (metadata[row,column])
```
metadata[1, 2]   # 1st element in the 2nd column
metadata[1, 6]   # 1st element in the 6th column
metadata[1:3, 7] # First three elements in the 7th column
metadata[3, ]    # 3rd element for all columns
# Entire 7th column
metadata[, 7]
names(metadata) # or colnames(metadata)
metadata[,"genome_size"]
metadata$genome_size
# Multiple columns by name
metadata[,c('clade','genome_size')]
# Just rows 4 to 7
metadata[4:7, c("clade","genome_size")]
```

**Exercises & Solutions:**
- What is the value of the first column for the last row? How many different ways can you think of to get this element?
```
metadata[30,1]
metadata[30,'sample']
metadata[nrow(metadata),1]
```

- [SKIP] Use the function `nrow()` (which returns the number of rows in a data frame) and the function `seq()` to create a new data frame called `meta_by_2` that includes all even numbered rows of `metadata`. What are the dimensions of this data frame?
```
meta_by_2 <- metadata[seq(2,nrow(metadata),by=2),]
dim(meta_by_2)
```
- What is the mean genome size over all the samples? The minimum and maximum?
```
mean(metadata$genome_size)
min(metadata$genome_size)
max(metadata$genome_size)
```
- Can you figure out what this command does? What does it tell you?
```
table(metadata$cit)
```
- Use the `table` function to find the number of samples in the Cit+ clade. - kind of like str
```
table(metadata$clade)
```

#### Aggregating and analyzing data

##### Data manipulation
```
# Only Cit+ rows
metadata[metadata$cit == 'plus',]
# Everything but Cit+ rows
metadata[metadata$cit != 'plus',]
# Only sample, generation, and clade
meta_citplus <- metadata[metadata$cit == 'plus',c('sample','generation','clade')]

# Append column
metadata$genome_size_bp <- metadata$genome_size*1000000
str(metadata) # What might be wrong here? (dunno?)
```
**Exercise & Solution:**
Subset the data to include rows where the clade is 'Cit+' and retain the columns `sample`, `cit`, and `genome_size`.
```
meta_cit_clade <- metadata[metadata$clade == 'Cit+',c('sample','cit','genome_size')]
# to remove NA
# na.omit around whole thing
meta_cit_clade <- metadata[metadata$clade == 'Cit+' & !is.na(metadata$clade),c('sample','cit','genome_size')]
```

##### Packages
- Base R is useful, but sometimes you want to do more complicated things that other people have made a lot easier for you.
- You can install packages, which are libraries of functions that others have already written for you.

```
# Install package (only have to do this once on your computer)
install.packages('dplyr')
# Load package (have to do this every time you start a session)
library(dplyr)
```

**Exercise & Solution**
Install the package pheatmap and load it into R (you'll be using this package in the afternoon!). Note: You might get a warning; you can ignore it.
```
install.packages('pheatmap')
library(pheatmap)
```

##### Split-apply-combine data analysis
1. Split data into groups
2. Apply some analysis to each group
3. Combine results

```
# Use pipes to send one output as input to the next function

# Group by citrate column and find mean of each group
metadata %>% group_by(cit) %>% summarize(mean_size = mean(genome_size,na.rm=TRUE))

# Group by multiple columns
metadata %>%
  group_by(cit, clade) %>%
  summarize(mean_size = mean(genome_size, na.rm = TRUE))

# Remove rows where clade is missing (NA)
metadata %>%
  group_by(cit, clade) %>%
  summarize(mean_size = mean(genome_size, na.rm = TRUE)) %>%
  filter(!is.na(clade))
```
**Exercises & Solutions**
- Find the minimum generation for each citrate-degrading status-clade pair.
```
metadata %>%
  group_by(cit, clade) %>%
  summarize(min_generation = min(generation))
```
- Can you figure out how to summarize both mean_size and min_generation at the same time when grouping by cit and clade?
```
# Can summarize multiple variables at the same time
metadata %>%
  group_by(cit, clade) %>%
  summarize(mean_size = mean(genome_size, na.rm = TRUE),
            min_generation = min(generation))
```

##### Seeking help
If you get an error message:
- Google it
- Check stackoverflow.com
