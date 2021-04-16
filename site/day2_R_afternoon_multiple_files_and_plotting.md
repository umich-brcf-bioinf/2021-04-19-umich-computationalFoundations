## Processing multiple files 

As mentioned in the section on loops, a really common task is processing multiple data files and performing a common summary task on them. Those of you in the microbial genomics workshop will see many examples of this, so be prepared! To get you comfortable with this concept let's do an example with some sample data from a clinical study.

We are studying inflammation in patients who have been given a new treatment for arthritis, and need to analyze the first dozen data sets of their daily inflammation. The data sets are stored in CSV format (comma-separated values): each row holds information for a single patient, and the columns represent successive days. 
  
 First, let's use R to look at files in the direction, and tune our pattern to get the subset we are interested in. 
 ``` 
list.files(path = '~/Desktop/data', pattern = 'csv')
list.files(path = '~/Desktop/data', pattern = 'inflammation')
list.files(path = '~/Desktop/data', pattern = 'inflammation', full.names = T)
```

Now that we've tuned our expression to identify files of interest, let's store the filenames in a variable and check out what one of the files looks like.
```
#GET FILE NAMES
filenames <- list.files(path = "~/Desktop/data", pattern = "inflammation.*csv", full.names = TRUE)

example_file <- filenames[1]

#READ IN ONE OF THE FILES
dat = read.csv(example_file)

#EXPLORE THE FILE AND COMPUTE SOME SUMMARY STATISTICS
dim(dat)
mean(as.matrix(dat))
sd(as.matrix(dat))
```

Next, let's compute our summary metrics for all of our files!
```
for (f in filenames) {
  #READ IN THE FILE
  dat = read.csv(f)

  #PRINT THE NAME OF THE FILE AND THE SIZE OF THE DATA SET
  print(f)
  print(dim(dat))

  #PRINT THE MEAN AND STANDARD DEVIATION OF EACH DATA SET
  print(paste('mean:', mean(as.matrix(dat)))) #row is a patient, avg inflammation 
  print(paste('sd:', sd(as.matrix(dat))))

}
```

## Plotting 

To wrap things up let's do some plotting! 

First, let's read in our data and do our standard summaries
```
data = read.csv('~/Desktop/data/sample.csv', stringsAsFactors = FALSE)
class(data)
str(data)
```

Next, let's make a histogram of the values for one of our variables.

```
hist(data$Aneurisms_q1)
```

That's great, but how can we customize the plot to make it just how we want it?

```
?hist
```

There are lot's of ways to customize! Let's focus on breaks, which determines how data is binned for the histogram. Let's try a few different approaches:

```
#WE CAN JUST STIPULATE THE NUMBER OF BINS 
hist(data$Aneurisms_q1, 100) #breaks = a single number giving the number of cells for the histogram

#OR, WE CAN PROVIDE A VECTOR WITH THE EXACT BINS WE WANT
hist(data$Aneurisms_q1, seq(0,300,5)) #bins of size 5 going from 0 to 300 

#EVEN BETTER, WE CAN TAILOR THE BINS TO THE RANGE OF OUR DATA
hist(data$Aneurisms_q1, seq(0,max(data$Aneurisms_q1),5))
```


Next, let's add labels to our plot so other's know what they are looking at. 

```
hist(data$Aneurisms_q1, seq(0,max(data$Aneurisms_q1),5), 
     main = 'Distribution of aneurism sizes', 
     xlab = 'Size (mm)') 
```

Finally, let's compare two distributions by using the "add" parameter

```
hist(data$Aneurisms_q1, seq(0,max(data$Aneurisms_q1),5), 
     main = 'Distribution of aneurism sizes', 
     xlab = 'Size (mm)', 
     col = rgb(1,0,0,0.5)) 

hist(data$Aneurisms_q4, seq(0,max(data$Aneurisms_q4),5), 
     main = 'Distribution of aneurism sizes', 
     xlab = 'Size (mm)', 
     col = rgb(0,0,1,0.5), add = TRUE) 
```

Let's move onto another type of plot: heatmaps! First, let's install and load pheatmap.

```
#install.packages(pheatmap)
library(pheatmap)
```


For our next plot type, let's explore heatmaps. The first thing we're going to do is look at the options, and then get our data in the right format.

```
#THAT'S A LOT OF OPTIONS TO BEAUTIFY YOUR HEATMAP!
?pheatmap

#SUBSET OUR DATA TO JUST THE COLUMNS CONTAINING ANEURISM MEASUREMENTS
data_subset = data[,grep('An', colnames(data))]

#NEXT, LABEL OUR SUBSET WITH THE PATIENT IDS
row.names(data_subset) = data$ID

#FINALLY, LET'S CREATE ROW ANNOTATIONS FOR OUR HEATMAP
annots = data.frame(group = data$Group)
row.names(annots) = row.names(data_subset)
```

And then plot! 

```
pheatmap(data_subset, 
         annotation_row = annots)
```


**Exercise**: Put gender annotation on heatmap in addition to group 

Solution: 

```
annots = data.frame(group = data$Group, gender = data$Gender)
row.names(annots) = row.names(data_subset)
pheatmap(data_subset, 
         annotation_row = annots)
```

We often need to "clean" our data to be in a format that we want it to be in. Here we will re-format the gender variable. 


```
data$Gender = gsub('f','F',data$Gender)
data$Gender = gsub('m','M',data$Gender)
```

And then we can re-make our heatmap. 

```
annots = data.frame(group = data$Group, gender = data$Gender)
row.names(annots) = row.names(data_subset)
pheatmap(data_subset, 
         annotation_row = annots)
```

Next, let's try a new plot type - the boxplot. Boxplots show the distribution of a single variable. Let's create two boxplots comparing the distribution of blood pressure for males and females. First, let's create variables holding male and female blood pressure.

```
female_bp = data$BloodPressure[data$Gender == 'F']
male_bp = data$BloodPressure[data$Gender == 'M']
```

Then we can make a boxplot.

```
#make a boxplot 
boxplot(female_bp, male_bp)
```

Now let's do one last exercise with a new type of plot - the scatterplot. Scatter plots compare the values of two paired measurements. So, let's plot age versus blood pressure. To make it a bit trickier, let's just do this for the subset of individuals who are both female and in the control group.

**Exercise**: plot age vs. blood pressure (scatterplot) for the females in the control group 

Solution: 

```
table(data$Group)

age = data$Age[data$Gender == 'F' & data$Group == 'Control']
bp = data$BloodPressure[data$Gender == 'F' & data$Group == 'Control']

plot(age, bp)
```
