=begin
students = [
  { name: "Dr. Hannibal Lecter", cohort: :november },
  { name: "Darth Vader", cohort: :november },
  { name: "Nurse Ratched", cohort: :november },
  { name: "Michael Corleone", cohort: :november },
  { name: "Alex DeLarge", cohort: :november },
  { name: "The Wicked Witch of the West", cohort: :november },
  { name: "Terminator", cohort: :november },
  { name: "Freddy Krueger", cohort: :november },
  { name: "The Joker", cohort: :november },
  { name: "Joffrey Baratheon", cohort: :november },
  { name: "Norman Bates", cohort: :november }
]
=end

#  current classes

class Student
  def initialize(name, age, gender, height_in_cm, country_of_birth, is_disabled=false)
    @name = name
    @age = age
    genders = ["M", "F", "NB", "O"] #  Male, Female, Non-Binary, Other
    @gender = gender if genders.include?(gender)
    @height = height_in_cm
    @country_of_birth = country_of_birth
    @is_disabled = is_disabled
    @cohort = :november
    @student_number = rand(10000000)
  end

  def quick_facts
    puts "Student #{@student_number} (#{@cohort.capitalize})"
    puts "Name: #{@name}"
    puts "Age: #{@age}"
    puts "Gender: #{@gender}"
    puts "Height: #{@height}"
    puts "Country of Birth: #{@country_of_birth}"
    puts "Disabled Status: #{@is_disabled}"
  end
end

#  current methods

def print_header
  puts "The students of Villains Academy"
  puts "-------------"
end

def print(students)
  #  'each()' version
  students.each.with_index { |student, i| 
    puts "#{ i + 1 } #{ student[:name] } (#{ student[:cohort] } cohort)"
  }
end

def print_footer(students)
  puts "Overall, we have #{ students.count } great students"
end

def input_students
  puts "Please enter the names of the students"
  puts "To finish, just hit return twice"
  #  create an empty array
  students = []
  #  get the first name
  name = gets.chomp
  #  while the name is not empty, repeat this code
  while !name.empty?
    
    students << { name: name, cohort: :november }
    puts "Now we have #{ students.count } students"
    #  add the student hash to the array
    puts "Please enter another name"
    puts "To finish, just hit return twice"
    # get another name from the user
    name = gets.chomp
  end

  #  return the array of students
  students
end

def no_prefix(students)
  prefixes = ["The", "Mr", "Master", "Mrs", "Ms", "Miss", "Mx", "Dr.", "Sir", 
              "Madam", "Lt.", "Sgt.", "..."]
  
  #  splits each name into a sub-array of words
  split_names = [] 
  students.each { |student| split_names << student[:name].split(' ') }

  #  takes off first word in name if it's in the list of prefixes (& to_s)
  removed_prefixes = split_names.map { |student|
    student.shift if student.length > 1 && prefixes.include?(student[0])
    student.join(' ')
  }

  removed_prefixes
end

def by_initial(initial, students)
  natural_names = no_prefix(students)

  #  filters natural names by first initial, then picks corresponding entry from original array
  filtered_list = []
  natural_names.each.with_index { |student, i| 
    filtered_list << students[i][:name] if student.chr == initial 
  }

  # putses result to console
  puts "Students filtered by initial '#{initial}'"
  puts "-------------"
  puts filtered_list
  puts "Total Students: #{filtered_list.count}"
end

def by_length(length, students)
  natural_names = no_prefix(students)

  #  filters names of under a certain length
  filtered_list = []
  natural_names.each.with_index { |student, i| 
    filtered_list << students[i][:name] if student.length <= length 
  }

  # putses result to console
  puts "Students filed under names with no more than #{length} characters"
  puts "-------------"
  puts filtered_list
  puts "Total Students: #{filtered_list.count}"
end

#  nothing happens until we call the methods
Sam = Student.new("Sam", 25, "M", "198", "England")
Sam.quick_facts

students = input_students
print_header
print(students)
print_footer(students)
puts " "
by_initial('S', students)
puts " "
by_length(12, students)