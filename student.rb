require './person'

class Student < Person
  def initialize (classroom, name = 'Unknown', age, parent_permission: true)
    super(age, name, parent_permission)
    @classroom = classroom
  end

  def play_today
    "¯\(ツ)/¯"
  end
end