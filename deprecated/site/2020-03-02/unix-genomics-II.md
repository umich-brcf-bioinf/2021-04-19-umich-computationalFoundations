# [Introduction to the Command Line for Genomics](https://datacarpentry.org/shell-genomics)

13:00 |
14:30-14:45 BREAK |
14:45 |
15:50 Wrap-up |
16:00 END

## [Redirection](https://datacarpentry.org/shell-genomics/04-redirection/)
13:00-14:30

### Searching files
Can use `grep` to search files for specific characters or patterns. Ex. looking for bad reads (in real life we have a bioinformatics program do this)
```
cd shell_data/untrimmed_fastq
# search for read segments containing 10 consecutive unknown nucleotides (Ns)
grep NNNNNNNNNN SRR098026.fastq
# return line before each match (identifier) and 2 lines after (quality scores)
grep -B1 -A2 NNNNNNNNNN SRR098026.fastq
```

**Exercise:**
1. Search for the sequence `GNATNACCACTTCC` in the `SRR098026.fastq` file. Have your search return all matching lines and the name (or identifier) for each sequence that contains a match.
2. Search for the sequence `AAGTT` in both FASTQ files. Have your search return all matching lines and the name (or identifier) for each sequence that contains a match.

**Solution:**
1. `grep -B1 GNATNACCACTTCC SRR098026.fastq`
2. `grep -B1 AAGTT *.fastq`

### Redirecting output
Can redirect the output to the terminal to another location (ex. print to file)
```
# redirect output to file
grep -B1 -A2 NNNNNNNNNN SRR098026.fastq > bad_reads.txt
grep NNNNNNNNNN SRR098026.fastq > bad_reads_only.txt
# check number of lines using wc (divide by 4 to get number of bad reads)
wc bad_reads.txt
wc -l bad_reads.txt
```

**Exercises & Solutions:**
- How many sequences in `SRR098026.fastq` contain at least 3 consecutive Ns?
```
grep NNN SRR098026.fastq > bad_reads.txt
wc -l bad_reads.txt
# 249
```

What if we want to get bad reads for all fastq files? Redirect command `>` overwrites files. Avoid overwriting by using `>>` (append redirect).
```
# file 1
grep -B1 -A2 NNNNNNNNNN SRR098026.fastq > bad_reads.txt
wc -l bad_reads.txt
# file 2 (overwrite)
grep -B1 -A2 NNNNNNNNNN SRR097977.fastq > bad_reads.txt
wc -l bad_reads.txt # no lines matching our sequence
# avoid overwriting by using >>
grep -B1 -A2 NNNNNNNNNN SRR098026.fastq > bad_reads.txt
wc -l bad_reads.txt
grep -B1 -A2 NNNNNNNNNN SRR097977.fastq >> bad_reads.txt
wc -l bad_reads.txt
# or use wildcard
grep -B1 -A2 NNNNNNNNNN *.fastq > bad_reads.txt
wc -l bad_reads.txt
```

**Exercise:** How many reads in the `SRR098026.fastq` file contain at least two regions of 5 unknown nucleotides in a row, separated by any number of known nucleotides?
Hint: Use a wildcard within the string search for grep.

**Solution:**
```
grep NNNNN*NNNNN SRR098026.fastq > bad_reads_2.txt
wc -l bad_reads_2.txt
#186 bad_reads_2.txt
```

What if we don't want to save an intermediate file, but just want to look at it? We can use the pipe command (`|`)
```
grep -B1 -A2 NNNNNNNNNN SRR098026.fastq | less
```

Now that we know about the pipe (`|`), write a single command to find the number of reads in the `SRR098026.fastq` file that contain at least two regions of 5 unknown nucleotides in a row, separated by any number of known nucleotides. Do this without creating a new file.
```
grep "NNNNN*NNNNN" SRR098026.fastq | wc -l
#186
```

