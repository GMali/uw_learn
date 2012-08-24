require 'mechanize'
require 'hpricot'
require 'awesome_print'
require 'open-uri'
require 'httparty'
require 'rainbow'

require './lib/uw_learn/grade'
require './lib/uw_learn/course'

class Uwlearn

  def initialize(login, password)
    @user_login = login
    @user_passw = password

    @learn_courses = Array.new
    @learn_grades  = Array.new

    if @user_login.nil? || @user_passw.nil?
      raise "Couldn't authenticate. Please try again.".foreground(:red)
    end

    start
  end

  def login
    @user_login
  end

  def print_courses
    @learn_courses.each do |course|
      puts course.name.foreground(:yellow)
    end
  end

  def courses
    @learn_courses
  end

  def print_grades
    @learn_grades.each do |grade|
      puts grade.which_course?.foreground(:yellow) + ": ".foreground(:yellow)
      puts grade.summary
    end
  end

  def grades
    @learn_grades
  end

  private

  def learn_url
    "http://learn.uwaterloo.ca"
  end 

  def course_url
    "/d2l/lp/ouHome/home.d2l?ou="
  end

  def course_html
    "//ul[@id='z_bl']//div[@class='dco_c']//a"
  end

  def start
    agent = Mechanize.new

    begin
      links = authenticate agent
      acquire links, agent
      puts "Grades acquired.".foreground(:cyan)
    rescue Exception => e
      puts e.message  
      #puts e.backtrace.inspect
    rescue Mechanize::ResponseCodeError, Net::HTTPNotFound
      puts "Looks like the website has changed. Contact the developer to fix this issue.".foreground(:red)
    end

  end

  def authenticate(agent)
    puts "Authenticating ".foreground(:cyan) + @user_login.foreground(:cyan) + "...".foreground(:cyan)

    page = agent.get learn_url
    form = page.forms.first
    form.username = @user_login
    form.password = @user_passw
    page = agent.submit form

    course_links = page.search course_html
    if course_links.empty?
      raise "Couldn't authenticate. Please try again.".foreground(:red)
    end
    
    course_links
  end

  def acquire(links, agent)
    puts "Acquiring data...".foreground(:cyan)

    links.each do |link|
      name   = link.inner_html.to_s
      code   = link["href"].to_s.sub course_url, ""

      if name == "" || code == ""
        raise "Incorrect parsing. Please contact the developer.".foreground(:red)
      end
      
      grade = Grade.new name, code, agent
      course = Course.new name, code, grade

      @learn_courses << course
      @learn_grades  << grade
    end 
  end

end
