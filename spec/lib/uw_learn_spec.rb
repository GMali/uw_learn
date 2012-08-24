require_relative '../spec_helper'
 
describe Uwlearn do
 
  describe "Upon initializing" do
   
    let(:student) { Uwlearn.new("LOGIN", "PASSWORD") }

    it "should return login name" do
      student.login.must_equal "LOGIN"
    end

  end

end
