require 'mechanize'
require 'hpricot'
require 'open-uri'

##
# The grade object scrapes and holds on the grades of a particular course
# 
# @todo Store the grades in a hash with key as a string and value as a number of some sort
# 
# @author Gaurav Mali <hello@gauravmali.com>
# @version 1.0.1
# 
class Grade
  
  ##
  # Creates a new instance of a course grade.
  # Proceeds to scrape grades and store it in @grades.
  #
  # @param name [String] The course name
  # @param code [String] The course code
  # @param agent [Object] The Mechanize object for scraping
  #
  def initialize(name, code, agent)
    @course_name = name
    @course_code = code
    @grades = Array.new
    
    get_grades agent
  end
  
  ##
  # A way to find out which course a grade belongs to.
  # 
  # @return [String] The course name
  # 
  def which_course?
    @course_name
  end

  ##
  # Returns a summary of grades for this particular course.
  # If no grades were uploaded, user is notified so.
  # 
  # @return [Array] The grades in string format.
  # 
  def summary
    if @grades.empty?
      ("Sorry the instructor for " + @course_name + " has not uploaded any marks yet").foreground(:red)
    else
      @grades
    end
  end

  private

  ##
  # Just in case if D2L decides to change their markup, you know where to look for (hopefully) a quick fix.
  # 
  def grades_url
    "https://learn.uwaterloo.ca/d2l/lms/grades/my_grades/main.d2l?ou=" + @course_code
  end

  ##
  # Are there any grades for this course?
  # Returns true(yes) or false(no)
  # 
  def grades?(report)
    report.xpath("//td[@class='d_gempty']").to_s == ""
  end

  ##
  # Are there any marks in this table of grades?
  # We don't want rows with no data in them.
  #   
  # Returns true(yes) or false(no)
  # 
  def has_mark?(row)
    # Alternatively:
    # !(row/"label").blank?
    (row/"label").to_s != ""
  end

  ##
  # Where actual scraping occurs
  # 
  def get_grades(agent)
    page = agent.get grades_url
    report = page.parser
    
    # Search for all rows that have both 'strong' and 'label' elements
    if grades? report 
      rows = report.xpath("//table[@id='z_c']/tr")

      if rows.empty?
        raise "ERROR: Failed parsing at the rows. Please contact the developer.".foreground(:red)
      end
      
      rows.each do |row|
        if has_mark? row
          mark = (row/"label").last.inner_html.to_s
          category = (row/"strong").inner_html.to_s
    
          # Storing it as a string for now. Future releases will be different.
          @grades << (category + " => " + mark)
        end      
      end

    end

  end

end # Grade
