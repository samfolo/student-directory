#  current modules

module Saving

  require 'csv'  
  def save_students(academy, filename = "students.csv")
    #  saves to file that was opened
    filename = ARGV.first != nil ? ARGV.first : filename
    #  open the file for writing
    file = CSV.open(filename, "wb") { |csv|
      #  save the academy name
      csv << [academy.name]
      #  save each cohort
      academy.cohorts.each { |cohort| 
        cohort_data = [cohort.academy, cohort.month]
        csv << cohort_data
        #  save all students for each cohort
        cohort.students.each { |student| 
          student_data = [student.name, student.age, student.gender, student.height, 
                          student.country_of_birth, student.is_disabled, cohort.month, 
                          student.registered, student.student_id]
          csv << student_data
        }
      }
    }
  end

=begin

  def save_students(academy, filename = "students.csv")
    #  saves to file that was opened
    filename = ARGV.first != nil ? ARGV.first : filename
    #  open the file for writing
    file = File.open(filename, "w")
    #  save the academy name
    file.puts academy.name
    #  save each cohort
    academy.cohorts.each { |cohort| 
      cohort_data = [cohort.academy, cohort.month]
      csv_line = cohort_data.join(", ")
      file.puts csv_line
      #  save all students for each cohort
      cohort.students.each { |student| 
        student_data = [student.name, student.age, student.gender, student.height, 
                        student.country_of_birth, student.is_disabled, cohort.month, 
                        student.registered, student.student_id]
        csv_line = student_data.join(", ")
        file.puts csv_line
      }
    }
    file.close
  end

=end

  #  only load program if an argument is supplied pointing to an existing filename 
  #  (or if no argument is supplied)
  def load_students(academy, filename = "students.csv")
      filename = ARGV.first != nil ? ARGV.first : filename
      if File.exists?(filename)
        puts "loading #{ academy.name } session from #{ filename }..".italic.yellow
        #  open file with academy data
        i = 0
        CSV.foreach(filename, "r") { |row| 
          if i == 0  #  if top line:
            #  get the academy name
            academy.name = row.first
          elsif row.length == 2
            #  split cohort data if cohort line:
            cohort_academy, cohort_month = row
            #  recreate and push cohort to academy
            new_cohort = Cohort.new(cohort_month)
            #  assign current academy to new cohort
            new_cohort.academy = cohort_academy
            #  push cohort to academy.cohorts
            academy.add_cohort(Cohort.new(cohort_month))
          else
            #  split student data into variables if student line:
            student_name, student_age, student_gender, student_height, 
            student_country_of_birth, student_disability_status, cohort_month,
            student_registration, student_id_number = row
            #  recreate and push students to last created cohort
            academy.cohorts[-1].add_student(
              Student.new(student_name, { 
                age: student_age, gender: student_gender,
                height: student_height, country_of_birth: student_country_of_birth,
                is_disabled: student_disability_status, cohort: cohort_month, 
                registered: student_registration, student_id: student_id_number 
              })
            )
          end
          i += 1
        }      
      else
        puts "Failed to load session from #{ filename }".italic.red
        exit
      end
  end

=begin
  def try_load_students(academy, filename = "students.csv")  #  as load_students takes an argument
    filename = File.exists?(ARGV.first) ? ARGV.first : filename  #  first argument from the command line
    return if filename.nil?  #  don't load if there is no filename
    if File.exists?(filename)
      puts "loading #{ academy.name } session from #{ filename }..".italic.yellow
      load_students(academy, filename)
    else
      puts "Failed to load session from #{ filename }".italic.red
      exit
    end
  end
=end

