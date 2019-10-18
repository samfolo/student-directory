#  current modules

module Formatting
  def capitalize_each
    self.split.map{ |word|
      ["l'", "c'"].include?(word[0..1].downcase) ? (word[0..2].upcase! + word[3..-1].downcase) :
      ["(us)", "(usa)", "usa", "(uk)", "uk"].include?(word.downcase) ? word.upcase : word.capitalize
    }.join(' ')
  end

  private 
  
  def long_bar
    puts "-" * 94
  end

  def short_bar
    puts "-" * 53
  end

  def goodbye
    puts "-------------".center(51)
    puts "Goodbye".center(51)
    puts "-------------".center(51)
    puts " ".center(50)
    puts " ".center(50)
  end
end

module Validation
  def countries
    #  avoiding external libraries for this exercise
    countries = ["Afghanistan", "Albania", "Algeria", "Andorra", "Angola", "Anguilla", "Antigua and Barbuda", "Argentina", "Armenia", "Aruba", "Australia", "Austria", "Azerbaijan", "Bahamas",
    "Bahrain", "Bangladesh", "Barbados", "Belarus", "Belgium", "Belize", "Benin", "Bermuda", "Bhutan", "Bolivia", "Bosnia and Herzegovina", "Botswana", "Brazil", "British Virgin Islands",
    "Brunei", "Bulgaria", "Burkina Faso", "Burundi", "Cambodia", "Cameroon", "Canada", "Cape Verde", "Cayman Islands", "Chad", "Chile", "China", "Colombia", "Congo", "Cook Islands", "Costa Rica",
    "Cote D Ivoire", "Croatia", "Cruise Ship", "Cuba", "Cyprus", "Czech Republic", "Denmark", "Djibouti", "Dominica", "Dominican Republic", "Ecuador", "Egypt", "El Salvador", "Equatorial Guinea",
    "England", "Estonia", "Ethiopia", "Falkland Islands", "Faroe Islands", "Fiji", "Finland", "France", "French Polynesia", "French West Indies", "Gabon", "Gambia", "Georgia", "Germany", "Ghana",
    "Gibraltar", "Greece", "Greenland", "Grenada", "Guam", "Guatemala", "Guernsey", "Guinea", "Guinea Bissau", "Guyana", "Haiti", "Honduras", "Hong Kong", "Hungary", "Iceland", "India",
    "Indonesia", "Iran", "Iraq", "Ireland", "Isle of Man", "Israel", "Italy", "Jamaica", "Japan", "Jersey", "Jordan", "Kazakhstan", "Kenya", "Kuwait", "Kyrgyz Republic", "Laos", "Latvia",
    "Lebanon", "Lesotho", "Liberia", "Libya", "Liechtenstein", "Lithuania", "Luxembourg", "Macau", "Macedonia", "Madagascar", "Malawi", "Malaysia", "Maldives", "Mali", "Malta", "Mauritania",
    "Mauritius", "Mexico", "Moldova", "Monaco", "Mongolia", "Montenegro", "Montserrat", "Morocco", "Mozambique", "Namibia", "Nepal", "Netherlands", "Netherlands Antilles", "New Caledonia",
    "New Zealand", "Nicaragua", "Niger", "Nigeria", "Norway", "Oman", "Pakistan", "Palestine", "Panama", "Papua New Guinea", "Paraguay", "Peru", "Philippines", "Poland", "Portugal",
    "Puerto Rico", "Qatar", "Reunion", "Romania", "Russia", "Rwanda", "Saint Pierre and Miquelon", "Samoa", "San Marino", "Satellite", "Saudi Arabia", "Scotland", "Senegal", "Serbia",
    "Seychelles", "Sierra Leone", "Singapore", "Slovakia", "Slovenia", "South Africa", "South Korea", "Spain", "Sri Lanka", "St Kitts and Nevis", "St Lucia", "St Vincent", "St. Lucia",
    "Sudan", "Suriname", "Swaziland", "Sweden", "Switzerland", "Syria", "Taiwan", "Tajikistan", "Tanzania", "Thailand", "Timor L'Este", "Togo", "Tonga", "Trinidad and Tobago", "Tunisia",
    "Turkey", "Turkmenistan", "Turks and Caicos", "Uganda", "Ukraine", "United Arab Emirates", "United Kingdom", "United States", "United States Minor Outlying Islands", "Uruguay",
    "Uzbekistan", "Venezuela", "Vietnam", "Virgin Islands (US)", "Wales", "Yemen", "Zambia", "Zimbabwe"].map { |country| country.downcase.to_sym }
  end
end
#  current classes

