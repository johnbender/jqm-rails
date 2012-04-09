require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "on creation status should be out" do
    email = "john.m.bender@gmail.com"
    User.new(:email => email,
             :password => "foo",
             :password_confirmation => "foo").save!

    assert_equal(User.find_by_email(email).status, User::STATUSES.first)
  end
end