end

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
  def blink; colorize(5); end 
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
      student.shift if student.length > 1 && prefixes.include?(student.first)
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
    puts "-------------".center(94)
    puts "Goodbye".center(94)
    puts "-------------".center(94)
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

  #  provide suggestions if user mistypes a country
  def did_you_mean?(country)
    #  naive search..?
    possible_valid = []
    entry_letters = country.downcase
    #  matches invalid entry to possible valid entries
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
      puts "(no matches for entry)".italic
    end
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
    double_every_other = array.reverse[0..-2].map.with_index { |digit, i| i % 2 == 1 ? digit * 2 : digit } << array.first
    #  turns all numbers > 9 into single digits by subtracting 9
    single_digits_only = double_every_other.reverse.map { |digit| digit > 9 ? digit - 9 : digit }
    #  returns whether ID is 'valid' (divisible by 10)
    return single_digits_only.reduce(:+) % 10 == 0
  end

  def validate_age(student, age)
    #  make sure there are no letters or extra decimal points before rounding
    until (/^\d*\.?\d*$/.match(age) && (5..130).include?(age.to_f)) || ['R', 'r'].include?(age)
      puts "* INVALID *".bold.red
      puts short_bar
      puts "Invalid entry."
      puts ("Please enter #{ student.name }'s age").blue
      puts "(Applicants must be at least 5 and at most 130 years of age)".blue
      abort?
      #  semantic check for new students and those under edit
      print student.age == "N/A" ? "#{ student.name }'s age".yellow + ": " : 
                                   "#{ student.name }'s actual age".yellow + ": "
      age = STDIN.gets.chomp
    end
    age  #  ages work by flooring
  end

  def validate_gender(student, gender)
    until (/[a-zA-Z]/.match(gender) && ["M", "F", "NB", "O"].include?(gender.upcase)) || ["R", "r"].include?(gender)
      puts "* INVALID *".bold.red
      puts short_bar
      puts "Invalid entry."
      puts ("Please choose #{ student.name }'s gender").blue
      puts "(".blue + "M" + ") Male / (".blue + "F" + ") Female / (".blue + "NB" + ") Non-Binary / (".blue + "O" + ") Other / Prefer not to say".blue
      abort?
      #  semantic check for new students and those under edit
      print student.gender == "N/A" ? "#{ student.name }'s gender".yellow + ": " : 
                                      "#{ student.name }'s actual gender".yellow + ": "
      gender = /[a-zA-Z]/.match(gender) ? STDIN.gets.chomp : STDIN.gets.chomp.upcase!
    end
    gender
  end

  def validate_height(student, height)
    #  make sure all characters are digits, one decimal point (also check height restrictions)
    until (/^\d*\.?\d*$/.match(height) && (50..300).include?(height.to_f)) || ['R', 'r'].include?(height)
      height = height
      puts "* INVALID *".bold.red
      puts short_bar
      if /^\d*\.?\d*$/.match(height) && height.to_f > 300
        puts "Invalid entry."
        puts "Due to the events of last year we no longer accept giants into this academy.".blue
        puts ("Please enter #{ student.name }'s height (").blue + "in centimeters" + ")".blue
      elsif /^\d*\.?\d*$/.match(height) && height.to_f < 50
        puts "Invalid entry."
        puts "Student is too short to be a villain.  Minimum height requirement is 50cm.".blue
        puts ("Please enter #{ student.name }'s height (").blue + "in centimeters" + ")".blue
      else
        puts "Invalid entry."
        puts ("Please enter #{ student.name }'s height (").blue + "in centimeters" + ")".blue
      end
      abort?
      #  semantic check for new students and those under edit
      print student.height == "N/A" ? "#{ student.name }'s height".yellow + ": " : 
                                      "#{ student.name }'s actual height".yellow + ": "
      height = STDIN.gets.chomp
    end
    height
  end

  def validate_country_of_birth(student, country_of_birth)
    until self.actual_countries.include?(country_of_birth.downcase.to_sym) || ['R', 'r'].include?(country_of_birth)
      puts "* INVALID *".bold.red
      puts short_bar
      puts "Invalid entry."
      puts "#{ country_of_birth }" + " is not a country".blue
      did_you_mean?(country_of_birth)
      puts ("Please enter #{ student.name }'s country of birth").blue
      abort?
      #  semantic check for new students and those under edit
      print student.country_of_birth == "N/A" ? "#{ student.name }'s country of birth".yellow + ": " : 
                                                "#{ student.name }'s actual country of birth".yellow + ": "
      country_of_birth = STDIN.gets.chomp.capitalize_each
    end
    country_of_birth
  end

  def validate_disability_status(student, disability_status)
    until ["true", "false"].include?(disability_status) || ['R', 'r'].include?(disability_status)
      puts "* INVALID *".bold.red
      puts short_bar
      puts "Invalid entry."
      puts ("Please enter #{ student.name }'s disability status (").blue + " true " + "/".blue + " false " + ")".blue
      abort?
      #  semantic check for new students and those under edit
      print student.is_disabled == "N/A" ? ("#{ student.name }'s disability status").yellow + ": " : 
                                            "#{ student.name }'s actual disability status".yellow + ": "
      disability_status = STDIN.gets.chomp.downcase
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
  attr_accessor :name, :cohorts

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
    #  prints all students from all cohorts in one table
    @cohorts.each { |cohort|
      cohort.students.each { |student|
        puts "#{ (i + 1).to_s.ljust(12) }#{ student.name.ljust(40) }" + 
        "ID: #{ student.student_id }".ljust(24) +
        "(#{ student.cohort } cohort)".rjust(18)
        i += 1
      }
    }
    print_footer
  end

  #  sorts all cohorts by actual_months (array) as and when necessary
  def resort_cohorts_by_month
    
    @cohorts.sort_by! { 
      |cohort| actual_months.index(cohort.month.downcase.to_sym) 
    }
  end

  ##  for interface:
  #  document the months which already have cohorts
  def existing_cohorts
    existing = []
    @cohorts.each { |cohort| existing.push(cohort.month) }
    existing
  end
  
  #  get all IDs as strings in an array
  def all_ids
    ids = []
    @cohorts.each { |cohort|
      cohort.students.each { |student|
        ids.push(student.student_id)
      }
    }
    ids
  end

  def all_profiles
    #  get all students from all cohorts in one array
    profiles = []
    @cohorts.each { |cohort|
      cohort.students.each { |student|
        profiles.push(student)
      }
    }
    profiles
  end

  #  list existing cohorts with measured whitespace
  def list_cohort_months
    @cohorts.each.with_index { |cohort, i|
      puts ("#{ i + 1 })".bold.yellow) + " " * (3 - (i + 1).digits.length) + ("#{ cohort.month }").bold 
    }
  end

  private

  #  header of table
  def print_header
    puts long_bar.blue
    print ("|" * 23).blue, "The Students of #{ self.name }".center(48), ("|" * 23).blue, "\n"
    print ("|" * 23).blue, "==== All Students ====".center(48), ("|" * 23).blue, "\n"
    puts long_bar.blue
  end

  #  body of table
  def print_body
    @cohorts.each { |cohort| 
      puts long_bar.darkblue
      print ("|" * 23).darkblue, "-- #{ cohort.month } Cohort --".center(48), ("|" * 23).darkblue, "\n"
      puts long_bar.darkblue
      #  don't display if there are no students
      if cohort.students.length < 1
        puts ("* NO STUDENTS ENROLLED *").center(94).red
      else
        cohort.print_body
      end
      puts long_bar.darkblue
    }
  end

  #  footer of table
  def print_footer
    #  semantics check to account for cohorts without any students and/or fewer than two cohorts
    non_empty = @cohorts.select { |cohort| cohort if cohort.students.count > 0 }.count
    puts long_bar.blue
    if @cohorts.length > 1
      puts total_students != 1 ?
      "Overall, #{ self.name } has ".blue + "#{ total_students }".bold.blue + 
      " great students over ".blue + "#{ non_empty }".bold.blue + " cohorts".blue : 
      "#{ self.name } only has ".blue + "#{ total_students }".bold.blue + " student.".blue
    elsif @cohorts.length == 1
      puts total_students != 1 ?
      "Overall, #{ self.name } has ".blue + "#{ total_students }".bold.blue + 
      " great students, all in a single cohort".blue : 
      "#{ self.name } only has ".blue + "#{ total_students }".bold.blue + " student.".blue
    else
      puts "There are currently no cohorts in #{ self.name }"
    end
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
    if actual_months.include?(month.downcase.to_sym) || 
    #  or temporary cohorts for full-academy filtering
    month == "Whole Academy"
      @month = month.capitalize
    else
      raise "Error: #{ month } is not a month."
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
    name = STDIN.gets.chomp.capitalize_each
    #  gets rest of data from private method 'form' if name is entered, else aborts
    form(name)
    #  format results upon completion
    puts " "
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
        (valid.push(student); entries.delete_at(entries.index(student))) if student == entry
      }
    }

    #  deletes target students
    valid.each { |entry| 
      @students.delete_at(@students.index(entry))
    }

    #  displays remaining (invalid) entries
    if entries.length == 0
      #  do nothing
    elsif valid.length != entries.length
    invalid = entries
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
        puts "#{ i + 1 })".bold.yellow
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
    natural_names = no_prefix  #  remove prefixes (Formatting mixin)
  
    #  filter natural names by first initial, then pick corresponding 
    #  entry from original array
    filtered_list = []
    natural_names.each.with_index { |student, i| 
      filtered_list << @students[i].name if student.chr == initial 
    }
  
    # puts result to console
    puts "Students filtered by initial '#{ initial }' (excluding prefixes)".bold.blue
    puts short_bar
    puts filtered_list
    puts short_bar
    puts "Total Students".blue + ": #{ filtered_list.count }".bold.blue
    puts " "
  end
  
  def by_length(length)
    natural_names = no_prefix
  
    #  filter out names over a certain number of characters, 
    #  then pick corresponding entry from original array
    filtered_list = []
    natural_names.each.with_index { |student, i| 
      filtered_list << @students[i].name if student.length <= length 
    }
  
    # puts result to console
    puts "Students filed under names with no more than:".blue
    puts "#{ length }".bold.blue + " characters (excluding prefixes)".blue
    puts short_bar
    puts filtered_list
    puts short_bar
    puts "Total Students:".blue + " #{ filtered_list.count }".bold.blue
    puts " "
  end

  #  header of table
  def print_header
    puts long_bar.darkblue
    print ("|" * 23).darkblue, "The Students of #{ self.academy }".center(48), ("|" * 23).darkblue, "\n"
    print ("|" * 23).darkblue, "-- #{ @month } Cohort --".center(48), ("|" * 23).darkblue, "\n"
    puts long_bar.darkblue
    puts long_bar.darkblue
  end

  #  body of table
  def print_body
    #  don't display if there are no students
    if @students.length < 1
      puts ("* NO STUDENTS ENROLLED *").center(94).red
    else
      @students.each.with_index { |student, i| 
        puts "#{ (i + 1).to_s.ljust(12) }#{ student.name.ljust(40) }" + 
        "ID: #{ student.student_id }".ljust(24) +
        "(#{ student.cohort } cohort)".rjust(18)
      }
    end
  end

  #  footer of table
  def print_footer
    puts long_bar.darkblue
    puts @students.count != 1 ?
    "Overall, this cohort has ".darkblue + "#{ @students.count }".bold.darkblue + " great students".darkblue : 
    "This cohort only has".darkblue + "#{ @students.count }".bold.darkblue + " student.".darkblue
    puts " "
  end

  private

  def enter_age(new_student)
    puts short_bar
    puts ("Please enter #{ new_student.name.capitalize_each }'s age").blue
    puts "(Applicants must be at least 5 and at most 130 years of age)".blue
    abort?
    print "#{ new_student.name.capitalize_each }'s age".yellow + ": "
    new_age = STDIN.gets.chomp
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
    new_gender = STDIN.gets.chomp.upcase
    new_student.gender = validate_gender(new_student, new_gender).upcase
    (back_arrows; new_student.gender = false) if ['R', 'r'].include?(new_student.gender)
  end

  def enter_height(new_student)
    puts short_bar
    puts ("Please enter #{ new_student.name.capitalize_each }'s height (").blue + "in centimeters" + ")".blue
    abort?
    print "#{ new_student.name.capitalize_each }'s height".yellow + ": "
    new_height = STDIN.gets.chomp
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
    new_country_of_birth = STDIN.gets.chomp.capitalize_each
    new_student.country_of_birth = validate_country_of_birth(new_student, new_country_of_birth)
    (back_arrows; new_student.country_of_birth = false) if ['R', 'r'].include?(new_student.country_of_birth)
  end

  def enter_disability_status(new_student)
    puts short_bar
    puts ("Please enter #{ new_student.name.capitalize_each }'s disability status (").blue + " true " + "/".blue + " false " + ")".blue
    abort?
    print "#{ new_student.name.capitalize_each }'s disability status".yellow + ": "
    new_disability_status = STDIN.gets.chomp.downcase
    new_student.is_disabled = validate_disability_status(new_student, new_disability_status)
    (back_arrows; new_student.is_disabled = false) if ['R', 'r'].include?(new_student.is_disabled)
    registered = true  #  form fully filled
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
      registered = true
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
      name = STDIN.gets.chomp.capitalize_each
    end
    return false
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
    @registered = options.fetch(:registered)
    @student_id = options.fetch(:student_id)
  end

  #  default assignments for Student
  def defaults
    random_num = rand(10000000)
    random_id = random_num.to_s.rjust(7, "0")
    until luhns_seven(random_id) == true
      random_num = rand(10000000)
      random_id = random_num.to_s.rjust(7, "0")
    end
    {
      age: "N/A",
      gender: "N/A",
      height: "N/A",
      country_of_birth: "N/A",
      is_disabled: "N/A",
      registered: false,
      #  use luhns algorithm to assign a 'valid' zero-padded ID
      student_id: random_id,
      cohort: "N/A"
    }
  end

  #  display all stats for a Student
  def quick_facts
    puts short_bar
    puts "Student #{ @student_id } (#{ @cohort })".ljust(50).bold +  "***".bold
    puts "Name: #{ @name }".ljust(50).bold +                         "***".bold
    puts "Age: #{ @age }".ljust(50).bold +                           "***".bold
    puts "Gender: #{ @gender }".ljust(50).bold +                     "***".bold
    puts "Height: #{ @height }cm".ljust(50).bold +                   "***".bold
    puts "Country of Birth: #{ @country_of_birth }".ljust(50).bold + "***".bold
    puts "Disability Status: #{ @is_disabled }".ljust(50).bold +     "***".bold
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
    puts short_bar
    puts "***".bold + ("1)".ljust(15).rjust(23).yellow + "Name".rjust(15).bold).center(53) +                        "***".rjust(12).bold
    puts "***".bold + ("2)".ljust(15).rjust(23).yellow + "Age".rjust(15).bold).center(53) +                         "***".rjust(12).bold
    puts "***".bold + ("3)".ljust(15).rjust(23).yellow + "Gender".rjust(15).bold).center(53) +                      "***".rjust(12).bold
    puts "***".bold + ("4)".ljust(15).rjust(23).yellow + "Height".rjust(15).bold).center(53) +                      "***".rjust(12).bold
    puts "***".bold + ("5)".ljust(14).rjust(22).yellow + "Country of Birth".ljust(17).rjust(15).bold).center(53) +  "***".rjust(11).bold
    puts "***".bold + ("6)".ljust(13).rjust(21).yellow + "Disability Status".ljust(19).rjust(10).bold).center(53) + "***".rjust(10).bold
    puts short_bar
    number = STDIN.gets.chomp

    #  choose an option (or abort)
    until (number.scan(/\D/).empty? && (1..6).to_a.include?(number.to_i)) || number.downcase == 'r'
      puts "Invalid entry.".red
      puts "Enter new number (or type 'R' to exit)"
      number = STDIN.gets.chomp
    end

    #  exit edit mode if user types 'R'
    if number.downcase == 'r'
      puts short_bar
      puts "Done.  Current state of #{ self.name }'s profile".yellow + ":"
      (self.quick_facts; exit_edit_mode; return)
    end

    #  edit data for choice (using Validation mixin)
    puts ("Editing #{ self.name }'s #{ data.keys[number.to_i - 1].downcase }..").italic.blue
    case number
    when "1"
      print "New name".yellow + ": "
      entry = STDIN.gets.chomp
      puts "Are you sure? (".blue + " Y " + "/".blue + " N " + ")".blue
      verify = STDIN.gets.chomp
      until ["Y", "y", "N", "n"].include?(verify)
      puts "Please enter (".blue + " Y " + "/".blue + " N " + ") to confirm or abort".blue
      verify = STDIN.gets.chomp
      end
      self.name = entry.capitalize_each if ["Y", "y"].include?(verify)
    when "2"
      print "#{ self.name }'s actual age".yellow + ": "
      new_age = STDIN.gets.chomp
      #  two-staged to protect from mutation during validation (cases 2..6)
      updated_age = validate_age(self, new_age)
      self.age = ['R', 'r'].include?(updated_age) ? self.age : updated_age.to_f.floor
    when "3"
      print "#{ self.name }'s actual gender".yellow + ": "
      new_gender = STDIN.gets.chomp.upcase
      updated_gender = validate_gender(self, new_gender.upcase)
      self.gender = updated_gender.upcase == 'R' ? self.gender : updated_gender.upcase
    when "4"
      print "#{ self.name }'s actual height".yellow + ": "
      new_height = STDIN.gets.chomp
      updated_height = validate_height(self, new_height)
      self.height = updated_height.upcase == 'R' ? self.height : updated_height.to_f
    when "5"
      print "#{ self.name }'s actual country of birth".yellow + ": "
      new_country_of_birth = STDIN.gets.chomp.capitalize_each
      updated_country_of_birth = validate_country_of_birth(self, new_country_of_birth)
      self.country_of_birth = updated_country_of_birth.upcase == 'R' ? self.country_of_birth : updated_country_of_birth
    when "6"
      print "#{ self.name }'s actual disability status".yellow + ": "
      new_disability_status = STDIN.gets.chomp
      updated_disability_status = validate_disability_status(self, new_disability_status)
      self.is_disabled = updated_disability_status.upcase == 'R' ? self.is_disabled : updated_disability_status
    end
    puts short_bar
    puts "Done.  Current state of #{ self.name}'s profile".italic.yellow + ":"
    self.quick_facts
    exit_edit_mode
  end
