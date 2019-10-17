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
class Cohort
  def initialize(month)
    @month = month
    @students = []
    @number_of_students = @students.length
  end

  def input_students
    puts "Please enter the names of the students"
    puts "To finish, just hit return twice"
 
    #  get the first name
    name = gets.chomp
    
    #  while the name is not empty, repeat this code
    while !name.empty?
      new_student = Student.new(name)
      @students << new_student
      puts "Please enter #{new_student.name}'s age"
      new_student.age = gets.chomp
      puts "Please enter #{new_student.name}'s gender"
      new_student.gender = gets.chomp
      puts "Please enter #{new_student.name}'s height"
      new_student.height = gets.chomp
      puts "Please enter #{new_student.name}'s country of birth"
      new_student.country_of_birth = gets.chomp
      puts "Please enter #{new_student.name}'s disability status (true/false)"
      new_student.is_disabled = gets.chomp
      puts "Now we have #{ @students.count } students"
      new_student.quick_facts
      #  add the student hash to the array
      puts "Please enter another name"
      puts "To finish, just hit return twice"
      # get another name from the user
      name = gets.chomp
    end
  
    #  return the array of students
    @students
  end

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
end

class Student
  attr_accessor :name, :age, :gender, :height, :country_of_birth, :is_disabled

  def initialize(name, args={})
    options = defaults.merge(args)

    @name = name
    @age = options.fetch(:age)
    @gender = options.fetch(:gender)
    @height = options.fetch(:height)
    @country_of_birth = options.fetch(:country_of_birth)
    @is_disabled = options.fetch(:is_disabled)
    @cohort = :november
    random_id = rand(10000000)
    @student_number = "0" * (7 - random_id.to_s.length) + random_id.to_s
  end

  def defaults
    {
      age: 18,
      gender: "N/A",
      height: "N/A",
      country_of_birth: "N/A",
      is_disabled: false
    }
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


#  nothing happens until we call the methods
Sam = Student.new("Sam", {age: 25, gender: "M", height: 198, country_of_birth: "England,"})
Sam.quick_facts

makers_november = Cohort.new("November")
students = makers_november.input_students

