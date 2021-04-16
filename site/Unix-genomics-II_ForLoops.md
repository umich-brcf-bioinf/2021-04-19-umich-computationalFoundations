---
title: "For Loops and Scripts"
questions:
- "Use `for` loops to run the same command for several input files."
- "How can we automate a commonly used set of commands?"
objectives:
- "Use the `nano` text editor to modify text files."
- "Write a basic shell script."
- "Use the `bash` command to execute a shell script."
- "Use `chmod` to make a script an executable program."
---

---
## Table of Contents

- [Writing for loops](#writing-for-loops)
- [Using Basename in for loops (Optional section)](#using-basename-in-for-loops--optional-section-)
    + [Exercise 3.1](#exercise-31)
    + [Solution 3.1](#solution-31)
- [Exercise 3.2](#exercise-32)
- [Solution 3.2](#solution-32)
- [Writing scripts and working with data](#writing-scripts-and-working-with-data)
- [Writing files](#writing-files)
- [Which Editor?](#which-editor-)
- [Control, Ctrl, or ^ Key](#control--ctrl--or---key)
    + [Exercise 3.3](#exercise-33)
    + [Solution 3.3](#solution-33)
- [Writing scripts](#writing-scripts)
  * [Custom `grep` control](#custom--grep--control)
    + [Exercise 3.4](#exercise-34)
    + [Solution 3.4](#solution-34)
- [Making the script into a program](#making-the-script-into-a-program)
  * [Adding arguments](#adding-arguments)
    + [Exercise 3.5](#exercise-35)
    + [Solution 3.5](#solution-35)
- [Moving and Downloading Data](#moving-and-downloading-data)
  * [Getting data from the cloud](#getting-data-from-the-cloud)
  * [Exercise 3.6](#exercise-36)
  * [Solution 3.6](#solution-36)

---

[click on this link](#writing-for-loops)
## Writing for loops

Loops allow us to execute commands repeatedly (ex. do the same thing on a bunch of files), similar to how you would have a basket of groceries but would get the price and add to your bill to your bill by scanning each item on the self checkout kiosk.

- for: repeat command (or group of commands) once for each item in list
- Each time loop runs (iteration), an item in the list is assigned in sequence to the variable, and the commands inside the loop are executed before moving on to the next item in the list
- Inside the loop, we call the variable's value by putting a `$` in front of it - tells the sell interpreter to treat the variable as a variable name and substitute its value in its place (instead of treat it as text or an external command)
For loop to show us the first 2 lines of the fastq files: (`>` means we haven't finished completing the command yet)

~~~
$ cd ../untrimmed_fastq
$ for filename in SRR097977.fastq SRR098026.fastq
$ do
$ echo ${filename}
$ done
~~~


`for <variable> in <group to iterate over>` means the word `filename` is designated as the variable to be used over each iteration. We are telling the loop to print the first two lines of each variable we iterate over. We avoid the problem of interpreter is trying to expand a variable by enclosing the variable name in
braces (`{` and `}`, sometimes called "squiggle braces"). Finally, the word `done` ends the loop.

We can try another example using wildcard characters to reduce our typing.
~~~
$ for filename in *.fastq # add a wildcard
$ do
$ head -n2 ${filename}
$ done
~~~


Here, `SRR097977.fastq` and `SRR098026.fastq` will be substituted for filename because they fit the pattern of ending with `.fastq` in directory we’ve specified. Note that `bash` treats the `#`
character as a comment character. Any text on a line after a `#` is ignored by
bash when evaluating the text as code.

After executing the loop, you should see the first two lines of both fastq files printed to the terminal. Let's create a loop that
will save this information to a file.

~~~
$ for filename in *.fastq
> do
> head -n 2 ${filename} >> seq_info.txt
> done
~~~


When writing a loop, you will not be able to return to previous lines once you have pressed Enter. Remember that we can cancel the current command using

- <kbd>Ctrl</kbd>+<kbd>C</kbd>

If you notice a mistake that is going to prevent your loop for executing correctly.

Note that we are using `>>` to append the text to our `seq_info.txt` file. If we used `>`, the `seq_info.txt` file would be rewritten
every time the loop iterates, so it would only have text from the last variable used. Instead, `>>` adds to the end of the file.

Next, we'll write a loop that has more than one step executed. Loop to get the number of single and paired end libraries in SraRunTable.txt:
```
for lib_type in SINGLE PAIRED
do
echo $lib_type
cut -f3 SraRunTable.txt | grep $lib_type | wc -l
done
```


## Using Basename in for loops (Optional section)
Basename is a function in UNIX that is helpful for removing a uniform part of a name from a list of files. In this case, we will use basename to remove the `.fastq` extension from the files that we’ve been working with.

~~~
$ basename SRR097977.fastq .fastq
~~~


We see that this returns just the SRR accession, and no longer has the .fastq file extension on it.

~~~
SRR097977
~~~


If we try the same thing but use `.fasta` as the file extension instead, nothing happens. This is because basename only works when it exactly matches a string in the file.

~~~
$ basename SRR097977.fastq .fasta
~~~


~~~
SRR097977.fastq
~~~


Basename is really powerful when used in a for loop. It allows to access just the file prefix, which you can use to name things. Let's try this.

Inside our for loop, we create a new name variable. We call the basename function inside the parenthesis, then give our variable name from the for loop, in this case `${filename}`, and finally state that `.fastq` should be removed from the file name. It’s important to note that we’re not changing the actual files, we’re creating a new variable called name. The line > echo $name will print to the terminal the variable name each time the for loop runs. Because we are iterating over two files, we expect to see two lines of output.

~~~
$ for filename in *.fastq
> do
> name=$(basename ${filename} .fastq)
> echo ${name}
> done
~~~




> #### Exercise 3.1
>
> Print the file prefix of all of the `.txt` files in our current directory.
>
>> #### Solution 3.1
>> <details>
>> <summary>  Click here for solution </summary>
>>
>> ~~~
>> $ for filename in *.txt
>> > do
>> > name=$(basename ${filename} .txt)
>> > echo ${name}
>> > done
>> ~~~
>>
>

One way this is really useful is to move files. Let's rename all of our .txt files using `mv` so that they have the years on them, which will document when we created them.

~~~
$ for filename in *.txt
> do
> name=$(basename ${filename} .txt)
> mv ${filename}  ${name}_2019.txt
> done
~~~



> ## Exercise 3.2
>
> Remove `_2019` from all of the `.txt` files.
>
>> ## Solution 3.2
>> <details>
>> <summary>  Click here for solution </summary>
>>
>>
>> ~~~
>> $ for filename in *_2019.txt
>> > do
>> > name=$(basename ${filename} _2019.txt)
>> > mv ${filename} ${name}.txt
>> > done
>> ~~~
>>
>

[click on this link](#writing-scripts-and-working-with-data)
## Writing scripts and working with data

## Writing files

We've been able to do a lot of work with files that already exist, but what if we want to write our own files? We're not going to type in a FASTA file, but we'll see as we go through other tutorials, there are a lot of reasons we'll want to write a file, or edit an existing file.

To add text to files, we're going to use a text editor called Nano. We're going to create a plain text file to take notes about what we've been doing with the data files in `~/shell_data/untrimmed_fastq`.

This is good practice when working in bioinformatics. We can create a file called `README.txt` that describes the data files in the directory or documents how the files in that directory were generated.  As the name suggests, it's a file that we or others should read to understand the information in that directory.

Let's change our working directory to `~/shell_data/untrimmed_fastq` using `cd`,
then run `nano` to create a file called `README.txt`:

~~~
$ cd ~/shell_data/untrimmed_fastq
$ nano README.txt # then type in some text
# ctrl-O to save (then enter), ctrl-X to quit editor and return to shell
less README.txt
~~~


The text at the bottom of the screen shows the keyboard shortcuts for performing various tasks in `nano`. We will talk more about how to interpret this information soon.

> ## Which Editor?
> <details>
> <summary>  Click here for overview of editor options </summary>
> When we say, "`nano` is a text editor," we really do mean "text": it can
> only work with plain character data, not tables, images, or any other
> human-friendly media. We use it in examples because it is one of the
> least complex text editors. However, because of this trait, it may
> not be powerful enough or flexible enough for the work you need to do
> after this workshop. On Unix systems (such as Linux and Mac OS X),
> many programmers use [Emacs](http://www.gnu.org/software/emacs/) or
> [Vim](http://www.vim.org/) (both of which require more time to learn),
> or a graphical editor such as
> [Gedit](http://projects.gnome.org/gedit/). On Windows, you may wish to
> use [Notepad++](http://notepad-plus-plus.org/).  Windows also has a built-in
> editor called `notepad` that can be run from the command line in the same
> way as `nano` for the purposes of this lesson.  
>
> No matter what editor you use, you will need to know where it searches
> for and saves files. If you start it from the shell, it will (probably)
> use your current working directory as its default location. If you use
> your computer's start menu, it may want to save files in your desktop or
> documents directory instead. You can change this by navigating to
> another directory the first time you "Save As..."


Let's type in a few lines of text. Describe what the files in this
directory are or what you've been doing with them.
Once we're happy with our text, we can press <kbd>Ctrl</kbd>-<kbd>O</kbd> (press the <kbd>Ctrl</kbd> or <kbd>Control</kbd> key and, while
holding it down, press the <kbd>O</kbd> key) to write our data to disk. You'll be asked what file we want to save this to:
press <kbd>Return</kbd> to accept the suggested default of `README.txt`.

Once our file is saved, we can use <kbd>Ctrl</kbd>-<kbd>X</kbd> to quit the editor and
return to the shell.

> ## Control, Ctrl, or ^ Key
>
> The Control key is also called the "Ctrl" key. There are various ways
> in which using the Control key may be described. For example, you may
> see an instruction to press the <kbd>Ctrl</kbd> key and, while holding it down,
> press the <kbd>X</kbd> key, described as any of:
>
> * `Control-X`
> * `Control+X`
> * `Ctrl-X`
> * `Ctrl+X`
> * `^X`
> * `C-x`
>
> In `nano`, along the bottom of the screen you'll see `^G Get Help ^O WriteOut`.
> This means that you can use <kbd>Ctrl</kbd>-<kbd>G</kbd> to get help and <kbd>Ctrl</kbd>-<kbd>O</kbd> to save your
> file.


Now you've written a file. You can take a look at it with `less` or `cat`, or open it up again and edit it with `nano`.

> #### Exercise 3.3
>
> Open `README.txt` and add the date to the top of the file and save the file.
>
>> #### Solution 3.3
>> <details>
>> <summary>  Click here for solution </summary>
> >
> > Use `nano README.txt` to open the file.  
> > Add today's date and then use <kbd>Ctrl</kbd>-<kbd>X</kbd> followed by `y` and <kbd>Enter</kbd> to save.
> >
>

## Writing scripts

A really powerful thing about the command line is that you can write scripts. Scripts let you save commands to run them and also lets you put multiple commands together. Writing scripts can save you time as you run them repeatedly and can address the challenge of reproducibility: if you need to repeat an analysis, you retain a record of your command history within the script.

One thing we will commonly want to do with sequencing results is pull out bad reads so we will write a script to look for reads with long sequences of N's that we can run every time we get new sequences.

We're going to create a new file to put this command in. We'll call it `bad-reads-script.sh`. The `sh` isn't required, but using that extension tells us that it's a shell script.

~~~
$ nano bad-reads-script.sh
~~~


Now we can write the command we want in the script file. Bad reads have a lot of N's, so we're going to look for  `NNNNNNNNNN` with `grep`. We want the whole FASTQ record, so we're also going to get the one line above the sequence and the two lines below. We also want to look in all the files that end with `.fastq`, so we're going to use the `*` wildcard.

~~~
grep -B1 -A2 -h NNNNNNNNNN *.fastq | grep -v '^--' > scripted_bad_reads.txt
~~~


> ### Custom `grep` control
>
> We introduced the `-v` option previously, now we
> are using `-h` to "Suppress the prefixing of file names on output" according to the documentation shown by `man grep`.
>



Now comes the neat part. We can run this script. Type:

~~~
$ bash bad-reads-script.sh
~~~
{: .bash}

It will look like nothing happened, but now if you look at `scripted_bad_reads.txt`, you can see that there are now reads in the file.


> #### Exercise 3.4
>
> We want the script to tell us when it's done.  
> 1. Open `bad-reads-script.sh` and add the line `echo "Script finished!"` after the `grep` command and save the file.  
> 2. Run the updated script.
>
>> #### Solution 3.4
>> <details>
>> <summary>  Click here for solution </summary>
> >
> >   ```
> >   nano bad-reads-script.sh
> >   # add echo "Script finished!" at end
> >   ```
> >
> >   ```
> >   $ bash bad-reads-script.sh
> >   Script finished!
> >   ```
> >
> {: .solution}
{: .challenge}

## Making the script into a program

We had to type `bash` because we needed to tell the computer what program to use to run this script. Instead, we can turn this script into its own program. We need to tell it that it's a program by making it executable. We can do this by changing the file permissions.

First, let's look at the current permissions.

~~~
$ ls -l bad-reads-script.sh
~~~
{: .bash}

~~~
-rw-rw-r-- 1 dcuser dcuser 0 Oct 25 21:46 bad-reads-script.sh
~~~
{: .output}

We see that it says `-rw-r--r--`. This shows that the file can be read by any user and written to by the file owner (you). We want to change these permissions so that the file can be executed as a program. We use the command `chmod` like we did earlier when we removed write permissions. Here we are adding (`+`) executable permissions (`+x`).

~~~
$ chmod +x bad-reads-script.sh
~~~
{: .bash}

Now let's look at the permissions again.

~~~
$ ls -l bad-reads-script.sh
~~~
{: .bash}

~~~
-rwxrwxr-x 1 dcuser dcuser 0 Oct 25 21:46 bad-reads-script.sh
~~~
{: .output}

Now we see that it says `-rwxr-xr-x`. The `x`'s that are there now tell us we can run it as a program. So, let's try it! We'll need to put `./` at the beginning so the computer knows to look here in this directory for the program.

~~~
$ ./bad-reads-script.sh
~~~
{: .bash}

The script should run the same way as before, but now we've created our very own computer program!

If you would like to learn about writing scripts, we suggest referencing [a Data Carpentry for Genomics lesson](https://datacarpentry.org/wrangling-genomics/05-automation/index.html).

### Adding arguments
What if we want to have a user-defined output file name? Can pass an argument to the script.

~~~
nano bad-reads-script.sh
# change scripted_bad_reads.txt to $1 # first thing after script name
~~~

~~~
./bad-reads-script.sh argument_bad_reads.txt
ls
~~~


> #### Exercise 3.5
>
> Modify `bad-reads-script.sh` so any sequence of characters can be grepped
>
>> #### Solution 3.5
>> <details>
>> <summary>  Click here for solution </summary>
>>
>>  ~~~
>>  nano bad-reads-script.sh
>>  # change NNNNNNNNNN to $2 # first thing after script name
>>  ./bad-reads-script.sh argument_bad_reads.txt NNNNN*NNNNN
>>  ls
>>  ~~~
>>
>



## Moving and Downloading Data

So far, we've worked with data that was stored locally. Usually, however,
most analyses begin with moving data to or from a high performance computing (HPC) environment.

### Getting data from the cloud

There are two programs that will download data from a remote server to your local
(or remote) machine: ``wget`` and ``curl``. They were designed to do slightly different
tasks by default, so you'll need to give the programs somewhat different options to get
the same behaviour, but they are mostly interchangeable.

 - ``wget`` is short for "world wide web get", and it's basic function is to *download*
 web pages or data at a web address.

 - ``cURL`` is a pun, it is supposed to be read as "see URL", so its basic function is
 to *display* webpages or data at a web address.

Which one you need to use mostly depends on your operating system, as most computers will
only have one or the other installed by default.

Let's say you want to download some data from Ensembl. We're going to download a very small
tab-delimited file that just tells us what data is available on the Ensembl bacteria server.
Before we can start our download, we need to know whether we're using ``curl`` or ``wget``.

To see which program you have, type:

~~~
$ which curl
$ which wget
~~~
{: .bash}

``which`` is a BASH program that looks through everything you have
installed, and tells you what folder it is installed to. If it can't
find the program you asked for, it returns nothing, i.e. gives you no
results.

On Mac OSX, you'll likely get the following output:

~~~
$ which curl
~~~

~~~
$ /usr/bin/curl
~~~


~~~
$ which wget
~~~


~~~
$
~~~


This output means that you have ``curl`` installed, but not ``wget``.

Once you know whether you have ``curl`` or ``wget``, use one of the
following commands to download the file:

~~~
$ cd ..
$ wget ftp://ftp.ensemblgenomes.org/pub/release-37/bacteria/species_EnsemblBacteria.txt
~~~


OR

~~~
$ cd ..
$ curl -O ftp://ftp.ensemblgenomes.org/pub/release-37/bacteria/species_EnsemblBacteria.txt
~~~


Since we wanted to *download* the file rather than just view it, we used ``wget`` without
any modifiers. With ``curl`` however, we had to use the -O flag, which simultaneously tells ``curl`` to
download the page instead of showing it to us **and** specifies that it should save the
file using the same name it had on the server: species_EnsemblBacteria.txt

It's important to note that both ``curl`` and ``wget`` download to the computer that the
command line belongs to. So, if you are logged into a HPC (AWS or GreatLakes) on the command line and execute
the ``curl`` command above in the HPC terminal, the file will be downloaded to your HPC
machine, not your local one.

> ### Exercise 3.6
> For the following bacteria, find how many of that type of bacteria are available from Ensemble: Klebsiella, Acinetobacter, Staphylococcus, Clostridium.
>
>> ### Solution 3.6
>> <details>
>> <summary>  Click here for solution </summary>
>>  ~~~
>>  for i in Klebsiella Acinetobacter Staphylococcus Clostridium; do echo $i $(cut -f1 species_EnsemblBacteria.txt | grep -i $i | wc -l); >>  done
>>  ~~~
>>
>


---
# keypoints:
- `for` loops are used for iteration.
- Transferring information to and from virtual and local computers.
- `basename` gets rid of repetitive parts of names.
- Scripts are a collection of commands executed together.
---

# References
- Content adapted from [Data Carpentry materials for redirection](https://datacarpentry.org/shell-genomics/04-redirection/) as well as [Writing Scripts and Working with Data](https://datacarpentry.org/shell-genomics/05-writing-scripts/index.html)
  - Erin Alison Becker, Anita Schürch, Tracy Teal, Sheldon John McKay, Jessica Elizabeth Mizzi, François Michonneau, et al. (2019, June). datacarpentry/shell-genomics: Data Carpentry: Introduction to the shell for genomics data, June 2019 (Version v2019.06.1). Zenodo. http://doi.org/10.5281/zenodo.3260560


- [Table of contents generated with markdown-toc](http://ecotrust-canada.github.io/markdown-toc/)