end

#  menu formatting
def full_menu(academy)
  print ("1)  ".bold.yellow + "Display all students in #{ academy.name }".bold).ljust(78), "8)  ".bold.yellow + "Move student to another cohort".bold, "\n"
  print ("2)  ".bold.yellow + "View all Cohorts in #{ academy.name }".bold).ljust(78),     "9)  ".bold.yellow + "Filter students at cohort level".bold, "\n"
  print ("3)  ".bold.yellow + "View an indidual cohort".bold).ljust(78),                   "10) ".bold.yellow + "Filter all students".bold, "\n"
  print ("4)  ".bold.yellow + "Display student profiles at cohort level".bold).ljust(78),  "11) ".bold.yellow + "Edit a student".bold, "\n"
  print ("5)  ".bold.yellow + "Display all student profiles".bold).ljust(78),              "12) ".bold.yellow + "Add a cohort to #{ academy.name }".bold, "\n"
  print ("6)  ".bold.yellow + "Add a student to a specific cohort".bold).ljust(78),        "13) ".bold.yellow + "Remove a cohort from #{ academy.name }".bold, "\n"
  print ("7)  ".bold.yellow + "Delete a student from a specific cohort".bold).ljust(78),   "---- (type 'end' to save and exit) ----".bold.blue, "\n"
