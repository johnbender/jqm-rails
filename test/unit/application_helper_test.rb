require 'test_helper'

class ApplicationHelperTest < ActiveSupport::TestCase
  class Foo
    include UsersHelper
  end

  setup do
    @instance = Foo.new
    @request = mock("request")
    @request.stubs(:parameters).returns({})
    @instance.stubs(:request).returns(@request)
  end

  test "differentiate_path should forward args and add attempt to send" do
    @instance.expects(:send).with(:users_path, "foo", {:attempt => 1})
    @instance.differentiate_path(:users_path, "foo")
  end

  test "differentiate_path increments attempts url param when present" do
    @instance.expects(:send).with(:users_path, "foo", {:attempt => 2})
    @request.expects(:parameters).returns("attempt" => "1")
    @instance.differentiate_path(:users_path, "foo")
  end
end
