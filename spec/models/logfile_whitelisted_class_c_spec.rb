require "#{File.dirname(__FILE__)}/../spec_helper"
describe LogfileWhitelistedClassC do
  fixtures :logfile_whitelisted_class_cs

  before do
    @valid_attributes = {:classc => "20.30.40"}
  end

  it "should create a new instance given valid attributes" do
    LogfileWhitelistedClassC.create!(@valid_attributes)
  end

  should_validate_presence_of :classc
  should_validate_uniqueness_of :classc
end