end

#  view all students in the academy in one list
def view_all_students(academy)
  include Formatting
  include Validation
  puts long_bar
  puts " "
  puts "Displaying all students..".italic.blue
  academy.all_students
end

#  view all students in the academy divided into their cohorts
def view_all_cohorts(academy)
  include Formatting
  include Validation
  puts long_bar
  puts " "
  puts "Displaying all cohorts..".italic.blue
  academy.all_cohorts
end

#  view all students in a particular cohort
def view_a_cohort(academy)
  include Formatting
  include Validation
  puts long_bar
  puts " "
  puts "Which cohort would you like to view? ( ".bold.blue + "enter a month" + " )".bold.blue
  puts "(press return to go back to menu)".italic
  #  puts list of cohorts to choose from
  academy.list_cohort_months
  print "Enter a month".yellow, ": "
  cohort_choice = STDIN.gets.chomp.capitalize
  if cohort_choice != ""  #  main menu if user presses return
    until academy.existing_cohorts.include?(cohort_choice.capitalize)
      puts "----"
      puts "Invalid entry.".italic.red
      puts "Please enter an existing cohort month".blue
      puts "(press return to go back to menu)".italic
      academy.list_cohort_months
      print "Enter a month".yellow, ": "
      cohort_choice = STDIN.gets.chomp.capitalize
      return if cohort_choice == ""  # main menu if user presses return
    end
    puts long_bar
    puts " "
    puts ("Displaying #{ cohort_choice } cohort..").italic.blue
    puts academy.cohorts.select { |cohort| cohort.roster if cohort.month == cohort_choice }
  end
end

#  display student profiles at cohort level (divided by month)
def view_profiles_by_cohort(academy)
  include Formatting
  include Validation
  puts long_bar
  puts " "
  puts ("Displaying all #{ academy.name } student profiles by cohort..").italic.blue
  i = 0
  academy.cohorts.each { |cohort| 
    #  only displays if cohort has students
    if cohort.students.length > 0
      puts ("#{ cohort.month }:").bold.blue
      puts " "
      cohort.students.each.with_index { |student, i| 
        puts "#{ i + 1 })".bold.yellow
        student.quick_facts 
        i += 1
      }
      puts " "
    end
  }
end

#  display student profiles at academy level
def view_all_profiles(academy)
  include Formatting
  include Validation
  puts long_bar
  puts " "
  puts ("Displaying all student profiles for #{ academy.name }..").italic.blue
  puts " "
  i = 0
  academy.cohorts.each { |cohort| 
    cohort.students.each { |student| 
      puts "#{ i+1 })".bold.yellow
      student.quick_facts 
      i += 1
    }
  }
  puts " "
end

#  add a new student (fill in a form)
def add_a_student(academy)
  include Formatting
  include Validation
  puts long_bar
  puts " "
  if academy.cohorts.length == 0  #  if there are no cohorts yet (for blank sessions)
    puts "There are no cohorts to add a student to just yet".italic.blue
    puts "You can add a cohort at the menu".italic.blue
    puts " "
  else
    puts "Adding a new student..".italic.blue
    puts "Which cohort would you like to add this student to?".bold.blue
    puts "(press return to go back to menu)".italic
    academy.list_cohort_months
    print "Enter a month".yellow, ": "
    cohort_choice = STDIN.gets.chomp
    if cohort_choice != ""  #  else to menu
      until academy.existing_cohorts.include?(cohort_choice.capitalize)
        puts "----"
        puts "Invalid entry.".italic.red
        puts "Please enter an existing cohort month".blue
        puts "(press return to go back to menu)".italic
        academy.list_cohort_months
        print "Enter a month".yellow, ": "
        cohort_choice = STDIN.gets.chomp
        return if cohort_choice == ""  #  else to menu
      end

      if cohort_choice != ""
        cohort_choice = cohort_choice.capitalize
        #  begin adding a student to the user choice of cohort, but first
        #  check if cohort is full
        selected_cohort = academy.cohorts.select { |cohort| 
          cohort if cohort.month == cohort_choice
        }.first
        cohort_is_full = selected_cohort.students.length >= 30
        if cohort_is_full
          puts long_bar
          puts " "
          puts "Operation aborted".italic.red
          puts "The #{ selected_cohort.month } cohort is currently full – maximum intake is 30.".blue
          puts " "
        else
          selected_cohort.input_student
        end
      end
    end
  end
end

