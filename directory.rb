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
  attr_reader :month, :students, :number_of_students

  def initialize(month)
    @month = month
    @students = []
    @number_of_students = @students.length
  end

  def input_students
    puts "Please enter the first name -- (type 'abort' to exit)"
    puts "-" * 53
    #  get the first name
    name = gets.chomp
    return if name == "abort"
    #  while the name is not empty, repeat this code
    while !name.empty?
      new_student = Student.new(name)
      
      puts "Please enter #{ new_student.name }'s age"
      new_student.age = gets.chomp
      puts "Please enter #{ new_student.name }'s gender"
      new_student.gender = gets.chomp
      puts "Please enter #{ new_student.name }'s height"
      new_student.height = gets.chomp
      puts "Please enter #{ new_student.name }'s country of birth"
      new_student.country_of_birth = gets.chomp
      puts "Please enter #{ new_student.name }'s disability status (true/false)"
      new_student.is_disabled = gets.chomp
      
      #  add the student hash to the array
      @students << new_student
      puts " "
      puts " "
      puts "#{ @students.count } students added.  Last entry:".center(51)
      new_student.quick_facts
      puts "Please enter another name -- (press 'return' to exit)"
      puts "-" * 53
      # get another name from the user
      name = gets.chomp
    end
      puts "-------------".center(50)
      puts "Goodbye".center(50)
      puts "-------------".center(50)
      puts " ".center(50)
      puts " ".center(50)
      puts "You entered #{ @students.count } students:"
      puts " "
      self.student_profiles
  end

  def add_student(*entries)
    entries.each{ |entry| 
      @students.push(entry) if entry.is_a?(Student)
    }
    
  end
  
  def student_profiles
    @students.each.with_index { |student, i| 
        puts "#{ i+1 })"
        student.quick_facts 
    }
    puts " "
  end

  def print_header
    puts "-" * 94
    print "|" * 23, " " * 8, "The Students of Villains Academy", " " * 8, "|" * 23, "\n"
    puts "-" * 94
    puts "-" * 94
  end
  
  def print_body
    @students.each.with_index { |student, i| 
      puts "#{ (i + 1).to_s.ljust(12) }#{ student.name.ljust(40) }" + "ID: #{student.student_number}".ljust(25) + "(#{ student.cohort } cohort)"
    }
  end
  
  def print_footer
    puts "-" * 94
    puts @students.count > 1 ?
    "Overall, we have #{ @students.count } great students" : 
    "We only have #{ @students.count } student."
    puts " "
    puts " "
  end

  def roster
    print_header
    print_body
    print_footer
  end

  def no_prefix
    prefixes = ["The", "Mr", "Master", "Mrs", "Ms", "Miss", "Mx", "Dr.", "Sir", 
                "Madam", "Lt.", "Sgt.", "..."]
    
    #  splits each name into a sub-array of words
    split_names = [] 
    @students.each { |student| split_names << student.name.split(' ') }
  
    #  takes off first word in name if it's in the list of prefixes (& to_s)
    removed_prefixes = split_names.map { |student|
      student.shift if student.length > 1 && prefixes.include?(student[0])
      student.join(' ')
    }
  
    removed_prefixes
  end

  def by_initial(initial)
    natural_names = no_prefix
  
    #  filters natural names by first initial, then picks corresponding entry from original array
    filtered_list = []
    natural_names.each.with_index { |student, i| 
      filtered_list << @students[i].name if student.chr == initial 
    }
  
    # putses result to console
    puts "Students filtered by initial '#{ initial }'"
    puts "-" * 53
    puts filtered_list
    puts "-" * 53
    puts "Total Students: #{ filtered_list.count }"
    puts " "
    puts " "
  end
  
  def by_length(length)
    natural_names = no_prefix
  
    #  filters out names over a certain number of characters, then picks corresponding entry from original array
    filtered_list = []
    natural_names.each.with_index { |student, i| 
      filtered_list << @students[i].name if student.length <= length 
    }
  
    # putses result to console
    puts "Students filed under names with no more than:"
    puts "#{ length } characters"
    puts "-" * 53
    puts filtered_list
    puts "-" * 53
    puts "Total Students: #{ filtered_list.count }"
    puts " "
    puts " "
  end
end

class Student
  attr_accessor :name, :age, :gender, :height, :country_of_birth,
                :is_disabled, :cohort, :student_number

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
    puts "-" * 53
    puts "Student #{ @student_number } (#{ @cohort.capitalize })"
    puts "Name: #{ @name }"
    puts "Age: #{ @age }"
    puts "Gender: #{ @gender }"
    puts "Height: #{ @height }"
    puts "Country of Birth: #{ @country_of_birth }"
    puts "Disabled Status: #{ @is_disabled }"
    puts "-" * 53
  end
end


villains_november = Cohort.new("November")

# converted test entries to Student objects
sam = Student.new("Sam", {age: 25, gender: "M", height: 198, country_of_birth: "England,"})
vader = Student.new("Darth Vader")
hannibal = Student.new("Dr. Hannibal Lecter")
nurse_ratched = Student.new("Nurse Ratched")
michael_corleone = Student.new("Michael Corleone")
alex_delarge = Student.new("Alex DeLarge")
wicked_witch = Student.new("The Wicked Witch of the West")
terminator = Student.new("Terminator")
freddy_krueger = Student.new("Freddy Krueger")
joker = Student.new("The Joker")
joffrey = Student.new("Joffrey Baratheon")
norman_bates = Student.new("Norman Bates")

# add all Student objects to Villains Academy Cohort object
villains_november.add_student(sam, vader, hannibal, nurse_ratched, 
                              michael_corleone, alex_delarge, wicked_witch,
                              terminator, freddy_krueger, joker, joffrey,
                              norman_bates)
villains_november.roster

students = villains_november.input_students
puts " "
villains_november.roster
puts " "
villains_november.by_initial("W")
puts " "
villains_november.by_length(10)