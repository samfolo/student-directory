#  current modules

module Formatting
  def capitalize_each
    self.split.map{ |word|
      ["l'", "c'"].include?(word[0..1].downcase) ? (word[0..2].upcase! + word[3..-1].downcase) :
      ["(us)", "(usa)", "usa", "(uk)", "uk"].include?(word.downcase) ? word.upcase : word.capitalize
    }.join(' ')
  end

  private

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
  
  def long_bar
    puts "-" * 94
  end

  def short_bar
    puts "-" * 53
  end

  def back_arrows
      puts "<" * 53
      puts "RESTARTING FORM".center(53)
      puts "<" * 53
      short_bar
  end

  def edit_mode(student)
    puts "+" * 53
    puts "EDITING (#{student.name})".center(53)
    puts "+" * 53
  end

  def restart?
    puts "(type 'R' to restart student entry)"
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

  private

  def validate_age(student, age)
    until (5..130).to_a.include?(age.to_f.round) || age.upcase == 'R'
      short_bar
      puts "Invalid entry"
      puts "Please enter #{ student.name }'s age"
      puts "(Applicants must be at least 5 and 130 years of age)"
      restart?
      print "#{ student.name }'s age: "
      age = gets.chomp
    end
    age
  end

  def validate_gender(student, gender)
    until ["M", "F", "NB", "O"].include?(gender) || gender.upcase == 'R'
      short_bar
      puts "Invalid entry"
      puts "Please choose  #{ student.name }'s gender"
      puts "(M) Male / (F) Female / (NB) Non-Binary / (O) Other / Prefer not to say"
      restart?
      print "#{ student.name }'s gender: "
      gender = gets.chomp.upcase
    end
    gender
  end

  def validate_height(student, height)
    until height.to_i > 0 && height.to_i < 300 || height.upcase == 'R'
      short_bar
      if height.to_i > 0
        puts "Due to the events of last year we no longer accept giants to Villains Academy."
        puts "Please enter #{ student.name }'s height (in centimeters)"
      else
        puts "Invalid entry"
        puts "Please enter #{ student.name }'s height (in centimeters)"
      end
      restart?
      print "#{ student.name }'s height: "
      height = gets.chomp
    end
    height
  end

  def validate_country_of_birth(student, country_of_birth)
    until self.countries.include?(country_of_birth.downcase.to_sym) || country_of_birth.upcase == 'R'
      short_bar
      puts "Invalid entry"
      puts "#{ country_of_birth } is not a country"
      puts "Please enter #{ student.name }'s country of birth"
      restart?
      print "#{ student.name }'s country of birth: "
      country_of_birth = gets.chomp.capitalize_each
    end
    country_of_birth
  end

  def validate_disability_status(student, is_disabled)
    until ["true", "false"].include?(is_disabled) || is_disabled.upcase == 'R'
      short_bar
      puts "Invalid entry"
      puts "Please enter #{ student.name }'s disability status ( true / false )"
      restart?
      print "#{ student.name }'s disability status: "
      is_disabled = gets.chomp.downcase
    end
    is_disabled
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
    puts "Please enter the first name  (press 'return' to exit)"
    short_bar
    print "Name: "

    #  get the first name
    name = gets.chomp.capitalize_each
    name = "" if name == "Abort"

    #  while the name is not empty, repeat this code
    while !name.empty?
      #  create a student
      new_student = Student.new(name)
      new_student.cohort = @month
      
      #  get rest of the data for the student from private methods
      enter_age(new_student)
      enter_gender(new_student)
      enter_height(new_student)
      enter_country_of_birth(new_student)
      enter_disability_status(new_student)
      
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
      goodbye  #  (Formatting mixin)
      puts "There are now #{ @students.count } students in the #{@month} cohort:"
      puts " "
      self.student_profiles
  end

  #  add one or multiple students to cohort (within editor)
  def add_student(*entries)
    entries.each { |entry| 
      (entry.cohort = @month; @students.push(entry)) if entry.is_a?(Student)
    }
  end
  
  #  delete one or more students from cohort (within editor)
  def delete_student(*entries)
    length_before = @students.length

    valid = []

    #  seperates valid entries from invalid entries
    entries.each { |entry| 
      @students.each { |student|
        valid.push(student) if student == entry 
      }
    }

    #  deletes target students
    valid.each { |entry| 
      @students.delete_at(@students.find_index(entry))
    }

    #  displays remaining (invalid) entries
    if valid.length != entries.length
    invalid = entries.reject { |entry| valid.include?(entry) }
    puts "invalid Entries: #{invalid.length}"
    invalid.each { |entry| puts "#{entry.name}: #{entry.student_number}" }
    end
  end

  #  moves one or more students to another valid cohort at cohort level
  def move_student(*students, cohort)
    students.each{ |student|
    if cohort.is_a?(Cohort) && student.is_a?(Student)
      cohort.add_student(student)
      self.delete_student(student)
    elsif !cohort.is_a?(Cohort)
      puts "Invalid target Cohort - operation aborted"
    end
    }
  end

  #  display all profiles of students in Cohort
  def student_profiles
    @students.each.with_index { |student, i| 
        puts "#{ i+1 })"
        student.quick_facts 
    }
    puts " "
  end

  #  display all students in Cohort
  def roster
    print_header
    print_body
    print_footer
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

  private

  #  call a specific data function (currently unused)
  def option(ord, new_student)
    inputs = [
      input_student, enter_age(new_student),
      enter_gender(new_student), enter_height(new_student),
      enter_country_of_birth(new_student), enter_disability_status(new_student)
    ]

    inputs[ord]
  end

  def enter_age(new_student)
    short_bar
    puts "Please enter #{ new_student.name }'s age"
    puts "(Applicants must be at least 5 and at most 130 years of age)"
    restart?
    print "#{ new_student.name }'s age: "
    new_age = gets.chomp
    new_student.age = validate_age(new_student, new_age)
    (back_arrows; input_student) if new_student.age.upcase == 'R'
    new_student.age = new_student.age.to_f.round  # round stray decimals
  end

  def enter_gender(new_student)
    short_bar
    puts "Please enter #{ new_student.name }'s gender ( M / F / NB / O )"
    restart?
    print "#{ new_student.name }'s gender: "
    new_gender = gets.chomp.upcase
    new_student.gender = validate_gender(new_student, new_gender)
    (back_arrows; input_student) if new_student.gender.upcase == 'R'
  end

  def enter_height(new_student)
    short_bar
    puts "Please enter #{ new_student.name }'s height (in centimeters)"
    restart?
    print "#{ new_student.name }'s height: "
    new_height = gets.chomp
    new_student.height = validate_height(new_student, new_height)
    (back_arrows; input_student) if new_student.height.upcase == 'R'
  end

  def enter_country_of_birth(new_student)
    short_bar
    puts "Please enter #{ new_student.name }'s country of birth"
    restart?
    print "#{ new_student.name }'s country of birth: "
    new_country_of_birth = gets.chomp.capitalize_each
    new_student.country_of_birth = validate_country_of_birth(new_student, new_country_of_birth)
    (back_arrows; input_student) if new_student.country_of_birth.upcase == 'R'
  end

  def enter_disability_status(new_student)
    short_bar
    puts "Please enter #{ new_student.name }'s disability status ( true / false )"
    restart?
    print "#{ new_student.name }'s disability status: "
    new_disability_status = gets.chomp.downcase
    new_student.is_disabled = validate_disability_status(new_student, new_disability_status)
    (back_arrows; input_student) if new_student.is_disabled.upcase == 'R'
  end
