require './teacher'
require './student'
require './book'
require './rental'
require 'json'

File.open('books.json') { |file| @books = JSON.parse(file.read) }
puts @books
File.open('people.json') { |file| @people = JSON.parse(file.read) }
puts @people
File.open('rentals.json') { |file| @rentals = JSON.parse(file.read) }
puts @rentals