#  delete a student from the academy
def delete_a_student(academy)
  include Formatting
  include Validation
  puts long_bar
  puts " "
  puts "Deleting a student..".italic.blue
  puts "Do you have the student's ID to hand? (".bold.blue + " Y " + "/".bold.blue + " N " + ")".bold.blue
  puts "(press return to go back to menu)".italic
  print "Answer".yellow, ": "
  yesno = STDIN.gets.chomp
  if yesno != ""  #  else to menu
    until ["Y", "y", "N", "n"].include?(yesno)
      puts "----"
      puts "Invalid Entry.".italic.red
      puts "Please enter ".blue + "Y" + " or ".blue + "N" + " to confirm".blue
      puts "(press return to go back to menu)".italic
      print "Answer".yellow, ": "
      yesno = STDIN.gets.chomp
      return if yesno == ""  #  else to menu
    end
    if ["N", "n"].include?(yesno) 
      puts long_bar
      puts " "
      puts "Displaying all existing students..".italic.blue
      academy.all_students
    end
    if yesno != ""  #  else to menu
      sure = ""  #  repeat until user is sure of deletion
      until ["Y", "y"].include?(sure)
        puts "----"
        puts "Enter the ID of the student you would like to delete".bold.blue
        puts "(press 'return' to go back to menu)".italic
        print "ID".yellow, ": "
        #  get an ID, keeps asking until ID is valid
        to_delete = STDIN.gets.chomp
        return if to_delete == ""  #  else to menu
        until academy.all_ids.include?(to_delete)
          puts "----"
          puts "Invalid entry.".italic.red
          puts "Please enter a valid ID".blue
          puts "(press 'return' to go back to menu)".italic
          print "ID".yellow, ": "
          to_delete = STDIN.gets.chomp
          return if to_delete == ""  #  else to menu
        end
        return if to_delete == ""  #  else to menu
        #  finds student with chosen ID
        if to_delete != ""
          selected_student = academy.all_profiles.select { |profile|
            profile if profile.student_id == to_delete
          }.first
          puts long_bar
          puts " "
          puts "You are about to remove Student ID: #{ to_delete }".blue + " #{ selected_student.name }".italic.blue
          puts "Are you sure?".bold.italic.blue + "(".bold.blue + " Y " + "/".bold.blue + " N " + ")".bold.blue
          print "Answer".yellow, ": "
          sure = STDIN.gets.chomp.upcase
          until ["Y", "N"].include?(sure)
            puts "----"
            puts "Please enter ".blue + "Y" + " or ".blue + "N" + " to confirm".blue
            print "Answer".yellow, ": "
            sure = STDIN.gets.chomp.upcase
          end
          if sure == "Y"
            academy.cohorts.each { |cohort|
              cohort.students.each { |student|
                cohort.delete_student(student) if student == selected_student
              }
            }
            puts long_bar
            puts " "
            puts "#{ selected_student.name }".italic.blue + " has been deleted.".italic.blue
            academy.all_cohorts
          end
        end
      end
    end
  end
end

#  move student from one cohort to another
def move_a_student(academy)
  include Formatting
  include Validation
  puts long_bar
  puts " "
  puts "Migrating student..".italic.blue
  puts ("Do you have the student's ID to hand? (").bold.blue + " Y " + "/".bold.blue + " N " + ")".bold.blue
  puts "(press return to go back to menu)".italic
  print "Answer".yellow, ": "
  yesno = STDIN.gets.chomp.upcase
  if yesno != ""  #  else to menu
    until ["Y", "y", "N", "n"].include?(yesno)
      puts "----"
      puts "Invalid Entry.".italic.red
      puts "Please enter ".blue + "Y" + " or ".blue + "N" + " to confirm".blue
      puts "(press return to go back to menu)".italic
      print "Answer".yellow, ": "
      yesno = STDIN.gets.chomp.upcase
      return if yesno == ""  #  else to menu
    end
    if yesno == "N"
      puts long_bar
      puts " "
      puts "Displaying all existing students..".italic.blue
      academy.all_students
    end
    if yesno != ""  #  else to menu (skip rest of case)
      sure = ""  #  repeat until user is sure of deletion
      until sure == "Y" || sure == "N"
        puts long_bar
        puts " "
        puts "Enter the ID of the student you would you like to move".bold.blue
        puts "(press 'return' to go back to menu)".italic
        print "ID".yellow, ": "
        student_to_move = STDIN.gets.chomp
        return if student_to_move == ""  #  else to menu
        until academy.all_ids.include?(student_to_move)
          puts "----"
          puts "Invalid entry.".italic.red
          puts "Please enter a valid ID".blue
          puts "(press 'return' to go back to menu)".italic
          print "ID".yellow, ": "
          student_to_move = STDIN.gets.chomp
          return if student_to_move == ""  #  else to menu
        end
        return if student_to_move == ""  #  else to menu
        #  selects student
        selected_student = academy.all_profiles.select { |profile|
          profile if profile.student_id == student_to_move
        }.first
        #  selects cohort of student
        base_cohort = academy.cohorts.select { |cohort| 
          cohort if cohort.month == selected_student.cohort
        }.first
        puts long_bar
        puts " "
        puts ("Which cohort would you like to move #{ selected_student.name } to? ( ").bold.blue + "enter a month" + " )".bold.blue
        puts "(press 'return' to go back to menu)".italic
        #  only puts possible moves (can't move to current cohort)
        academy.cohorts.each.with_index { |cohort, i|
          puts ("#{ i + 1 })".bold.yellow) + " " * (3 - (i + 1).digits.length) + ("#{ cohort.month }").bold if cohort.month != selected_student.cohort
        }
        print "Enter a month".yellow, ": "
        target_cohort = STDIN.gets.chomp
        if target_cohort != ""  #  else to menu (inner loop break)
          target_cohort = target_cohort.capitalize
          #  until target is a valid and seperate cohort
          until academy.existing_cohorts.include?(target_cohort.capitalize) && selected_student.cohort != target_cohort.capitalize
            if selected_student.cohort == target_cohort
              puts "----"
              puts ("#{ selected_student.name } is already in the #{ target_cohort } cohort.").blue
              puts "Please enter another cohort".blue
              puts "(press return to go back to menu)".italic
              academy.cohorts.each.with_index { |cohort, i|
                puts ("#{ i + 1 })".bold.yellow) + " " * (3 - (i + 1).digits.length) + ("#{ cohort.month }").bold if cohort.month != selected_student.cohort
              }
              print "Enter a month".yellow, ": "
              target_cohort = STDIN.gets.chomp
              return if target_cohort != ""  #  else to menu (inner loop break)
            else
              puts "----"
              puts "Invalid entry.".italic.red
              puts "Please enter an existing cohort month".blue
              puts "(press return to go back to menu)".italic
              academy.cohorts.each.with_index { |cohort, i|
                puts ("#{ i + 1 })".bold.yellow) + " " * (3 - (i + 1).digits.length) + ("#{ cohort.month }").bold if cohort.month != selected_student.cohort
              }
              print "Enter a month".yellow, ": "
              target_cohort = STDIN.gets.chomp
              return if target_cohort == ""  #  else to menu (inner loop break)
            end
          end
          if target_cohort != ""  #  else to menu
            target_cohort = target_cohort.capitalize
            #  check if cohort is full
            selected_cohort = academy.cohorts.select { |cohort| 
              cohort if cohort.month == target_cohort
            }.first
            cohort_is_full = selected_cohort.students.length >= 30
            if cohort_is_full
              puts long_bar
              puts " "
              puts "Operation aborted".italic.red
              puts "The #{ selected_cohort.month } cohort is currently full – maximum intake is 30.".blue
              puts " "
            else
              puts long_bar
              puts " "
              puts "You are about to move Student ID: ".blue + "#{ selected_student.student_id } ".blue + "#{ selected_student.name }".italic.blue + " to the ".blue + "#{ target_cohort }".bold.blue + " cohort.".blue
              puts "Are you sure?".bold.italic.blue + " (".bold.blue + " Y " + "/".bold.blue + " N " + ")".bold.blue
              print "Answer".yellow, ": "
              sure = STDIN.gets.chomp.upcase
              until ["Y", "N"].include?(sure)
                puts "----"
                puts "Please enter ".blue + "Y" + " or ".blue + "N" + " to confirm".blue
                print "Answer".yellow, ": "
                sure = STDIN.gets.chomp.upcase
              end
              if sure == "Y"
                target_cohort = academy.cohorts.select { |cohort| 
                  cohort if cohort.month == target_cohort
                }.first
                base_cohort.move_student(selected_student, target_cohort)
                puts long_bar
                puts " "
                puts "Done.".italic.blue
                puts ("#{ selected_student.name } has been moved to the #{ target_cohort.month } cohort.").italic.blue
                academy.all_cohorts
              else
                puts "----"
                puts "aborted".italic.red
              end
            end
          end
        end
      end
    end
  end
