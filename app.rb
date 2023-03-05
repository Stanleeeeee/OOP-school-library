require './teacher'
require './student'
require './book'
require './rental'
require 'json'

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
      save_files
      puts 'Thank you for using this app! 👍😊'
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
    print 'Has parent permission? [Y/N]'
    permission = gets.chomp.upcase
    case permission
    when 'Y'
      permission = true
    when 'N'
      permission = false
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
    print 'ID of person: '
    id = gets.chomp.to_i
    rentals = @rentals.select { |rental| rental.person.id == id }
    p rentals
    rentals.each { |item| puts "Date: #{item.date}, Book: #{item.book.title}, by: #{item.book.author}" }
    run
  end

  # rubocop:disable Style/FileWrite
  def save_files
    File.open('books.json', 'w') { |file| file.write(@books.to_json) }
    File.open('people.json', 'w') { |file| file.write(@people.to_json) }
    File.open('rentals.json', 'w') { |file| file.write(@rentals.to_json) }
    puts 'The file saved successfully 👍✅'
  end
  # rubocop:enable Style/FileWrite

  ## First of all we need to def a method so we can call it while we run our app.
  # next we have to check if a file exist? maybe we run our app for the first time.
  # and id our file exists so we load the file

  # rubocop:disable Style/GuardClause
  def open_files
    if File.exist?('books.json')
      JSON.parse(File.read('books.json')).map do |book|
        load_book(book)
      end
    end
    if File.exist?('people.json')
      JSON.parse(File.read('people.json')).map do |person|
        load_person(person)
      end
    end
    if File.exist?('rentals.json')
      JSON.parse(File.read('rentals.json')).map do |rental|
        load_rental(rental)
      end
    end
  end
  # rubocop:enable Style/GuardClause

  # while we load our file we need to create a new object for that file class
  # we should create the object from givven class and give it the arg from file hashs
  # after we created new obj of class we need to push it our array.
  def load_book(book)
    book_object = create_book_object(book)
    @books << book_object
  end

  def load_person(person)
    person_object = create_person_object_based_on_type(person)
    @people << person_object
  end

  def load_rental(rental)
    book = rental['book']
    book_object = create_book_object(book)
    person = rental['person']
    person_object = create_person_object_based_on_type(person)
    date = rental['date']
    rental_object = Rental.new(date, book_object, person_object)
    @rentals << rental_object
  end

  # we need to create a new object for each class and give it the arg from file hashs
  def create_book_object(book)
    Book.new(book['title'], book['author'])
  end

  # For person because we have students and teachers first we check the class.
  def create_person_object_based_on_type(person)
    if person['json_class'] == 'Teacher'
      create_teacher_object(person)
    else
      create_student_object(person)
    end
  end

  def create_teacher_object(person)
    teacher_object = Teacher.new(person['specialization'], person['age'], person['name'],
                                 parent_permission: person['parent_permission'])
    teacher_object.id = person['id'].to_i
    teacher_object
  end

  def create_student_object(person)
    student_object = Student.new(nil, person['age'], person['name'], parent_permission: person['parent_permission'])
    student_object.id = person['id'].to_i
    student_object
  end
end
