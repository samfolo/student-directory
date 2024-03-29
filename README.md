# student-directory #

The student directory script allows you to manage the list of students enrolled at Villains Academy

## How to use the directory ##

The directory runs entirely in the command line and uses no external libraries.
To access it, simply enter
    
    ruby directory.rb

<img src="README images/home menu student dir.png"/>

## Features ##

The menu provides the user a list of features to help them manipulate the directory.\
The directory allows you to:

### Display all students in the academy
   - View a table with all the students in the academy, their unique IDs and cohort month
   - The seven-digit ID numbers are created and validated using Luhn's algorithm before assignment
   <img src="README images/option 1.png"/>
   
-----------------------------------

### View all cohorts in the academy
   - View a similar table, only split into smaller tables with cohort headings
   <img src="README images/option 2.png"/>
   
-----------------------------------

### View an individual cohort
   - View one of the cohorts as a standalone table, no other distractions
   
-----------------------------------

### Display student profiles at cohort level
   - Access information about the individual students, such as their age, country of birth, gender, height and disability status
   - The profiles of each cohort are seperated by a blue heading
   <img src="README images/option 4.png"/>
   
-----------------------------------

### Display student profiles at a whole-school level
   - View a list of profiles for all students, regardless of cohort
   
-----------------------------------

### Create and add a student to a specific cohort
   - You will be asked which cohort you would like to add a student to, after which you can fill out a form, entering in the details for any student you wish to create
   - When entering a country, suggestions will be made for any misspelt country names
   - Each cohort has a capacity of 30 students, so this operation will be denied if a cohort is full
   <img src="README images/option 6.png"/>
   
-----------------------------------

### Delete a student from the directory
   - If you wish to remove a student, you can pass in their ID and they will be removed from the directory
   <img src="README images/option 7.png"/>
   
-----------------------------------

### Move a student from one cohort to another
   - If you wish to move a student from one cohort from the other:
     - You will be asked for their ID and the student will be located
     - You will then be asked for a target cohort (a list which excludes the student's current cohort)
   - If a cohort is full, migration will not be possible
   <img src="README images/option 8.png"/>
     
-----------------------------------

### Filter students at cohort level (by initial or by name length)
   - Search through the a specific cohort, filtering either by the initial of their first name or the length of their whole name
   - The filter method excludes prefixes (e.g. 'Mrs', 'Mx', 'Master', 'Darth'..)
   <img src="README images/option 9.png"/>
   
-----------------------------------

### Filter students at whole-school level (by initial or by name length)
   - Filter through the entire directory, again either by name or by maximum length (excluding prefixes)
   
-----------------------------------

### "Edit mode": edit one or more attributes for a student
   - Edit mode opens up a profile (accessed by passing in an ID), then allows the user to edit one attribute that can be found on their student profile (including name, excluding ID)
   - Edit mode will continue to prompt for more changes until the user returns to the menu
   <img src="README images/option 11.png"/>
   
-----------------------------------

### Create a cohort and add it to the academy
   - The directory allows the user to create a new cohort by typing in the name of a valid calendar month
   - It is not possible to create a cohort with a month that is already in use
   <img src="README images/option 12.png"/>
   
-----------------------------------

### Remove a cohort from the academy
   - The directory also allows users to remove an existing cohort
   - When a cohort with students is deleted, its students are distributed evenly across all other existing cohorts
     (until any such cohort reaches capacity, at which point the directory will remove it from rotation)
   - Just before deletion, the user is asked to type 'confirm' to ensure their decision is being made consciously
   - The user cannot delete the last remaining cohort – the students will have nowhere else to go (and under such circumstances we have been advised they are well within their rights to sue)
   <img src="README images/option 13.png"/>
   
-----------------------------------
   
### Exit program and automatically save your changes to a .csv file
   - The directory saves its data as a CSV file – no need to actively save anything as all your changes are saved upon exit
   - For more drastic changes (i.e. moving a student, deleting a student and removing a cohort) you are prompted at least once to confirm your choice

-----------------------------------

## Try it out ##

There is a fresh csv file loaded with students to try out for yourself; load the file by appending it as an argument in the command line:


    ruby directory.rb fresh_session.csv
    
    
