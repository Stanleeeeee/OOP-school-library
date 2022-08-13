require './teacher'
require './student'
require './book'
require './rental'

class App
  attr_accessor :people

  def initialize
    @books = []
    @rentals = []
    @people = []
  end

  def menu
    puts ''
    puts 'Please choose an option by entering a number:'
    puts '1 - List all books 📚'
    puts '2 - List all people 🧑🏼‍🤝‍🧑🏻'
    puts '3 - Create a person 🧑‍🦱'
    puts '4 - Create a book 📘'
    puts '5 - Create a rental 📦'
    puts '6 - List all rentals for a given id 📦🆔'
    puts '7 - Exit 🚪'
  end

  # rubocop:disable Metrics/CyclomaticComplexity
  def option_checker(answer)
    case answer
    when 1
      list_books
    when 2
      list_people
    when 3
      create_person
    when 4
      create_book
    when 5
      create_rental
    when 6
      list_rental
    when 7
      'Thank you for using this app! 👍😊'
    else
      puts '⚠️ Wrong input'
      run
    end
  end
  # rubocop:enable Metrics/CyclomaticComplexity

  def run
    menu
    answer = gets.chomp.to_i
    option_checker(answer)
  end

  def list_books
    puts 'Listing all books from library'
    @books.each do |book|
      puts "Book Title: '#{book.title}', Book Author: '#{book.author}'"
    end
    run
  end

  def list_people
    puts 'listing all people'
    @people.each do |person|
      puts "[#{person.class.name}] ID: #{person.id}, Name: #{person.name}, Age: #{person.age}"
    end
    run
  end

  def create_person
    puts 'Do you want to create a student (1), or a teacher (2)? [Input the number]: '
    answer = gets.chomp.to_i

    case answer
    when 1
      create_student
    when 2
      create_teacher
    else
      puts '⚠️ Please enter a vaild input(1, 2)'
    end

    run
  end

  def create_student
    print 'Age: '
    age = gets.chomp.to_i
    print 'Name: '
    name = gets.chomp
    print 'Has parent permission? [Y/N]'
    permission = gets.chomp.upcase
    case permission
    when 'Y'
      permission = true
    when 'N'
      permission = false
    end

    student = Student.new(nil, age, name, parent_permission: permission)
    @people.push(student)
    puts 'A student created successfully 👋👨‍🎓'
  end

  def create_teacher
    print 'Specialization: '
    specialization = gets.chomp
    print 'Age: '
    age = gets.chomp.to_i
    print 'Name: '
    name = gets.chomp
  end

    teacher = Teacher.new(specialization, age, name, parent_permission: permission)
    @people.push(teacher)
    puts 'A teacher created successfully 🧑‍🏫👋'
  end

  def create_book
    print 'Title: '
    title = gets.chomp
    print 'Author: '
    author = gets.chomp
    book = Book.new(title, author)
    @books.push(book)
    puts 'A book created successfully 📘👋'
    run
  end

  def create_rental
    puts 'Select a book from following list by number (not ID):'
    @books.each_with_index do |book, idx|
      puts "#{idx}) Title: '#{book.title}', Author: '#{book.author}'"
    end
    selected_id_book = gets.chomp.to_i
    print 'Date: '
    date = gets.chomp.to_i
    puts 'Select a person from following list by number (not ID)'
    @people.each_with_index do |person, idx|
      puts "#{idx}) [#{person.class.name}] Name: '#{person.name}', ID: #{person.id}, Age: #{person.age}"
    end
    selected_id_person = gets.chomp.to_i

    rental = Rental.new(date, @books[selected_id_book], @people[selected_id_person])
    @rentals.push(rental)
    puts 'Rental created successfully 👋📦'
    run
  end

  def list_rental
    puts
    person
    puts 'Choose person ID: '
    entry = gets.chomp.to_i

    puts 'Rental'.upcase
    puts
    @people.each do |person|
      next unless person.id == entry

      @all_rentals.each do |rental|
        puts "Rental date: #{rental.date} - #{rental.book} by #{rental.person}"
      end
    end
  end
end