end

#  filter students by either initial or maximum name length 
#  at cohort level (can add more options if necessary)
def filter_at_cohort_level(academy)
  include Formatting
  include Validation
  puts long_bar
  puts " "
  puts "Searching at cohort level..".italic.blue
  puts "Which cohort would you like to search? ( ".bold.blue + "enter a month" + " )".bold.blue
  puts "(press 'return' to go back to menu)".italic
  academy.list_cohort_months
  print "Enter a month".yellow, ": "
  cohort_to_search = STDIN.gets.chomp
  if cohort_to_search != ""  #  else to menu
    until academy.existing_cohorts.include?(cohort_to_search.capitalize)
      puts "----"
      puts "Invalid entry.".italic.red
      puts "Please enter a valid cohort month".blue
      puts "(press 'return' to go back to menu)".italic
      academy.list_cohort_months
      print "Enter a month".yellow, ": "
      cohort_to_search = STDIN.gets.chomp
      return if cohort_to_search == ""  #  else to menu
    end
    if cohort_to_search != ""  #  else to menu
      cohort_to_search = cohort_to_search.capitalize
      #  locate cohort in question
      filter_cohort = academy.cohorts.select{ |cohort| 
                        cohort if cohort.month == cohort_to_search 
                      }.first
      puts long_bar
      puts " "
      puts ("Searching through #{ cohort_to_search } cohort..").italic.blue
      puts "How would you like to filter results? ( ".bold.blue + "enter a number" + " )".bold.blue
      puts "(press 'return' to go back to menu)".italic
      puts "1)  ".bold.yellow + "Initial".bold
      puts "2)  ".bold.yellow + "Length".bold
      #  get choice
      print "Option".yellow, ": "
      filter_by = STDIN.gets.chomp
      if filter_by != ""  #  else to menu
        until filter_by.scan(/\D/).empty? && (1..2).to_a.include?(filter_by.to_i)
          puts "----"
          puts "Invalid entry.".italic.red
          puts "How would you like to filter results? ( ".bold.blue + "enter a number" + " )".bold.blue
          puts "(press 'return' to go back to menu)".italic
          puts "1)  ".bold.yellow + "Initial".bold
          puts "2)  ".bold.yellow + "Length".bold
          print "Option".yellow, ": "
          filter_by = STDIN.gets.chomp
          return if filter_by == ""
        end
        if filter_by != ""  #  else to menu
          filter_by = filter_by.to_i

          case filter_by
          when 1
            puts long_bar
            puts " "
            puts "Enter an initial".bold.blue
            puts "(press 'return' to go back to menu)".italic
            print "Initial".yellow, ": "
            initial = STDIN.gets.chomp
            if initial != ""  #  else to menu
              until initial.length == 1 && (/[a-zA-Z]/).match(initial.upcase)
                puts "----"
                puts "Invalid entry.".italic.red
                puts "Please enter a single letter".blue
                puts "(press 'return' to go back to menu)".italic
                print "Initial".yellow, ": "
                initial = STDIN.gets.chomp
                return if initial == ""
              end
              if initial != ""
                initial = initial.upcase
                puts long_bar
                puts " "
                puts "Filtering students by initial ".italic.blue + "'#{ initial }'".bold.italic.blue + "..".italic.blue
                puts ("Results for #{ academy.name }'s #{ filter_cohort.month } cohort").blue
                filter_cohort.by_initial(initial)
              end
            end

          when 2
            puts long_bar
            puts " "
            puts "Enter a maximum name length ( ".bold.blue + "number" + " )".bold.blue
            puts "(press 'return' to go back to menu)".italic
            print "Max length".yellow, ": "
            limit = STDIN.gets.chomp
            if limit != ""
              until limit.to_i > 0 && limit.scan(/\D/).empty?
                puts "----"
                puts "Invalid entry.".italic.red
                puts "Please enter an integer for the maximum name length".blue
                puts "(press 'return' to go back to menu)".italic
                print "Max length".yellow, ": "
                limit = STDIN.gets.chomp
                return if limit == ""
              end
              if limit != ""
                puts long_bar
                puts " "
                puts "Filtering #{ filter_cohort.month } cohort names with at most ".italic.blue + "#{ limit }".bold.italic.blue + " letters..".italic.blue
                puts ("Results for #{ academy.name }'s #{ filter_cohort.month } cohort").blue
                filter_cohort.by_length(limit.to_i)
              end
            end

          end
        end
      end
    end
  end
end

