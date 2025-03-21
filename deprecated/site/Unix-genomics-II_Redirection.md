---
title: "Searching Files and Redirection"
questions:
- "How can I search within files?"
- "How can I combine existing commands to do new things?"
objectives:
- "Employ the `grep` command to search for information within files."
- "Print the results of a command to a file."
- "Construct command pipelines with two or more stages."

---

---
## Table of Contents

- [Searching files](#searching-files)
  * [Exercise 2.1](#exercise-21)
  * [Solution 2.1](#solution-21)
- [Redirecting output](#redirecting-output)
  * [File extensions](#file-extensions)
  * [Exercise 2.2](#exercise-22)
  * [Solution 2.2](#solution-22)
  * [Exercise 2.3](#exercise-23)
  * [Solution 2.3](#solution-23)
  * [Exercise 2.4](#exercise-24)
  * [Solution 2.4](#solution-24)
- [File manipulation and more practice with pipes](#file-manipulation-and-more-practice-with-pipes)
    + [How many of the read libraries are paired end?](#how-many-of-the-read-libraries-are-paired-end-)
  * [Exercise 2.5](#exercise-25)
  * [Solution 2.5](#solution-25)
    + [How many of each class of library layout are there?](#how-many-of-each-class-of-library-layout-are-there-)
  * [Exercise 2.6](#exercise-26)
  * [Solution 2.6](#solution-26)
    + [Can we extract only paired-end records into a new file?](#can-we-extract-only-paired-end-records-into-a-new-file-)
  * [Exercise 2.7](#exercise-27)
  * [Solution 2.7](#solution-27)


----


[click on this link](#searching-files)

## Searching files

We can
search within files without even opening them, using `grep`. `grep` is a command-line
utility for searching plain-text files for specific
characters or patterns. Ex. looking for bad reads (although in real life we have a bioinformatics program do this).

We'll search for strings inside of our fastq files. Let's first make sure we are in the correct
directory:

~~~
$ cd ~/shell_data/untrimmed_fastq
~~~


Suppose we want to see how many reads in our file have really bad segments containing 10 consecutive unknown nucleotides (Ns).

Let's search for the string NNNNNNNNNN in the SRR098026 file:
~~~
$ grep NNNNNNNNNN SRR098026.fastq
~~~


This command returns a lot of output to the terminal. Every single line in the SRR098026
file that contains at least 10 consecutive Ns is printed to the terminal, regardless of how long or short the file is.


We may be interested not only in the actual sequence which contains this string, but may also want to inspect the quality scores associated with
each of these reads. To get all of this information, we will return the line
immediately before each match and the two lines immediately after each match.

We can use the `-B` argument for grep to return a specific number of lines before
each match. The `-A` argument returns a specific number of lines after each matching line. Here we want the line *before* and the two lines *after* each
matching line, so we add `-B1 -A2` to our grep command:

~~~
$ grep -B1 -A2 NNNNNNNNNN SRR098026.fastq
~~~


One of the sets of lines returned by this command is:

~~~
@SRR098026.177 HWUSI-EAS1599_1:2:1:1:2025 length=35
CNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN
+SRR098026.177 HWUSI-EAS1599_1:2:1:1:2025 length=35
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
~~~


> ### Exercise 2.1
>
> 1. Search for the sequence `GNATNACCACTTCC` in the `SRR098026.fastq` file.
> Have your search return all matching lines and the name (or identifier) for each sequence
> that contains a match.
>
> 2. Search for the sequence `AAGTT` in both FASTQ files.
> Have your search return all matching lines and the name (or identifier) for each sequence
> that contains a match.
> > ### Solution 2.1
> > <details>
> > <summary> Click here for solution </summary>
> >
> > 1. `grep -B1 GNATNACCACTTCC SRR098026.fastq`
> >
> >     ```
> >     @SRR098026.245 HWUSI-EAS1599_1:2:1:2:801 length=35
> >     GNATNACCACTTCCAGTGCTGANNNNNNNGGGATG
> >     ```
> >
> > 2. `grep -B1 AAGTT *.fastq`
> >
> >     ```
> >     SRR097977.fastq-@SRR097977.11 209DTAAXX_Lenski2_1_7:8:3:247:351 length=36
> >     SRR097977.fastq:GATTGCTTTAATGAAAAAGTCATATAAGTTGCCATG
> >    --
> >     SRR097977.fastq-@SRR097977.67 209DTAAXX_Lenski2_1_7:8:3:544:566 length=36
> >     SRR097977.fastq:TTGTCCACGCTTTTCTATGTAAAGTTTATTTGCTTT
> >     --
> >     SRR097977.fastq-@SRR097977.68 209DTAAXX_Lenski2_1_7:8:3:724:110 length=36
> >     SRR097977.fastq:TGAAGCCTGCTTTTTTATACTAAGTTTGCATTATAA
> >     --
> >     SRR097977.fastq-@SRR097977.80 209DTAAXX_Lenski2_1_7:8:3:258:281 length=36
> >     SRR097977.fastq:GTGGCGCTGCTGCATAAGTTGGGTTATCAGGTCGTT
> >     --
> >     SRR097977.fastq-@SRR097977.92 209DTAAXX_Lenski2_1_7:8:3:353:318 length=36
> >     SRR097977.fastq:GGCAAAATGGTCCTCCAGCCAGGCCAGAAGCAAGTT
> >     --
> >     SRR097977.fastq-@SRR097977.139 209DTAAXX_Lenski2_1_7:8:3:703:655 length=36
> >     SRR097977.fastq:TTTATTTGTAAAGTTTTGTTGAAATAAGGGTTGTAA
> >     --
> >     SRR097977.fastq-@SRR097977.238 209DTAAXX_Lenski2_1_7:8:3:592:919 length=36
> >     SRR097977.fastq:TTCTTACCATCCTGAAGTTTTTTCATCTTCCCTGAT
> >     --
> >     SRR098026.fastq-@SRR098026.158 HWUSI-EAS1599_1:2:1:1:1505 length=35
> >     SRR098026.fastq:GNNNNNNNNCAAAGTTGATCNNNNNNNNNTGTGCG
> >     ```
> >
>

[click on this link](#redirecting-output)
## Redirecting output

`grep` allowed us to identify sequences in our FASTQ files that match a particular pattern.
All of these sequences were printed to our terminal screen, but in order to work with these
sequences and perform other operations on them, we will need to capture that output in some
way.

We can do this with something called "redirection". The idea is that
we are taking what would ordinarily be printed to the terminal screen and redirecting it to another location.
In our case, we want to print this information to a file so that we can look at it later and
use other commands to analyze this data.

The command for redirecting output to a file is `>`.

Let's try out this command and copy all the records (including all four lines of each record)
in our FASTQ files that contain
'NNNNNNNNNN' to another file called `bad_reads.txt`.

~~~
$ grep -B1 -A2 NNNNNNNNNN SRR098026.fastq > bad_reads.txt
~~~
{: .bash}


> ### File extensions
>
> You might be confused about why we're naming our output file with a `.txt` extension. After all,
> it will be holding FASTQ formatted data that we're extracting from our FASTQ files. Won't it
> also be a FASTQ file? The answer is, yes - it will be a FASTQ file and it would make sense to
> name it with a `.fastq` extension. However, using a `.fastq` extension will lead us to problems
> when we move to using wildcards later in this episode. We'll point out where this becomes
> important. For now, it's good that you're thinking about file extensions!
>


The prompt should sit there a little bit, and then it should look like nothing
happened. But type `ls`. You should see a new file called `bad_reads.txt`.

We can check the number of lines in our new file using a command called `wc`.
`wc` stands for **word count**. This command counts the number of words, lines, and characters
in a file. If we
want only the number of lines, we can use the `-l` flag for `lines` (we would divide by 4 to get the number of bad reads)

~~~
$ wc bad_reads.txt
$ wc -l bad_reads.txt
~~~


> ### Exercise 2.2
>
> How many sequences in `SRR098026.fastq` contain at least 3 consecutive Ns?
>>
>> ### Solution 2.2
>> <details>
>> <summary>  Click here for solution </summary>
>>
>>
>> ~~~
>> $ grep NNN SRR098026.fastq > bad_reads.txt
>> $ wc -l bad_reads.txt
>> ~~~
>>
>> Output
>> ~~~
>> 249
>> ~~~
>>
>

What if we want to get bad reads for all fastq files?
We cam use the redirect command `>` to redirect output
to a file, but the new output will "overwrite" the output that was already present in the file.

We can avoid overwriting our files by using the command `>>`. `>>` is known as the "append redirect" and will
append new output to the end of a file, rather than overwriting it.

~~~
# file 1
$ grep -B1 -A2 NNNNNNNNNN SRR098026.fastq > bad_reads.txt
$ wc -l bad_reads.txt
# file 2 (overwrite)
$ grep -B1 -A2 NNNNNNNNNN SRR097977.fastq > bad_reads.txt
~~~

~~~
# avoid overwriting by using >>
$ grep -B1 -A2 NNNNNNNNNN SRR098026.fastq > bad_reads.txt
$ wc -l bad_reads.txt
$ grep -B1 -A2 NNNNNNNNNN SRR097977.fastq >> bad_reads.txt
$ wc -l bad_reads.txt
~~~


The output of our second call to `wc` shows that we have not overwritten our original data.

We can also do this with a single line of code by using a wildcard:

~~~
$ grep -B1 -A2 NNNNNNNNNN *.fastq > bad_reads.txt
$ wc -l bad_reads.txt
~~~

Expect this to return:

~~~
802 bad_reads.txt
~~~


> ### Exercise 2.3
>
> How many sequences in `SRR098026.fastq` contain at least two regions of 5 unknown nucleotides in a row, separated by any number of known nucleotides?
Hint: Use a wildcard within the string search for grep.
>
>> ### Solution 2.3
>> <details>
>> <summary>  Click here for solution </summary>
>>
>>
>> ~~~
>> $ grep NNNNN*NNNNN SRR098026.fastq > bad_reads_2.txt
>> $ wc -l bad_reads_2.txt
>> ~~~
>>
>> Output
>> ~~~
>> 186
>> ~~~
>>
>>
>

What if we don't want to save an intermediate file, but just want to look at it? We can use the pipe command (`|`)

This is probably not a key on
your keyboard you use very much, so for the standard QWERTY keyboard
layout, the `|` character can be found using the key combination <kbd>Shift</kbd>+ <kbd>\</kbd>


~~~
$ grep -B1 -A2 NNNNNNNNNN SRR098026.fastq | less
~~~


We can now see the output from our `grep` call within the `less` interface. We can use the up and down arrows
to scroll through the output and use `q` to exit `less`.

Now that we know about the pipe (`|`), write a single command to find the number of reads in the `SRR098026.fastq` file that contain at least two regions of 5 unknown nucleotides in a row, separated by any number of known nucleotides. Do this without creating a new file.

> ### Exercise 2.4
>
> How many sequences in `SRR098026.fastq` contain at least two regions of 5 unknown nucleotides in a row, separated by any number of known nucleotides?
Hint: Use a wildcard within the string search for grep.
>
>> ### Solution 2.4
>> <details>
>> <summary>  Click here for solution </summary>
>>
>>
>> ~~~
>> $ grep -B1 -A2 NNNNNNNNNN SRR098026.fastq | wc -l
>> ~~~
>>
>> Expected output:
>> ~~~
>> 186
>> ~~~
>>
>>
>


## File manipulation and more practice with pipes

Let's use the tools we've added to our tool kit so far, along with a few new ones, to example our SRA metadata file. First, let's navigate to the correct directory.

~~~
$ cd
$ cd ../sra_metadata
~~~


This file contains a lot of information about the samples that we submitted for sequencing. Here we're going to use the information in this
file to answer some questions about our samples.

#### How many of the read libraries are paired end?

The samples that we submitted to the sequencing facility were a mix of single and paired end
libraries.
Let's start by looking at our column headers to see which column might have this information. Our
column headers are in the first row of our data table, so we can use `head` with a `-n` flag to
look at just the first row of the file.

~~~
$ head -n 1 SraRunTable.txt
~~~


~~~
BioSample_s	InsertSize_l	LibraryLayout_s	Library_Name_s	LoadDate_s	MBases_l	MBytes_l	ReleaseDate_s Run_s SRA_Sample_s Sample_Name_s Assay_Type_s AssemblyName_s BioProject_s Center_Name_s Consent_s Organism_Platform_s SRA_Study_s g1k_analysis_group_s g1k_pop_code_s source_s strain_s
~~~



Because this is pretty hard to read, we can look at just a few column header names at a time by combining the `|` redirect and a command called `cut` to extract the column of interest.

~~~
$ head -n 1 SraRunTable.txt | cut -f1-4
~~~


`cut` takes a `-f` flag, which stands for "field". This flag accepts a list of field numbers,
in our case, column numbers. Here we are extracting the first four column names.

~~~
BioSample_s InsertSize_l      LibraryLayout_s	Library_Name_s    
~~~


The LibraryLayout_s column looks like it should have the information we want.  Let's look at some
of the data from that column. We can use `cut` to extract only the 3rd column from the file and
then use the `|` operator with `head` to look at just the first few lines of data in that column.

~~~
$ cut -f3 SraRunTable.txt | head -n 10
~~~

Expected output:

~~~
LibraryLayout_s
SINGLE
SINGLE
SINGLE
SINGLE
SINGLE
SINGLE
SINGLE
SINGLE
PAIRED
~~~

We can see that there are (at least) two categories, SINGLE and PAIRED.  To search just for PAIRED entries, we will use the `|` operator twice
to combine `cut` (to extract the column we want), `grep` (to find matches) and `wc` (to count matches).

~~~
$ cut -f3 SraRunTable.txt | grep PAIRED | wc -l
~~~

Expect output:
~~~
2
~~~


We can see from this that we have only two paired-end libraries in the samples we submitted for
sequencing.

> ### Exercise 2.5
>
> How many single-end libraries are in our samples?
>
>> ### Solution 2.5
>> <details>
>> <summary>  Click here for solution </summary>
>>
>> ~~~
>> $ cut -f3 SraRunTable.txt | grep SINGLE | wc -l
>> ~~~
>>
>>
>> Expected output
>> ~~~
>> 35
>> ~~~
>>
>>
>

#### How many of each class of library layout are there?  

We can extract even more information from our metadata table if we add in some new tools: `sort` and `uniq`. The `sort` command will sort the lines of a text file and the `uniq` command will
filter out repeated neighboring lines in a file. If we want to extract all unique lines, we
can do so by combining `uniq` with `sort` so all repeated lines neighbor each other.

~~~
$ cut -f3 SraRunTable.txt | sort
~~~

We have one line that reads "LibraryLayout_s". This is the
header of our column. We can discard this information using the `-v` flag in `grep`, which means
return all the lines that **do not** match the search pattern.

~~~
$ cut -f3 SraRunTable.txt | grep -v LibraryLayout_s | sort
~~~


This command returns a sorted list (too long to show here) of PAIRED and SINGLE values. We can use
the `uniq` command to see a list of all the different categories that are present. If we do this,
we see that the only two types of libraries we have present are labelled PAIRED and SINGLE. There
aren't any other types in our file.

~~~
$ cut -f3 SraRunTable.txt | grep -v LibraryLayout_s | sort | uniq
~~~


~~~
PAIRED
SINGLE
~~~


If we want to count how many of each we have, we can use the `-c` (count) flag for `uniq`.

~~~
$ cut -f3 SraRunTable.txt | grep -v LibraryLayout_s | sort | uniq -c
~~~

Expected output:

~~~
2 PAIRED
35 SINGLE
~~~


> ### Exercise 2.6
>
> 1. How many different sample load dates are there?   
> 2. How many samples were loaded on each date?  
>
>> ### Solution 2.6
>> <details>
>> <summary>  Click here for solution </summary>
>>  
>> 1. There are two different sample load dates.  
>>
>>    ~~~
>>    cut -f5 SraRunTable.txt | grep -v LoadDate_s | sort | uniq
>>    ~~~
>>    
>>
>>    ~~~
>>    25-Jul-12
>>    29-May-14
>>    ~~~
>>    
>>
>> 2. Six samples were loaded on one date and 31 were loaded on the other.
>>
>>    ~~~
>>    cut -f5 SraRunTable.txt | grep -v LoadDate_s | sort | uniq -c
>>    ~~~
>>    
>>
>>    ~~~
>>     6 25-Jul-12
>>    31 29-May-14
>>    ~~~
>>   
>>
>



#### Can we extract only paired-end records into a new file?  

We also might want to extract the information for all samples that meet a specific criterion
(for example, are paired-end) and put those lines of our table in a new file. First, we need
to check to make sure that the pattern we're searching for ("PAIRED") only appears in the column
where we expect it to occur (column 3). We know from earlier that there are only two paired-end
samples in the file, so we can `grep` for "PAIRED" and see how many results we get.

~~~
$ grep PAIRED SraRunTable.txt | wc -l
~~~

Expected output:
~~~
2
~~~


There are only two results, so we can use "PAIRED" as our search term to extract the paired-end
samples to a new file.

~~~
$ grep PAIRED SraRunTable.txt > SraRunTable_only_paired_end.txt
~~~


> ### Exercise 2.7
> Sort samples by load date and export each of those sets to a new file (one new file per
> unique load date).
>
>> ### Solution 2.7
>> <details>
>> <summary>  Click here for solution </summary>
> >
> > ~~~
> > $ grep 25-Jul-12 SraRunTable.txt > SraRunTable_25-Jul-12.txt
> > $ grep 29-May-14 SraRunTable.txt > SraRunTable_29-May-14.txt
> > ~~~
> >
> >
>


Sort file by library layout and save to a new file. Use `-k` (key) flag to sort based on particular column
~~~
sort -k3 SraRunTable.txt > SraRunTable_sorted_by_layout.txt
~~~

### :: BREAK (~14:30-14:45) ::

---
# Keypoints:
- `grep` is a powerful search tool with many options for customization.
- `>`, `>>`, and `|` are different ways of redirecting output.
- `command > file` redirects a command's output to a file.
- `command >> file` redirects a command's output to a file without overwriting the existing contents of the file.
- `command_1 | command_2` redirects the output of the first command as input to the second command.
---

# References
- Content adapted from [Data Carpentry materials](https://datacarpentry.org/shell-genomics/04-redirection/)
  - Erin Alison Becker, Anita Schürch, Tracy Teal, Sheldon John McKay, Jessica Elizabeth Mizzi, François Michonneau, et al. (2019, June). datacarpentry/shell-genomics: Data Carpentry: Introduction to the shell for genomics data, June 2019 (Version v2019.06.1). Zenodo. http://doi.org/10.5281/zenodo.3260560


- [Table of contents generated with markdown-toc](http://ecotrust-canada.github.io/markdown-toc/)