end

# each student instance
class Student
  include Formatting
  include Validation
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
    puts "Disability Status: #{ @is_disabled }".ljust(50) + "***"
    short_bar
  end

  #  edit data for student
  def edit_student
    #  types of editable data
    data = {"Name" => self.name, "Age" => self.age, "Gender" => self.gender,
            "Height" => self.height, "Country of Birth" => self.country_of_birth,
            "Disability status" => self.is_disabled}

    #  template and options for edit mode
    edit_mode(self)
    puts "What would you like to change about this entry?".center(53)
    puts "   (Enter Number)   ".center(53,"-")
    short_bar
    puts ("1)".ljust(12) + "Name".rjust(18)).center(53)
    puts ("2)".ljust(12) + "Age".rjust(18)).center(53)
    puts ("3)".ljust(12) + "Gender".rjust(18)).center(53)
    puts ("4)".ljust(12) + "Height".rjust(18)).center(53)
    puts ("5)".ljust(12) + "Country of Birth".rjust(18)).center(53)
    puts ("6)".ljust(12) + "Disability Status".rjust(18)).center(53)
    short_bar
    number = gets.chomp

    #  choose an option (or abort)
    until (1..6).to_a.include?(number.to_i) || number.downcase == 'abort'
      puts "Invalid entry"
      puts "Enter new number (or type 'abort' to exit)"
      number = gets.chomp
    end

    return if number.downcase == 'abort'

    #  edit data for choice (using Validation mixin)
    puts "Editing #{self.name}'s #{data.keys[number.to_i - 1].downcase}"
    case number
    when "1"
      print "Actual name: "
      entry = gets.chomp
      data[number] = entry
    when "2"
      print "#{ self.name }'s actual age: "
      new_age = gets.chomp
      self.age = validate_age(self, new_age)
    when "3"
      print "#{ self.name }'s actual gender: "
      new_gender = gets.chomp
      self.gender = validate_gender(self, new_gender)
    when "4"
      print "#{ self.name }'s actual height: "
      new_height = gets.chomp
      self.height = validate_height(self, new_height)
    when "5"
      print "#{ self.name }'s actual country of birth: "
      new_country_of_birth = gets.chomp
      self.country_of_birth = validate_country_of_birth(self, new_country_of_birth)
    when "6"
      print "#{ self.name }'s actual disability status: "
      new_is_disabled = gets.chomp
      self.is_disabled = validate_is_disabled(self, new_is_disabled)
    end
    puts "Done.  #{ self.name}'s modified profile:"
    self.quick_facts
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

#  add some Student objects to "Villains Academy" Cohort object
va_november.add_student(sam, vader, hannibal, nurse_ratched, 
                        michael_corleone, alex_delarge)

#  test methods in CLI
va_november.roster

#va_november.input_student
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

#  testing delete fuction

va_november.delete_student(alex_delarge)
va_december.delete_student(joffrey, terminator)
villains_academy.all_cohorts

#  testing student migration

va_november.move_student(sam, va_december)
villains_academy.all_cohorts

#  testing edit student

sam.edit_student