#  gather every student from every cohort into temporary cohort
def filter_all_students(academy)
  include Formatting
  include Validation
  all = Cohort.new("Whole Academy")
  academy.cohorts.each { |cohort|
    cohort.students.each { |student|
      all.students.push(student)
    }
  }

  puts long_bar
  puts " "
  puts ("Searching #{ academy.name }'s entire roster..").italic.blue
  puts "How would you like to filter results? ( ".bold.blue + "enter a number" + " )".bold.blue
  puts "1)  ".bold.yellow + "Initial".bold
  puts "2)  ".bold.yellow + "Length".bold
  puts "(press 'return' to go back to menu)".italic
  print "Option".yellow, ": "
  filter_by = STDIN.gets.chomp
  if filter_by != ""  #  else to menu
    until filter_by.scan(/\D/).empty? && (1..2).to_a.include?(filter_by.to_i)
      puts "----"
      puts "Invalid entry.".italic.red
      puts "Please enter one of the following options:".blue
      puts "1)  ".bold.yellow + "Initial".bold
      puts "2)  ".bold.yellow + "Length".bold
      puts "(press 'return' to go back to menu)".italic
      print "Option".yellow, ": "
      filter_by = STDIN.gets.chomp
      return if filter_by == ""  #  else to menu
    end
    if filter_by != ""  #  else to menu
      filter_by = filter_by.to_i
      case filter_by
      when 1
        puts long_bar
        puts " "
        puts "Enter an initial".bold.blue
        puts "(press 'return' to go back to menu)".italic
        print "Initial".yellow, ": "
        initial = STDIN.gets.chomp
        if initial != ""  #  else to menu
          until initial.length == 1 && (/[a-zA-Z]/).match(initial.upcase)
            puts "----"
            puts "Invalid entry.".italic.red
            puts "Please enter a single letter".blue
            puts "(press 'return' to go back to menu)".italic
            print "Initial".yellow, ": "
            initial = STDIN.gets.chomp
            return if initial == ""  #  else to menu
          end
          if initial != ""  #  else to menu
            initial = initial.upcase
            puts long_bar
            " "
            puts "Filtering students by initial ".italic.blue + "'#{ initial }'".bold.italic.blue + "..".italic.blue
            puts ("Results for #{ academy.name }").blue
            all.by_initial(initial)
          end
        end

      when 2
        puts long_bar
        puts " "
        puts "Enter a maximum name length ( ".bold.blue + "number" + " )".bold.blue
        puts "(press 'return' to go back to menu)".italic
        print "Max length".yellow, ": "
        limit = STDIN.gets.chomp
        if limit != ""  #  else to menu
          until limit.scan(/\D/).empty? && limit.to_i > 0 
            puts "----"
            puts "Invalid entry.".italic.red
            puts "Please enter an integer for the maximum name length".blue
            puts "(press 'return' to go back to menu)".italic
            print "Max length".yellow, ": "
            limit = STDIN.gets.chomp
            return if limit == ""  #  else to menu
          end
          if limit != ""  #  else to menu
            puts long_bar
            puts " "
            puts "Filtering student names with at most ".italic.blue + "#{ limit }".bold.italic.blue + " letters..".italic.blue
            puts ("Results for #{ academy.name } ---").blue
            all.by_length(limit.to_i)
          end
        end

      end
    end
  end
end

#  edit a student
def edit_a_student(academy)
  include Formatting
  include Validation
  puts long_bar
  puts " "
  puts "Editing a student..".italic.blue
  academy.all_students
  puts "Which student would you like to edit? ( ".bold.blue + "enter an ID" + " )".bold.blue
  puts "(press return to go back to menu)".italic
  print "ID".yellow, ": "
  student_choice = STDIN.gets.chomp
  if student_choice != ""  #  else to menu
    student_to_edit = academy.all_profiles.select { |student| student if student.student_id == student_choice }.first
    until student_to_edit  #  exists
      puts "----"
      puts "Invalid entry.".italic.red
      puts "Please enter a valid ID".blue
      puts "(press return to go back to menu)".italic
      print "ID".yellow, ": "
      student_choice = STDIN.gets.chomp
      return if student_choice == ""  #  else to menu
      student_to_edit = academy.all_profiles.select { |student| student if student.student_id == student_choice }.first
    end
    if student_choice != ""  #  else to menu
      puts short_bar
      student_to_edit.edit_student
      puts " "
      #  repeat edit mode for student until user exits
      puts ("Would you like to edit another attribute for #{ student_to_edit.name }? (").blue + " Y " + "/".blue + " N " + ")".blue
      print "Answer".yellow, ": "
      yesno = STDIN.gets.chomp.upcase
      until yesno == "N"
        if yesno == "Y"
          puts short_bar
          student_to_edit.edit_student
          puts " "
          puts ("Would you like to edit another attribute for #{ student_to_edit.name }? (").blue + " Y " + "/".blue + " N " + ")".blue
          print "Answer".yellow, ": "
          yesno = STDIN.gets.chomp.upcase
        else
          puts "----"
          puts "Invalid entry.".italic.red
          puts "Please enter ".blue + "Y" + " or ".blue + "N" + " to confirm".blue
          print "Answer".yellow, ": "
          yesno = STDIN.gets.chomp.upcase
        end
      end
    end
  end
end

#  create a cohort (provided that a cohort with that month doesn't exist)
def create_a_cohort(academy)
  include Formatting
  include Validation
  puts long_bar
  puts " "
  puts "Creating a new cohort..".italic.blue
  puts "Enter a valid month to create a new cohort.".bold.blue
  puts "(press return to go back to menu)".italic
  puts "Existing cohorts:".bold.blue
  academy.list_cohort_months
  print "New cohort".yellow, ": "
  new_month = STDIN.gets.chomp
  if new_month != ""  #  else to menu
    #  check if entry is a valid month (Validation mixin) 
    #  and if cohort already exists
    until actual_months.include?(new_month.downcase.to_sym) && 
          !academy.existing_cohorts.include?(new_month.capitalize)
      if academy.existing_cohorts.include?(new_month.capitalize)
        puts "----"
        puts "A ".blue + "#{ new_month.capitalize }".bold.blue + " Cohort already exists".blue
        puts "Enter a different month to create a new Cohort".blue
        puts "(press return to go back to menu)".italic
        print "Enter a month".yellow, ": "
        new_month = STDIN.gets.chomp
        return if new_month == ""  #  else to menu
      else
        puts "----"
        puts "Invalid month.".italic.red
        puts "Enter a valid month to create a new Cohort".blue
        puts "(press return to go back to menu)".italic
        print "Enter a month".yellow, ": "
        new_month = STDIN.gets.chomp
        return if new_month == ""  #  else to menu
      end
    end
    if new_month != ""  #  else to menu
      puts long_bar
      puts " "
      #  create new cohort and add it to the academy
      new_cohort = Cohort.new(new_month.capitalize)
      academy.add_cohort(new_cohort)  #  capitalizes within the method
      puts "Done.".italic.blue
      puts "Existing cohorts:".italic.blue
      #  resorts all cohorts before displaying, permanent sorting
      academy.resort_cohorts_by_month
      academy.list_cohort_months
      puts " "
    end
  end
end

