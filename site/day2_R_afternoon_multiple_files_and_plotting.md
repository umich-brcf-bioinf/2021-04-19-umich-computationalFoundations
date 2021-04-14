## Processing multiple files 

We are studying inflammation in patients who have been given a new treatment for arthritis, and need to analyze the first dozen data sets of their daily inflammation. The data sets are stored in CSV format (comma-separated values): each row holds information for a single patient, and the columns represent successive days. The first few rows of our first file look like this:
  
 ``` 
list.files(path = '~/Desktop/data', pattern = 'csv')
list.files(path = '~/Desktop/data', pattern = 'inflammation')
list.files(path = '~/Desktop/data', pattern = 'inflammation', full.names = T)
```

```
filenames <- list.files(path = "~/Desktop/data", pattern = "inflammation.*csv", full.names = TRUE)
filenames <- filenames[1:3]
for (f in filenames) {
  dat = read.csv(f)
  print(dim(dat))
  print(rowMeans(dat)) #row is a patient, avg inflammation 
  hist(rowMeans(dat), main = f)
}
```

## Plotting 

Let's dive into plotting. 


```
data = read.csv('~/Desktop/data/sample.csv', stringsAsFactors = FALSE)
class(data)

hist(data$Aneurisms_q1)
```

What if we want to change the bin sizes on our histogram?

```
#bin sizes 
hist(data$Aneurisms_q1, 100) #breaks = a single number giving the number of cells for the histogram
?hist
hist(data$Aneurisms_q1, seq(0,300,5)) #bins of size 5 going from 0 to 300 
```

How do we get the range of our data?

```
hist(data$Aneurisms_q1, seq(0,max(data$Aneurisms_q1),5))
```

Let's add labels to our plot. 

```
hist(data$Aneurisms_q1, seq(0,max(data$Aneurisms_q1),5), 
     main = 'Distribution of aneurism sizes', 
     xlab = 'Size (mm)') 
```

What if we want to compare two distributions?

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

Let's move onto another type of plot: heatmaps!

```
#install.packages(pheatmap)
library(pheatmap)
```

We need to format the data to be compatible with pheatmap. 

```
data_subset = data[,grep('An', colnames(data))]
row.names(data_subset) = data$ID
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

What if we wanted to subset data to just females or just males? 

```
female_bp = data$BloodPressure[data$Gender == 'F']
male_bp = data$BloodPressure[data$Gender == 'M']
```

Then we can make a boxplot.

```
#make a boxplot 
boxplot(female_bp, male_bp)
```

**Exercise**: plot age vs. blood pressure (scatterplot) for the females in the control group 

Solution: 

```
table(data$Group)
plot(data$Age[data$Gender == 'F' & data$Group == 'Control'], 
     data$BloodPressure[data$Gender == 'F' & data$Group == 'Control'])
```