class String
  include Formatting
end

#  each academy instance
class Academy
  include Formatting
  attr_reader :name, :cohorts

  def initialize(name)
    @name = name
    @cohorts = []
  end

  def add_cohort(*entries)
    entries.each { |entry| 
      (entry.academy = @name; @cohorts.push(entry)) if entry.is_a?(Cohort)
    }
  end

  def total_students
    total = 0
    @cohorts.each { |cohort| total += cohort.students.length }
    total
  end

  def all_cohorts
    print_header
    print_body
    print_footer
  end

  private

  #  header of table
  def print_header
    long_bar
    print "|" * 23, "The Students of Villains Academy".center(48), "|" * 23, "\n"
    print "|" * 23, "==== All Cohorts ====".center(48), "|" * 23, "\n"
    long_bar
  end

  #  body of table
  def print_body
    @cohorts.each { |cohort| 
      long_bar
      print "|" * 23, "-- #{ cohort.month } Cohort --".center(48), "|" * 23, "\n"
      long_bar
      cohort.print_body
      long_bar
    }
  end

  #  footer of table
  def print_footer
    long_bar
    puts total_students != 1 ?
    "Overall, the Academy has #{ total_students } great students over #{ @cohorts.count } cohorts" : 
    "The Academy only has #{ total_students } student."

    puts " "
    puts " "
  end
end

# each cohort instance
class Cohort
  include Formatting
  include Validation
  attr_accessor :academy, :month, :students

  def initialize(month)
    @academy
    @month = month
    @students = []
  end

  #  add one or multiple students from CLI
  def input_student
    puts "Entering new names for the #{ @month } cohort"
    puts "Please enter the first name -- (type 'abort' to exit)"
    short_bar

    #  get the first name
    name = gets.chomp.capitalize_each
    name = "" if name == "Abort"

    #  while the name is not empty, repeat this code
    while !name.empty?
      #  create a student
      new_student = Student.new(name)
      new_student.cohort = @month
      
      #  get rest of the data for the student
      puts "Please enter #{ new_student.name }'s age"
      puts "(Applicants must be at least 5 and at most 130 years of age)"
      new_student.age = gets.chomp.to_i
      until (5..130).to_a.include?(new_student.age.to_i)
        puts "Invalid entry"
        puts "Please enter #{ new_student.name }'s age"
        puts "(Applicants must be at least 5 and 130 years of age)"
        new_student.age = gets.chomp.to_i
      end
      puts "Please enter #{ new_student.name }'s gender ( M / F / NB / O )"
      new_student.gender = gets.chomp.upcase
      until ["M", "F", "NB", "O"].include?(new_student.gender)
        puts "Invalid entry"
        puts "Please choose  #{ new_student.name }'s gender"
        puts "(M) Male / (F) Female / (NB) Non-Binary / (O) Other / Prefer not to say"
        new_student.gender = gets.chomp.upcase
      end
      puts "Please enter #{ new_student.name }'s height (in centimeters)"
      new_student.height = gets.chomp
      until new_student.height.to_i > 0 && new_student.height.to_i < 300
        if new_student.height.to_i > 0
          puts "Due to the events of last year we no longer accept giants to Villains Academy."
          puts "Please enter #{ new_student.name }'s height (in centimeters)"
        else
          puts "Invalid entry"
          puts "Please enter #{ new_student.name }'s height (in centimeters)"
        end
        new_student.height = gets.chomp
      end
      puts "Please enter #{ new_student.name }'s country of birth"
      new_student.country_of_birth = gets.chomp.capitalize_each
      until self.countries.include?(new_student.country_of_birth.downcase.to_sym)
        puts "Invalid entry #{gets.chomp.capitalize_each}"
        puts "Please enter #{ new_student.name }'s country of birth"
        new_student.country_of_birth = gets.chomp.capitalize_each
      end
      puts "Please enter #{ new_student.name }'s disability status ( true / false )"
      new_student.is_disabled = gets.chomp
      until ["true", "false"].include?(new_student.is_disabled)
        puts "Invalid entry"
        puts "Please enter #{ new_student.name }'s disability status ( true / false )"
        new_student.is_disabled = gets.chomp
      end
      
      #  add the student hash to the array
      @students << new_student
      puts " "
      puts " "
      puts "Student added. New total: #{ @students.count }.  Last entry:".center(53)
      new_student.quick_facts
      puts "Please enter another name -- (press 'return' to exit)"
      short_bar

      # get another name from the user
      name = gets.chomp
    end

      #  format results upon completion
      goodbye
      puts "There are now #{ @students.count } students in the #{@month} cohort:"
      puts " "
      self.student_profiles
  end

  #  add one or multiple students to cohort within editor
  def add_student(*entries)
    entries.each { |entry| 
      (entry.cohort = @month; @students.push(entry)) if entry.is_a?(Student)
    }
  end
  
  def student_profiles
    @students.each.with_index { |student, i| 
        puts "#{ i+1 })"
        student.quick_facts 
    }
    puts " "
  end

  def roster
    print_header
    print_body
    print_footer
  end

  def no_prefix
    prefixes = ["The", "Mr", "Master", "Mrs", "Ms", "Miss", "Mx", "Dr.", "Nurse",
                "Sir", "Madam", "Lt.", "Sgt.", "Darth", "..."]
    
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
  
    #  filters natural names by first initial, then picks corresponding 
    #  entry from original array
    filtered_list = []
    natural_names.each.with_index { |student, i| 
      filtered_list << @students[i].name if student.chr == initial 
    }
  
    # putses result to console
    puts "Students filtered by initial '#{ initial }' (excluding prefixes)"
    short_bar
    puts filtered_list
    short_bar
    puts "Total Students: #{ filtered_list.count }"
    puts " "
    puts " "
  end
  
  def by_length(length)
    natural_names = no_prefix
  
    #  filters out names over a certain number of characters, 
    #  then picks corresponding entry from original array
    filtered_list = []
    natural_names.each.with_index { |student, i| 
      filtered_list << @students[i].name if student.length <= length 
    }
  
    # putses result to console
    puts "Students filed under names with no more than:"
    puts "#{ length } characters (excluding prefixes)"
    short_bar
    puts filtered_list
    short_bar
    puts "Total Students: #{ filtered_list.count }"
    puts " "
    puts " "
  end

  # would use private - but need to acess parts of table in Academy object

  #  header of table
  def print_header
    long_bar
    print "|" * 23, "The Students of Villains Academy".center(48), "|" * 23, "\n"
    print "|" * 23, "-- #{ @month } Cohort --".center(48), "|" * 23, "\n"
    long_bar
    long_bar
  end

  #  body of table
  def print_body
    @students.each.with_index { |student, i| 
      puts "#{ (i + 1).to_s.ljust(12) }#{ student.name.ljust(40) }" + 
      "ID: #{ student.student_number }".ljust(24) +
      "(#{ student.cohort } cohort)".rjust(18)
    }
  end

  #  footer of table
  def print_footer
    long_bar
    puts @students.count != 1 ?
    "Overall, this cohort has #{ @students.count } great students" : 
    "This cohort only has #{ @students.count } student."
    puts " "
    puts " "
  end
