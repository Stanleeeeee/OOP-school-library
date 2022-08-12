require './nameable'
require './rental'

class Person < Nameable
  def initialize(age, name = 'Unknown', parent_permission = true)
    super()
    @id = Random.rand(1...1000)
    @name = name
    @age = age
    @parent_permission = parent_permission
    @rentals = []
  end

  attr_reader :id

  attr_accessor :name, :age, :parent_permission, :rentals

  def of_age?
    @age >= 18
  end
  private :of_age?

  def can_use_services?
    of_age? || @parent_permission
  end

  def correct_name
    @name
  end
end
