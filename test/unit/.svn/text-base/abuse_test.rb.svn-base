require 'test_helper'

class AbuseTest < ActiveSupport::TestCase
  
  test "should create abuse record for articles" do
      [articles[:one], comments[:one], stories[:one]].each do |object|
      report_abuse object      
      assert_not_nil object.abuses
    end
  end
end