#  redistribute the students evenly, considering the 30-students-per-cohort cap
#  doesn't allow user to delete if there is only one cohort
def delete_a_cohort(academy)
  include Formatting
  include Validation
  if academy.cohorts.count == 1
    puts long_bar
    puts " "
    puts "Operation denied".italic.red
    puts "An academy must have at least one cohort.".blue
    puts " "
  #  also doesn't allow if there are not enough cohorts to house every student
  elsif academy.all_profiles.count / 30 > academy.cohorts.length - 1
    puts long_bar
    puts " "
    puts "Operation denied".italic.red
    puts "An academy must have enough cohorts to house all students.".blue
    puts " "
  else
    puts long_bar
    puts " "
    puts "Deleting a cohort..".italic.blue
    puts "When a cohort is deleted, all members are redistributed amongst all other existing cohorts.".bold.blue
    puts "Are you sure you want to do this? ".italic.blue + "(".blue + " Y " + "/".blue + " N " + ")".blue
    print "Answer".yellow, ": "
    sure = STDIN.gets.chomp
    until ["Y", "y", "N", "n"].include?(sure)
      puts "----"
      puts "Invalid entry.".italic.red
      puts "Please enter ".blue + "Y" + " or ".blue + "N" + " to confirm".blue
      print "Answer".yellow, ": "
      sure = STDIN.gets.chomp
    end
    sure = sure.upcase
    if sure == "Y"
      puts long_bar
      puts " "
      puts "Which cohort would you like to delete? ( ".bold.blue + "enter a month" + " )".bold.blue
      puts "(press return to go back to menu)".italic
      academy.list_cohort_months
      print "Enter a month".yellow, ": "
      target_cohort = STDIN.gets.chomp
      if target_cohort != ""  #  else to menu
        target_cohort = target_cohort.capitalize
        until academy.existing_cohorts.include?(target_cohort.capitalize)
          puts "----"
          puts "Invalid entry.".italic.red
          puts "Please enter a valid cohort month".blue
          puts "(press return to go back to menu)".italic
          academy.list_cohort_months
          print "Enter a month".yellow, ": "
          target_cohort = STDIN.gets.chomp
          break if target_cohort == ""  #  else to menu
        end
        if target_cohort != ""  #  else to menu
          target_cohort = target_cohort.capitalize
          puts long_bar
          puts " "
          puts ("Deleting #{ academy.name }'s #{ target_cohort } cohort. Type ").bold.blue + "confirm".bold + " to confirm ( ".bold.blue + "or 'R' to abort".italic + " )".blue
          print "Answer".yellow, ": "
          confirm = STDIN.gets.chomp.downcase
          until ["confirm", "r"].include?(confirm)
            puts "----"
            puts "Invalid entry.".italic.red
            puts "Type ".blue + "confirm" + " to confirm deletion ( ".blue + "or 'R' to abort".italic + " )".blue
            print "Answer".yellow, ": "
            confirm = STDIN.gets.chomp.downcase
          end
          if confirm == "confirm"
            puts long_bar
            puts " "
            puts "Deleted.".italic.blue
            #  find target cohort
            selected_cohort = academy.cohorts.select { |cohort| cohort.month == target_cohort }.first
            #  collect all other cohorts with space left to accept the defaulting students
            other_cohorts = academy.cohorts.select { |cohort| cohort if cohort.month != target_cohort && cohort.students.length < 30 }
            #  redistribute students:
            #  delete target cohort from academy (not serviced in redistribution)
            academy.cohorts.delete_at(academy.cohorts.index(selected_cohort))
            #  allocate one student to every other cohort in academy.cohorts array
            i = 0
            selected_cohort.students.each { |student| 
              #  push a student to a cohort
              other_cohorts[i].students.push(student)
              #  assign the student their new month attribute
              student.cohort = other_cohorts[i].month
              #  remove a cohort from rotation if the cohort is full after the last reassignment
              other_cohorts.delete_at(other_cohorts.index(other_cohorts[i])) if other_cohorts[i].students.length == 30
              #  end iteration
              i += 1
              #  reset count if all cohorts have been serviced
              i = 0 if i >= other_cohorts.length
            }
            #  display changes
            academy.all_cohorts
          elsif confirm == "r"
            puts "----"
            puts "aborted".italic.red
            puts " "
          end
        end
      end
    end
  end
end

#  for user interaction
def interface(academy)
  include Formatting
  include Validation
  include Saving

  load_students(academy)  #  restore data upon opening
  
  puts long_bar
  puts "Welcome to #{ academy.name }".bold.blue
  puts "Please choose an option".italic.blue
  puts long_bar
  full_menu(academy)
  print "Option".yellow, ": "
  choice = STDIN.gets.chomp

  #  exit if user types end, else invalid if not a menu option
  until choice.downcase == "end"
    until ("1".."13").to_a.include?(choice)
      puts "Invalid choice. Please pick an option from the menu".red
      print "Option".yellow, ": "
      choice = STDIN.gets.chomp
      break if choice.downcase == "end"  #  (inner loop break)
    end
    break if choice.downcase == "end"  #  (outer loop break)

    case choice
    when "1"
      view_all_students(academy)
    when "2"
      view_all_cohorts(academy)
    when "3"
      view_a_cohort(academy)
    when "4"
      view_profiles_by_cohort(academy)
    when "5"
      view_all_profiles(academy)
    when "6"
      add_a_student(academy)
    when "7"
      delete_a_student(academy)
    when "8"
      move_a_student(academy)
    when "9"
      filter_at_cohort_level(academy)
    when "10"
      filter_all_students(academy)
    when "11"
      edit_a_student(academy)
    when "12"
      create_a_cohort(academy)
    when "13"
      delete_a_cohort(academy)
    end

    puts long_bar
    puts "#{ academy.name }".bold.blue
    puts "Please choose another option".italic.blue
    puts long_bar
    full_menu(academy)
    print "Option".yellow, ": "
    choice = STDIN.gets.chomp
  end
  puts long_bar
  save_students(academy)  #  saves before exiting
  goodbye
end

=begin

  #  student instances
  sam = Student.new("Sam", {age: 25, gender: "M", height: 198, country_of_birth: "England", is_disabled: true, registered: true})
  vader = Student.new("Darth Vader", {registered: true})
  hannibal = Student.new("Dr. Hannibal Lecter", {registered: true})
  nurse_ratched = Student.new("Nurse Ratched", {registered: true})
  michael_corleone = Student.new("Michael Corleone", {registered: true})
  alex_delarge = Student.new("Alex DeLarge", {registered: true})
  wicked_witch = Student.new("The Wicked Witch of the West", {registered: true})
  terminator = Student.new("Terminator", {registered: true})
  freddy_krueger = Student.new("Freddy Krueger", {registered: true})
  joker = Student.new("The Joker", {registered: true})
  joffrey = Student.new("Joffrey Baratheon", {registered: true})
  norman_bates = Student.new("Norman Bates", {registered: true})

=end

#  create academy instance
villains_academy = Academy.new("Villains Academy")

=begin

  #  create two cohorts (now saved to csv)
  va_november = Cohort.new("November")
  va_december = Cohort.new("December")

  #  add students to cohorts (now saved)
  va_november.add_student(sam, vader, hannibal, nurse_ratched, michael_corleone, alex_delarge)
  va_december.add_student(wicked_witch, terminator, freddy_krueger, joker, joffrey, norman_bates)

  #  add cohorts to academy (now saved)
  villains_academy.add_cohort(va_november, va_december)

=end

#  start session

interface(villains_academy)