end

# each individual member as a class
class Student
  include Formatting
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
    @cohort
    random_id = rand(10000000)
    @student_number = "0" * (7 - random_id.to_s.length) + random_id.to_s
  end

  #  default assignments for Student
  def defaults
    {
      age: 18,
      gender: "N/A",
      height: "N/A",
      country_of_birth: "N/A",
      is_disabled: false
    }
  end

  #  display all stats for a Student
  def quick_facts
    short_bar
    puts "Student #{ @student_number } (#{ @cohort })".ljust(50) + "***"
    puts "Name: #{ @name }".ljust(50) + "***"
    puts "Age: #{ @age }".ljust(50) + "***"
    puts "Gender: #{ @gender }".ljust(50) + "***"
    puts "Height: #{ @height }".ljust(50) + "***"
    puts "Country of Birth: #{ @country_of_birth }".ljust(50) + "***"
    puts "Disabled Status: #{ @is_disabled }".ljust(50) + "***"
    short_bar
  end
end

#  converted test entries to Student objects
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

#  create "Villains Academy" Academy object
villains_academy = Academy.new("Villains Academy")

#  create "Villains Academy" November Cohort object
va_november = Cohort.new("November")

#  add all Student objects to "Villains Academy" Cohort object
va_november.add_student(sam, vader, hannibal, nurse_ratched, 
                        michael_corleone, alex_delarge)

#  test methods in CLI
va_november.roster

va_november.input_student
puts " "
va_november.roster
puts " "
va_november.by_initial("W")
puts " "
va_november.by_length(10)

#  create "Villains Academy" December Cohort object
va_december = Cohort.new("December")

va_december.add_student(wicked_witch, terminator, freddy_krueger, 
                        joker, joffrey, norman_bates)

va_december.roster

va_december.input_student
puts " "
va_december.roster
puts " "
va_december.by_initial("J")
puts " "
va_december.by_length(7)

villains_academy.add_cohort(va_november, va_december)
villains_academy.all_cohorts