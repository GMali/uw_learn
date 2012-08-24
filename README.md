#  UW Learn

Tiny web crawler for University of Waterloo students. Gets student grades from University of Waterloo's D2L website. http://learn.uwaterloo.ca

Inspired by: https://github.com/phleet/UWAngel-CLI

Currently a pre-release

## Installation
    $ [sudo] gem install uw_learn --pre

## Usage
    require 'uw_learn'

    student = Uwlearn.new "LOGIN", "PASSWORD"
    student.print_grades
    student.print_courses

#####Alternatively, using the executable
    $ uw_learn "LOGIN" "PASSWORD"

## Testing
To run the tests:

1. Open spec/lib/uw_learn_spec.rb
2. Enter your own username and password
3. Run command:
<pre>$ rake </pre>