**Exercise & Solution:**
(Maybe skip next time? Doesn't seem super relevant. But maybe think of better example)

How many files in `/usr/bin/` start with c? Have an a? End with o? Have an a or c?
```
ls /usr/bin/c* | wc -l
ls /usr/bin/*a* | wc -l
ls /usr/bin/*o | wc -l
ls /usr/bin/*a* /usr/bin/*o* | wc -l
ls /usr/bin/*[ac]* | wc -l
```

### File manipulation and more practice with pipes
```
# change directories
cd ../sra_metadata
```

How many of the read libraries are paired end?
```
# look at column names of metadata file
head -n 1 SraRunTable.txt #(maybe: | tr '\t' '\n' | cat --number)
# use cut to look at a few at a time (-f is field)
head -n 1 SraRunTable.txt | cut -f1-4
# LibraryLayout_s has information we want
cut -f3 SraRunTable.txt | head -n 10
# search all entries in column for PAIRED and out number of matches
cut -f3 SraRunTable.txt | grep PAIRED | wc -l
```

**Exercise:** How many single-end libraries are in our sample?

**Solution:**
```
cut -f3 SraRunTable.txt | grep SINGLE | wc -l
#35
```

How many of each class of library layout are there? Can use `sort` and `uniq`.
```
# sort column
cut -f3 SraRunTable.txt | sort
# grep -v = everything that doesn't match
cut -f3 SraRunTable.txt | grep -v LibraryLayout_s | sort
# check what types of libraries there are
cut -f3 SraRunTable.txt | grep -v LibraryLayout_s | sort | uniq
# count how many of each library (look in manual?)
cut -f3 SraRunTable.txt | grep -v LibraryLayout_s | sort | uniq -c
```

**Exercise:**
1. How many different sample load dates are there?
2. How many samples were loaded on each date?

**Solution:**
```
cut -f5 SraRunTable.txt | grep -v LoadDate_s | sort | uniq | wc -l
# 2
cut -f5 SraRunTable.txt | grep -v LoadDate_s | sort | uniq -c
# 6 and 31
```

Extract only paired-end records into a new file
```
# check PAIRED doesn't occur in any other columns
grep PAIRED SraRunTable.txt | wc -l
# get PAIRED rows and redirect to output file
grep PAIRED SraRunTable.txt > SraRunTable_only_paired_end.txt
grep -E 'PAIRED|BioSample' SraRunTable.txt > SraRunTable_only_paired_end.txt
```

Not doing. (doing in 2020)
**Exercise:** Make 2 new files - one for each unique load date.

**Solution:**
```
grep -E '25-Jul-12|BioSample' SraRunTable.txt > SraRunTable_25-Jul-12.txt
grep -E '29-May-14|BioSample' SraRunTable.txt > SraRunTable_29-May-14.txt
```

Sort file by library layout and save to a new file. Use `-k` (key) flag to sort based on particular column
```
sort -k3 SraRunTable.txt > SraRunTable_sorted_by_layout.txt
```
BREAK (~14:30-14:45)

### Writing for loops

Self checkout example

Loops allow us to execute commands repeatedly (ex. do the same thing on a bunch of files)
- for: repeat command (or group of commands) once for each item in list
- Each time loop runs (iteration), an item in the list is assigned in sequence to the variable, and the commands inside the loop are executed before moving on to the next item in the list
- Inside the loop, we call the variable's value by putting a `$` in front of it - tells the sell interpreter to treat the variable as a variable name and substitute its value in its place (instead of treat it as text or an external command)
For loop to show us the first 2 lines of the fastq files: (`>` means we haven't finished completing the command yet)
```
cd ../untrimmed_fastq
for filename in *.fastq # Also show example where use no wildcard!
do
head -n2 ${filename}
done
```

`for <variable> in <group to iterate over>` means the word `filename` is designated as the variable to be used over each iteration. Here, `SRR097977.fastq` and `SRR098026.fastq` will be substituted for filename because they fit the pattern of ending with `.fastq` in directory we’ve specified. We are telling the loop to print the first two lines of each variable we iterate over. Finally, the word `done` ends the loop.

Loop to save the information to a text file:
```
for filename in \*.fastq
do
head -n2 ${filename} >> seq_info.txt
done
```

Using basename in for loops - removes uniform part of a name from a list of files. (Just changes the variable, not the actual files)

Maybe skip next time
```
for filename in \*.fastq
do
name=$(basename ${filename} .fastq)
echo ${name}
done
```

Loop to get the number of single and paired end libraries in SraRunTable.txt:
```
for lib_type in SINGLE PAIRED
do
echo $lib_type
cut -f3 SraRunTable.txt | grep $lib_type | wc -l
done
```

### Getting data from the cloud
Can use  `wget` (world wide web get; download) or `curl` (see URL; display)

Download data from Ensemble (saying what is available). See which program you have:
```
which curl
which wget
cd ..
wget ftp://ftp.ensemblgenomes.org/pub/release-37/bacteria/species_EnsemblBacteria.txt
curl -O ftp://ftp.ensemblgenomes.org/pub/release-37/bacteria/species_EnsemblBacteria.txt # -O downloads and saves as same name
```

**Exercise:**
For the following bacteria, find how many of that type of bacteria are available from Ensemble: Klebsiella, Acinetobacter, Staphylococcus, Clostridium.

**Solution:**
for i in Klebsiella Acinetobacter Staphylococcus Clostridium; do echo $i $(cut -f1 species_EnsemblBacteria.txt | grep -i $i | wc -l); done
**all bacteria example**

### Key Points
- grep is a powerful search tool with many options for customization.
- >, >>, and | are different ways of redirecting output.
- command > file redirects a command’s output to a file.
- command >> file redirects a command’s output to a file without overwriting the existing contents of the file.
- command_1 | command_2 redirects the output of the first command as input to the second command.
- for loops are used for iteration
- basename gets rid of repetitive parts of names


## [Writing scripts and working with data](https://datacarpentry.org/shell-genomics/05-writing-scripts/)
14:45-15:50 (15:20-)

### Writing files
How can we write our own files? Ex. to take notes on what we've been doing. `README.txt` describes data files in directory or documents how the files were generated. Will use the text editor `nano` (only plain text). Other text editors: emacs, vim, gedit, notepad++
```
cd ../untrimmed_fastq
nano README.txt # then type in some text
# ctrl-O to save (then enter), ctrl-X to quit editor and return to shell
less README.txt
```

**Exercise:** Open `README.txt`, add date to top of file, and save file.

**Solution:**
Use `nano README.txt` to open the file.
Add today’s date and then use Ctrl-X to exit and y to save.

### Writing scripts

To save commands to run them, can put multiple commands together. You can re-use them as many times as you want. Also helps with reproducibility.

Script to look for reads with long sequences of N's that we can run every time we get new sequences.
```
# 10 consecutive N's, line above and 2 lines below, all files ending with \*.fastq
nano bad-reads-script.sh
# add this: grep -B1 -A2 NNNNNNNNNN \*.fastq > scripted_bad_reads.txt
bash bad-reads-script.sh
less scripted_bad_reads.txt
```

(skip!)
**Exercise:**
1. How many bad reads are there in the two FASTQ files combined?
2. How many bad reads are in each of the two FASTQ files? (Hint: You will need to use the `cut` command with the `-d` flag.)

**Solution:**
```
wc -l scripted_bad_reads.txt
#537/4
grep -B1 -A2 NNNNNNNNNN \*.fastq | grep -v '\-\-' | wc -l
#536/4
cut -d . -f1 scripted_bad_reads.txt | sort | uniq -c
#all in 1
```

Have script tell us when it's done:
```
nano bad-reads-script.sh
# add echo "Script finished!" at end
bash bad-reads-script.sh
```

### Making the script into a program
Had to type `bash` because needed to tell computer what program to use to run script. Can make it into it's own program by making it executable (change file permissions).
```
ls -l bad-reads-script.sh
chmod +x bad-reads-script.sh # add executable permissions
ls -l bad-reads-script.sh
./bad-reads-script.sh # it's a computer program!
```

### Adding arguments
What if we want to have a user-defined output file name? Can pass an argument to the script.
```
nano bad-reads-script.sh
# change scripted_bad_reads.txt to $1 # first thing after script name
./bad-reads-script.sh argument_bad_reads.txt
ls
```
**Exercise:**
Modify `bad-reads-script.sh` so any sequence of characters can be grepped

**Solution:**
```
nano bad-reads-script.sh
# change NNNNNNNNNN to $2 # first thing after script name
./bad-reads-script.sh argument_bad_reads.txt NNNNN*NNNNN
ls
```

Other useful commands:
- ctrl+r


## Moving and downloading data

Already learned wget

### Transferring data between your local machine and the cloud
Run `scp` (secure copy protocol) locally
```
# scp <local file I want to move> <where I want to move it on flux>
scp local_file.txt scp uniqname@greatlakes-xfer.arc-ts.umich.edu:/scratch/micro612_w19
# scp <flux> <local file>
scp uniqname@greatlakes-xfer.arc-ts.umich.edu:/scratch/micro612_w19/dc_workshop/scripted_bad_reads.txt. ~/Downloads
```
