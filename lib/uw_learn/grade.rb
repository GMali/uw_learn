require 'mechanize'
require 'hpricot'
require 'awesome_print'
require 'open-uri'

class Grade

  def initialize(name, code, agent)
    @course_name = name
    @course_code = code
    @grades = Array.new
    
    get_grades agent
  end

  def which_course?
    @course_name
  end

  def summary
    if @grades.empty?
      ("Sorry the instructor for " + @course_name + " has not uploaded any marks yet").foreground(:red)
    else
      @grades
    end
  end

  private

  def grades_url
    "https://learn.uwaterloo.ca/d2l/lms/grades/my_grades/main.d2l?ou=" + @course_code
  end

  def grades?(report)
    report.xpath("//td[@class='d_gempty']").to_s == ""
  end

  def has_mark?(row)
    (row/"label").to_s != ""
  end

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
    
          @grades << (category + " => " + mark)
        end      
      end

    end

  end

end
