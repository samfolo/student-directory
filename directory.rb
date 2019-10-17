#  let's put all students into an array
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

#  current methods
def print_header
  puts "The students of Villains Academy"
  puts "-------------"
end

def print(students)
  #students.each.with_index { |student, i| 
  #  puts "#{ i+1 } #{ student[:name] } (#{ student[:cohort] } cohort)"
  #}
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

def filter_first_initial(initial, students)
  prefixes = ["The", "Mr", "Master", "Mrs", "Ms", "Miss", "Mx", "Dr.", "Sir", 
              "Madam", "Lt.", "Sgt.", "..."]
  
  split_names = [] #  splits each name into a sub-array of words
students.each { |student| split_names << student[:name].split(' ') }

  removed_prefixes = split_names.map { |student|
    student.shift if student.length > 1 && prefixes.include?(student[0])
    student.join(' ')
  } #  takes off first word in name if it's in the list of prefixes (& to_s)

  #  filters natural names by first initial, then picks corresponding entry from original array
  filtered_list = []
  removed_prefixes.each.with_index { |student, i| 
    filtered_list << students[i][:name] if student.chr == initial 
  }

  puts "Students filtered by initial '#{initial}'"
  puts "-------------"
  puts filtered_list
  puts "-------------"
  puts "#{filtered_list.count} students under '#{initial}'"
end

#  nothing happens until we call the methods
students = input_students
print_header
print(students)
print_footer(students)
puts " "
filter_first_initial('S', students)