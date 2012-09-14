##
# The course object represents a typical course a student would register for.
# 
# @todo Add more featuers such as course news and dates
# 
# @author Gaurav Mali <hello@gauravmali.com>
# @version 1.0.1
# 

class Course
  ##
  # @!attribute [r] name
  #   @return [String] the course name
  attr_reader :name

  ##
  # @!attribute [r] code
  #   @return [String] the course code
  attr_reader :code

  ##
  # @!attribute [r] grade
  #   @return [Object] the grades of the particular course
  attr_reader :grade

  ##
  # Creates a new instance of a course object.
  # Simply holds on to string values and the grade object.
  #
  # @param [String] The course name
  # @param [String] The course code
  # @param [Object] The course grades
  #
  def initialize(name, code, grade)
    @name = name
    @code = code
    @grade = grade
  end

end # Course
