require 'mechanize'
require 'hpricot'
require 'open-uri'
require 'httparty'
require 'rainbow'

require 'uw_learn/grade'
require 'uw_learn/course'

##
# The UW Learn gem is a tiny web crawler for University of Waterloo students.
# It grabs their grades, and prints them out in the terminal.
# 
# @author Gaurav Mali <hello@gauravmali.com>
# @version 1.0.1
# 
class Uwlearn
  
  ##
  # Creates a new instance of UW Learn account.
  # Proceeds to login and scrape grades.
  #
  # @param [String] The student username
  # @param [String] The student password
  #
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

  ##
  # @!method login
  #   The username that the account was logged in with
  #   @return [String] The username
  #   
  def login
    @user_login
  end

  ##
  # @!method print_courses
  #   Prints out the names of all the courses
  #  
  def print_courses
    @learn_courses.each do |course|
      puts course.name.foreground(:yellow)
    end
  end

  ##
  # @!method courses
  #   The array of the user's courses in string format
  #   @return [Array] The user's courses
  #  
  def courses
    @learn_courses
  end

  ##
  # @!method print_grades
  #   Prints out every course's name and the grades registered with it
  #  
  def print_grades
    @learn_grades.each do |grade|
      puts grade.which_course?.foreground(:yellow) + ": ".foreground(:yellow)
      puts grade.summary
    end
  end

  ##
  # @!method grades
  #   The array of user's grades in string format
  #   @return [Array] The user's grades
  #  
  def grades
    @learn_grades
  end

  private

  ##
  # learn_url
  #   Holding on to the learn URL for easy change. You may try simply changing this URL to a different University's URL.
  #   But remember, this is a hacky scrape job. Don't be surprised if things break.
  #  
  def learn_url
    "http://learn.uwaterloo.ca"
  end 

  ##
  # course_url
  #   Just in case if D2L decides to change their markup, you know where to look for (hopefully) a quick fix.
  #  
  def course_url
    "/d2l/lp/ouHome/home.d2l?ou="
  end

  ##
  # course_html
  #   Just in case if D2L decides to change their markup, you know where to look for (hopefully) a quick fix.
  #  
  def course_html
    "//ul[@id='z_w']//div[@class='dco_c']//a"
  end

  ##
  # error_html
  #   Just in case if D2L decides to change their markup, you know where to look for (hopefully) a quick fix.
  #  
  def error_html
    "//div[@class='error']"
  end

  ##
  # start
  #   The starting point of crawling. Calls the authentication and scraping methods.
  #
  def start
    # Very important object. Don't lose or overwrite it. Required for scraping.
    agent = Mechanize.new

    begin
      # Authenticates in this method call.
      links = authenticate agent
      # Scrapes in this method call.
      acquire links, agent

      puts "Grades acquired.".foreground(:cyan)
    rescue Exception => e
      puts e.message
    rescue Mechanize::ResponseCodeError, Net::HTTPNotFound
      puts "Looks like the website has changed. Contact the developer to fix this issue.".foreground(:red)
    end

  end

  ##
  # authenticate
  #   Logs in using the user credentials.
  #   Returns an array of anchor(<a href=""></a>) elements of course links.
  #
  def authenticate(agent)
    puts "Authenticating ".foreground(:cyan) + @user_login.foreground(:cyan) + "...".foreground(:cyan)

    # Login form submission
    page = agent.get learn_url
    form = page.forms.first
    form.username = @user_login
    form.password = @user_passw
    page = agent.submit form

    course_links = page.search course_html
    login_error = page.search error_html

    if login_error.empty? and course_links.empty?
      raise "D2l has changed. Please contact the developer.".foreground(:red)
    elsif !login_error.empty?
      raise "Couldn't authenticate. Please try again.".foreground(:red)
    end
    
    course_links
  end

  ##
  # acquire
  #   Extracts the course name and code for further scraping of grades.
  #   The scraping occurs in the initialization of the grade objects.
  #   Stores the grades and courses in two different arrays: @learn_courses and @learn_grades.
  #
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

end # Uwlearn
