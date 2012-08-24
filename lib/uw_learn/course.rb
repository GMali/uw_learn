#require './grade'

class Course

  def initialize(name, code, grade)
    @course_name = name
    @course_code = code
    @course_grade = grade
  end

  def name
    @course_name
  end

  def code
    @course_code
  end

  def grade
    @course_grade
  end

end
