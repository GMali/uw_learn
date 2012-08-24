require_relative '../spec_helper'
 
describe Course do
 
  describe "Upon initializing with no Grade" do
   
    let(:course) { Course.new("CS 341", "11111", nil ) }

    it "should return course name" do
      course.name.must_equal "CS 341"
    end

    it "should return code name" do
      course.code.must_equal "11111"
    end

    it "should have no grade " do
      course.grade.must_be_nil
    end

  end

end
