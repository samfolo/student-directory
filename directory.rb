#  current modules

module Formatting
  def capitalize_each
    self.split.map{ |word|
      #  deals with words like "l'este" and "d'arte"
      ["l'", "c'", "d'"].include?(word[0..1].downcase) ? (word[0..2].upcase! + word[3..-1].downcase) :
      #  deals with country abbreviations
      ["(us)", "(usa)", "usa", "(uk)", "uk"].include?(word.downcase) ? word.upcase : word.capitalize
    }.join(' ')
  end

  #  colors for CLI
  def colorize(color); "\e[#{color}m#{self}\e[0m"; end
  def red; colorize(31); end
  def green; colorize(32); end
  def yellow; colorize(33); end
  def blue; colorize(36); end
  def darkblue; colorize(34); end
  def grey; colorize(30); end
  def bold; colorize(1); end
  def italic; colorize(3); end  
  def random_color; colorize(rand(7) + 30); end  #  random from 30..36
                                                 #  (maybe useful?)
  
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
    "-" * 94
  end

  def short_bar
    "-" * 53
  end

  def back_arrows
      puts short_bar
      puts ("/" * 53).bold.yellow
      puts "ABORTING STUDENT ENTRY".center(53).yellow
      puts ("/" * 53).bold.yellow
      puts short_bar
  end

  def edit_mode(student)
    puts ("+" * 53).bold.green
    puts "EDITING (#{student.name})".center(53).green
    puts ("+" * 53).bold.green
  end

  def exit_edit_mode
    puts ("+" * 53).bold.green
    puts "EXITING EDIT MODE".center(53).green
    puts ("+" * 53).bold.green
  end

  def abort?
    puts "(type 'R' to abort)"
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
  def actual_countries
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

  def actual_months
    months = ["January", "February", "March", "April", "May", "June",
    "July", "August", "September", "October", "November", "December"].map { |month| month.downcase.to_sym }
  end

  private

  #  use Luhn's algorithm to validate 7-digit student IDs
  def luhns_seven(id)
    #  splits ID into digit array
    array = id.split('').map(&:to_i)
    #  doubles every other number in reverse except last (check digit)
    double_every_other = array.reverse[0..-2].map.with_index { |digit, i| i % 2 == 1 ? digit * 2 : digit } << array[0]
    #  turns all numbers > 9 into single digits by subtracting 9
    single_digits_only = double_every_other.reverse.map { |digit| digit > 9 ? digit - 9 : digit }
    #  returns whether ID is 'valid' (divisible by 10)
    return single_digits_only.reduce(:+) % 10 == 0
  end

  def validate_age(student, age)
    until (5..130).to_a.include?(age.to_f.round) || ['R', 'r'].include?(age)
      puts "* INVALID *".bold.red
      puts short_bar
      puts "Invalid entry"
      puts ("Please enter #{ student.name }'s age").blue
      puts "(Applicants must be at least 5 and at most 130 years of age)".blue
      abort?
      print student.age == "N/A" ? "#{ student.name }'s age".yellow + ": " : 
                                   "#{ student.name }'s actual age".yellow + ": "
      age = gets.chomp
    end
    age
  end

  def validate_gender(student, gender)
    until (/[a-zA-Z]/.match(gender) && ["M", "F", "NB", "O"].include?(gender.upcase)) || ["R", "r"].include?(gender)
      puts "* INVALID *".bold.red
      puts short_bar
      puts "Invalid entry"
      puts ("Please choose #{ student.name }'s gender").blue
      puts "(".blue + "M" + ") Male / (".blue + "F" + ") Female / (".blue + "NB" + ") Non-Binary / (".blue + "O" + ") Other / Prefer not to say".blue
      abort?
      print student.gender == "N/A" ? "#{ student.name }'s gender".yellow + ": " : 
                                      "#{ student.name }'s actual gender".yellow + ": "
      gender = /[a-zA-Z]/.match(gender) ? gets.chomp : gets.chomp.upcase!
    end
    gender
  end

  def validate_height(student, height)
    until height.to_i >= 50 && height.to_i < 300 || ['R', 'r'].include?(height)
      puts "* INVALID *".bold.red
      puts short_bar
      if height.to_i >= 300
        puts "Invalid entry"
        puts "Due to the events of last year we no longer accept giants to Villains Academy.".blue
        puts ("Please enter #{ student.name }'s height (").blue + "in centimeters" + ")".blue
      elsif height.to_i < 50 && height.to_i != 0  #  because non-digits.to_i return 0
        puts "Invalid entry"
        puts "Student is too short to be a villain.  Minimum height requirement is 50cm.".blue
        puts ("Please enter #{ student.name }'s height (").blue + "in centimeters" + ")".blue
      else
        puts "Invalid entry"
        puts ("Please enter #{ student.name }'s height (").blue + "in centimeters" + ")".blue
      end
      abort?
      print student.height == "N/A" ? "#{ student.name }'s height".yellow + ": " : 
                                      "#{ student.name }'s actual height".yellow + ": "
      height = gets.chomp
    end
    height
  end

  def validate_country_of_birth(student, country_of_birth)
    until self.actual_countries.include?(country_of_birth.downcase.to_sym) || ['R', 'r'].include?(country_of_birth)
      puts "* INVALID *".bold.red
      puts short_bar
      puts "Invalid entry"
      puts "#{ country_of_birth } is not a country"
      did_you_mean?(country_of_birth)
      puts ("Please enter #{ student.name }'s country of birth").blue
      abort?
      print student.country_of_birth == "N/A" ? "#{ student.name }'s country of birth".yellow + ": " : 
                                                "#{ student.name }'s actual country of birth".yellow + ": "
      country_of_birth = gets.chomp.capitalize_each
    end
    country_of_birth
  end

  def validate_disability_status(student, disability_status)
    until ["true", "false"].include?(disability_status) || ['R', 'r'].include?(disability_status)
      puts "* INVALID *".bold.red
      puts short_bar
      puts "Invalid entry"
      puts ("Please enter #{ student.name }'s disability status (").blue + " true " + "/".blue + " false " + ")".blue
      abort?
      print student.is_disabled == "N/A" ? ("#{ student.name }'s disability status").yellow + ": " : 
                                            "#{ student.name }'s actual disability status".yellow + ": "
      disability_status = gets.chomp.downcase
    end
    disability_status
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

  def all_students
    print_header
    i = 0
    #  prints all students from all cohorts in one 
    @cohorts.each { |cohort|
      cohort.students.each {|student|
      puts "#{ (i + 1).to_s.ljust(12) }#{ student.name.ljust(40) }" + 
      "ID: #{ student.student_id }".ljust(24) +
      "(#{ student.cohort } cohort)".rjust(18)
      i += 1
      }
    }
    print_footer
  end

  private

  #  header of table
  def print_header
    puts long_bar.blue
    print ("|" * 23).blue, "The Students of Villains Academy".center(48), ("|" * 23).blue, "\n"
    print ("|" * 23).blue, "==== All Cohorts ====".center(48), ("|" * 23).blue, "\n"
    puts long_bar.blue
  end

  #  body of table
  def print_body
    @cohorts.each { |cohort| 
      puts long_bar.darkblue
      print ("|" * 23).darkblue, "-- #{ cohort.month } Cohort --".center(48), ("|" * 23).darkblue, "\n"
      puts long_bar.darkblue
      cohort.print_body
      puts long_bar.darkblue
    }
  end

  #  footer of table
  def print_footer
    puts long_bar.blue
    puts total_students != 1 ?
    "Overall, the Academy has ".blue + "#{ total_students }".bold.blue + 
    " great students over ".blue + "#{ @cohorts.count }".bold.blue + " cohorts".blue : 
    "The Academy only has ".blue + "#{ total_students }".bold.blue + " student.".blue

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
    if actual_months.include?(month.downcase.to_sym)
      @month = month.capitalize
    else
      raise "Error: #{month} is not a month."
    end
    @students = []
  end

  #  add one or multiple students from CLI
  def input_student
    puts "Entering a name for the #{ @month } cohort".bold.blue
    puts "Please enter a new name -- (".blue + "press 'return' to exit" + ")".blue
    puts short_bar
    print "Name".yellow + ": "
    #  get the first name
    name = gets.chomp.capitalize_each
    #  gets rest of data from private method 'form' if name is entered, else aborts
    form(name)
    #  format results upon completion
    goodbye  #  Formatting mixin
    puts "There are now ".blue + "#{ @students.count }".bold.blue + " students in the #{@month} cohort:".blue
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
    puts "invalid Entries: #{invalid.length}".bold.blue
    invalid.each { |entry| puts "#{entry.name}: #{entry.student_id}" }
    end
  end

  #  moves one or more students to another valid cohort at cohort level
  def move_student(*students, cohort)
    students.each{ |student|
    if cohort.is_a?(Cohort) && student.is_a?(Student)
      cohort.add_student(student)
      self.delete_student(student)
    elsif !cohort.is_a?(Cohort)
      raise "Invalid target Cohort - operation aborted"
    end
    }
  end

  #  display all profiles of students in Cohort
  def student_profiles
    @students.each.with_index { |student, i| 
        puts "#{ i+1 })".bold.yellow
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
    natural_names = no_prefix  #  Formatting mixin
  
    #  filters natural names by first initial, then picks corresponding 
    #  entry from original array
    filtered_list = []
    natural_names.each.with_index { |student, i| 
      filtered_list << @students[i].name if student.chr == initial 
    }
  
    # putses result to console
    puts "Students filtered by initial '#{ initial }' (excluding prefixes)".bold.blue
    puts short_bar
    puts filtered_list
    puts short_bar
    puts "Total Students".blue + ": #{ filtered_list.count }".bold.blue
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
    puts "Students filed under names with no more than:".blue
    puts "#{ length }".bold.blue + " characters (excluding prefixes)".blue
    puts short_bar
    puts filtered_list
    puts short_bar
    puts "Total Students:".blue + " #{ filtered_list.count }".bold.blue
    puts " "
    puts " "
  end

  #  header of table
  def print_header
    puts long_bar.blue
    print ("|" * 23).blue, "The Students of Villains Academy".center(48), ("|" * 23).blue, "\n"
    print ("|" * 23).blue, "-- #{ @month } Cohort --".center(48), ("|" * 23).blue, "\n"
    puts long_bar.blue
    puts long_bar.blue
  end

  #  body of table
  def print_body
    @students.each.with_index { |student, i| 
      puts "#{ (i + 1).to_s.ljust(12) }#{ student.name.ljust(40) }" + 
      "ID: #{ student.student_id }".ljust(24) +
      "(#{ student.cohort } cohort)".rjust(18)
    }
  end

  #  footer of table
  def print_footer
    puts long_bar.blue
    puts @students.count != 1 ?
    "Overall, this cohort has ".blue + "#{ @students.count }".bold + " great students".blue : 
    "This cohort only has".blue + "#{ @students.count }".bold + " student.".blue
    puts " "
    puts " "
  end

  private

  def enter_age(new_student)
    puts short_bar
    puts ("Please enter #{ new_student.name.capitalize_each }'s age").blue
    puts "(Applicants must be at least 5 and at most 130 years of age)".blue
    abort?
    print "#{ new_student.name.capitalize_each }'s age".yellow + ": "
    new_age = gets.chomp
    #  merge validation and assignment into one step as new student has no data to mutate
    new_student.age = validate_age(new_student, new_age)  #  Validation mixin
    #  sets off 'kill form' chain if user enters 'R'
    (back_arrows; new_student.age = false) if ['R', 'r'].include?(new_student.age)
    return if new_student.age == false
    new_student.age = new_student.age.to_f.round  # round stray decimals
  end

  def enter_gender(new_student)
    puts short_bar
    puts ("Please enter #{ new_student.name.capitalize_each }'s gender (").blue + " M " + "/".blue + " F " + "/".blue + " NB " + "/".blue + " O " + ")".blue
    abort?
    print "#{ new_student.name.capitalize_each }'s gender".yellow + ": "
    new_gender = gets.chomp.upcase
    new_student.gender = validate_gender(new_student, new_gender).upcase
    (back_arrows; new_student.gender = false) if ['R', 'r'].include?(new_student.gender)
  end

  def enter_height(new_student)
    puts short_bar
    puts ("Please enter #{ new_student.name.capitalize_each }'s height (").blue + "in centimeters" + ")".blue
    abort?
    print "#{ new_student.name.capitalize_each }'s height".yellow + ": "
    new_height = gets.chomp
    new_student.height = validate_height(new_student, new_height)
    (back_arrows; new_student.height = false) if ['R', 'r'].include?(new_student.height)
    return if new_student.height == false
    new_student.height = new_student.height.to_f.round(2)  #  round to 1 decimal place
  end

  def enter_country_of_birth(new_student)
    puts short_bar
    puts ("Please enter #{ new_student.name.capitalize_each }'s country of birth").blue
    abort?
    print ("#{ new_student.name.capitalize_each }'s country of birth").blue + ": "
    new_country_of_birth = gets.chomp.capitalize_each
    new_student.country_of_birth = validate_country_of_birth(new_student, new_country_of_birth)
    (back_arrows; new_student.country_of_birth = false) if ['R', 'r'].include?(new_student.country_of_birth)
  end

  def enter_disability_status(new_student)
    puts short_bar
    puts ("Please enter #{ new_student.name.capitalize_each }'s disability status (").blue + " true " + "/".blue + " false " + ")".blue
    abort?
    print "#{ new_student.name.capitalize_each }'s disability status".yellow + ": "
    new_disability_status = gets.chomp.downcase
    new_student.is_disabled = validate_disability_status(new_student, new_disability_status)
    (back_arrows; new_student.is_disabled = false) if ['R', 'r'].include?(new_student.is_disabled)
    new_student.registered = true
  end

  def form(name)
    #  unless the name is not empty, repeat this code
    until name.empty?
      #  create a student
      new_student = Student.new(name)
      new_student.cohort = @month
      print "* Student Created *\n".green
      #  get rest of the data for the student from private methods above
      #  kills current form if user restarts form
      enter_age(new_student)
      break if new_student.age == false
      print "* VALID *\n".bold.green
      enter_gender(new_student)
      break if new_student.gender == false
      print "* VALID *\n".bold.green
      enter_height(new_student)
      break if new_student.height == false
      print "* VALID *\n".bold.green
      enter_country_of_birth(new_student)
      break if new_student.country_of_birth == false
      print "* VALID *\n".bold.green
      enter_disability_status(new_student)
      break if new_student.is_disabled == false
      print "* VALID *\n".bold.green
      
      #  add the Student object to the list of students 
      #  if student is successfully registered
      @students << new_student
      puts " "
      puts " "
      puts ("Student added. New total: ".blue + "#{ @students.count }".bold.blue + 
      ".  Last entry:".blue).center(53)
      new_student.quick_facts
      puts " "
      puts " "
      puts "Please enter another name -- (".blue + "press 'return' to exit" + ")".blue
      puts short_bar

      # get another name from the user
      name = gets.chomp
    end
    return false
  end

  def did_you_mean?(country)
    #  naive search..?
    possible_valid = []
    entry_letters = country.downcase
    #  matches invalid entry to possible valid entries
    puts "Match first #{ (entry_letters.length / 3).to_i } letters..."
    char = entry_letters.length
    #  until a suggestion is found it removes one letter from the end of the invalid entry
    until possible_valid.length > 0 || char == 0
      actual_countries.each { |country|
        possible_valid.push(country.to_s.capitalize_each) if 
        entry_letters.downcase[0..char] == 
        country.to_s[0..char]
      }
      char -= 1
    end
    #  displays suggestions if any
    if possible_valid.length > 0
      puts "Did you mean:".italic
      possible_valid.each { |country| puts country.italic }
    else
      puts "(no matches for entry)"
    end
  end
end

# each student instance
class Student
  include Formatting
  include Validation
  attr_accessor :name, :age, :gender, :height, :country_of_birth,
                :is_disabled, :cohort, :student_id, :registered

  def initialize(name, args={})
    options = defaults.merge(args)

    @name = name
    @age = options.fetch(:age)
    @gender = options.fetch(:gender)
    @height = options.fetch(:height)
    @country_of_birth = options.fetch(:country_of_birth)
    @is_disabled = options.fetch(:is_disabled)
    @cohort  #  assigned upon addition to cohort
    @registered = false
    #  use luhns algorithm to assign a 'valid' zero-padded ID
    random_num = rand(10000000)
    random_id = random_num.to_s.rjust(7, "0")
    until luhns_seven(random_id) == true
      random_num = rand(10000000)
      random_id = random_num.to_s.rjust(7, "0")
    end
    @student_id = random_id
  end

  #  default assignments for Student
  def defaults
    {
      age: "N/A",
      gender: "N/A",
      height: "N/A",
      country_of_birth: "N/A",
      is_disabled: "N/A"
    }
  end

  #  display all stats for a Student
  def quick_facts
    puts short_bar
    puts "Student #{ @student_id } (#{ @cohort })".ljust(50).bold + "***".bold
    puts "Name: #{ @name }".ljust(50).bold + "***".bold
    puts "Age: #{ @age }".ljust(50).bold + "***".bold
    puts "Gender: #{ @gender }".ljust(50).bold + "***".bold
    puts "Height: #{ @height }cm".ljust(50).bold + "***".bold
    puts "Country of Birth: #{ @country_of_birth }".ljust(50).bold + "***".bold
    puts "Disability Status: #{ @is_disabled }".ljust(50).bold + "***".bold
    puts short_bar
  end

  #  edit data for student
  def edit_student
    #  types of editable data
    data = {"Name" => self.name, "Age" => self.age, "Gender" => self.gender,
            "Height" => self.height, "Country of Birth" => self.country_of_birth,
            "Disability Status" => self.is_disabled}

    #  template and options for edit mode
    edit_mode(self)
    self.quick_facts
    puts "What would you like to change about this entry?".center(53).bold.blue
    puts "   (Enter Number or type 'R' to abort)   ".center(53,"-")
    #puts "()".center(53)
    puts short_bar
    puts "***".bold + ("1)".ljust(15).rjust(23).yellow + "Name".rjust(15).bold).center(53) + "***".rjust(12).bold
    puts "***".bold + ("2)".ljust(15).rjust(23).yellow + "Age".rjust(15).bold).center(53) + "***".rjust(12).bold
    puts "***".bold + ("3)".ljust(15).rjust(23).yellow + "Gender".rjust(15).bold).center(53) + "***".rjust(12).bold
    puts "***".bold + ("4)".ljust(15).rjust(23).yellow + "Height".rjust(15).bold).center(53) + "***".rjust(12).bold
    puts "***".bold + ("5)".ljust(14).rjust(22).yellow + "Country of Birth".ljust(17).rjust(15).bold).center(53) + "***".rjust(11).bold
    puts "***".bold + ("6)".ljust(13).rjust(21).yellow + "Disability Status".ljust(19).rjust(10).bold).center(53) + "***".rjust(10).bold
    puts short_bar
    number = gets.chomp

    #  choose an option (or abort)
    until (1..6).to_a.include?(number.to_i) || number.downcase == 'r'
      puts "Invalid entry".red
      puts "Enter new number (or type 'R' to exit)"
      number = gets.chomp
    end

    #  exit edit mode if user types 'R'
    if number.downcase == 'r'
    puts "Done.  Current state of #{ self.name }'s profile:".green
    (self.quick_facts; exit_edit_mode; goodbye; return)
    end

    #  edit data for choice (using Validation mixin)
    puts "Editing #{ self.name }'s #{ data.keys[number.to_i - 1].downcase }"
    case number
    when "1"
      print "Actual name".yellow + ": "
      entry = gets.chomp
      puts "Are you sure? ( Y / N )"
      verify = gets.chomp
      until ["Y", "y", "N", "n"].include?(verify)
      puts "Please enter ( Y / N ) to confirm or abort"
      verify = gets.chomp
      end
      self.name = entry.capitalize_each if ["Y", "y"].include?(verify)
    when "2"
      print "#{ self.name }'s actual age".yellow + ": "
      new_age = gets.chomp
      #  two-staged to protect from mutation during validation (cases 2..6)
      updated_age = validate_age(self, new_age)
      self.age = updated_age.upcase == 'R' ? self.age : updated_age 
    when "3"
      print "#{ self.name }'s actual gender".yellow + ": "
      new_gender = gets.chomp.upcase
      updated_gender = validate_gender(self, new_gender)
      self.gender = updated_gender.upcase == 'R' ? self.gender : updated_gender
    when "4"
      print "#{ self.name }'s actual height".yellow + ": "
      new_height = gets.chomp
      updated_height = validate_height(self, new_height)
      self.height = updated_height.upcase == 'R' ? self.height : updated_height
    when "5"
      print "#{ self.name }'s actual country of birth".yellow + ": "
      new_country_of_birth = gets.chomp.capitalize_each
      updated_country_of_birth = validate_country_of_birth(self, new_country_of_birth)
      self.country_of_birth = updated_country_of_birth.upcase == 'R' ? self.country_of_birth : updated_country_of_birth
    when "6"
      print "#{ self.name }'s actual disability status".yellow + ": "
      new_disability_status = gets.chomp
      updated_disability_status = validate_disability_status(self, new_disability_status)
      self.is_disabled = updated_disability_status.upcase == 'R' ? self.is_disabled : updated_disability_status
    end
    puts short_bar
    puts "Done.  Current state of #{ self.name}'s profile".yellow + ":"
    self.quick_facts
    exit_edit_mode
  end
end

def interface(academy)
  include Formatting
  include Validation
  puts "Welcome"
  puts "Please choose an option:"
  
  puts "1) Display all students in #{ academy.name }"
  puts "2) View all Cohorts in #{ academy.name }"
  puts "3) Add a student to a specific cohort"
  puts "4) Add a cohort to #{ academy.name }"
  puts "5) Delete a student from a cohort"
  puts "6) Filter students (Cohort Level)"
  puts "7) Filter students (All)"
  puts "type 'end' to save and exit"
  #  get user choice
  choice = gets.chomp

  #  skip if user types end
  until choice.downcase == "end"
    choice = choice.to_i
    until (1..7).to_a.include?(choice)
      puts "invalid.."
      choice = gets.chomp.to_i
    end

    case choice
    when 1
      puts "Displaying all students.."
      academy.all_students
    when 2
      puts "Displaying all cohorts.."
      academy.all_cohorts
    when 3
      puts "Adding a new student.."
      puts "Which cohort would you like to add this student to?"
      puts "(press return to go back to menu)"
      #  puts list of existing cohorts (currently order insensitive)
      academy.cohorts.each { |cohort| puts cohort.month }
      cohort_choice = gets.chomp
      #  begin adding a student to the user choice of cohort
      academy.cohorts.select { |cohort|
        cohort.month == cohort_choice }[0].input_student
    when 4
      puts "Creating a new cohort.."
      existing_cohorts = []
      academy.cohorts.each { |cohort| existing_cohorts.push(cohort.month)}
      puts "Enter a valid month to create a new cohort."
      puts "(press return to go back to menu)"
      new_month = gets.chomp
      #  check if entry is a valid month (validation mixin) 
      #  and if cohort already exists
      until actual_months.include?(new_month.downcase.to_sym) && 
            !existing_cohorts.include?(new_month.capitalize)
        if existing_cohorts.include?(new_month.capitalize_each)
          puts "A #{ new_month } Cohort already exists"
          puts "Enter a different month to create a new Cohort"
          puts "(press return to go back to menu)"
          new_month = gets.chomp
        else
          puts "Invalid month.  Enter a valid month to create a new Cohort"
          puts "(press return to go back to menu)"
          new_month = gets.chomp
        end
      end
      #  create new cohort and add it to the academy
      new_cohort = Cohort.new(new_month.capitalize)
      academy.add_cohort(new_cohort)  #  capitalizes within the method
      puts "Done.. Style this!"
      academy.cohorts.each { |cohort| puts cohort.month }
    when 5
      puts "Deleting a student.."
      puts "Do you have the student's ID at hand? ( Y / N )"
      puts "(press return to go back to menu)"
      yesno = gets.chomp.upcase
      until ["Y", "N"].include?(yesno)
        puts "Invalid Entry. Please enter 'Y' or 'N'"
        puts "(press return to go back to menu)"
        yesno = gets.chomp.upcase
      end
      if yesno == "N"
        puts "Displaying all existing students.."
        academy.all_students
      end
      puts "Enter the ID of the student you would like to delete"
      delete_with_id = gets.chomp

    when 6
      puts "CHOICE"
    when 7
      puts "CHOICE"
    end
    puts "Please choose an option:"
    
    puts "1) View all students"
    puts "2) View all Cohorts"
    puts "3) Add a student"
    puts "4) Add a cohort"
    puts "5) Delete a student"
    puts "6) Filter students (Cohort Level)"
    puts "7) Filter students (All)"
    puts "type 'end' to save and exit"
    choice = gets.chomp
  end
end

#############################################################################################################

# general testing

#  converted test entries to Student objects
sam = Student.new("Sam", {age: 25, gender: "M", height: 198, country_of_birth: "England,", is_disabled: true})
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

va_december = Cohort.new("December")

va_december.add_student(wicked_witch, terminator, freddy_krueger, 
                        joker, joffrey, norman_bates)

villains_academy.add_cohort(va_november, va_december)

interface(villains_academy)
raise "done"
#  test methods in CLI
va_november.roster

va_november.input_student
##puts " "
##va_november.roster
##puts " "
##va_november.by_initial("W")
##puts " "
##va_november.by_length(10)

#  create "Villains Academy" December Cohort object


va_december.roster

##va_december.input_student
##puts " "
##va_december.roster
##puts " "
##va_december.by_initial("J")
##puts " "
##va_december.by_length(7)



#  testing delete fuction

##va_november.delete_student(alex_delarge)
##va_december.delete_student(joffrey, terminator)
##villains_academy.all_cohorts

#  testing student migration

va_november.move_student(sam, va_december)
villains_academy.all_cohorts

#  testing edit student

sam.edit_student
