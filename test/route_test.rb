require_relative 'test_helper'
require_relative '../route'

class RouteTest < Test::Unit::TestCase
  def test_that_it_returns_404_for_undefined_paths
    env = {
      "PATH_INFO" => "/foo",
      "REQUEST_METHOD" => "GET"
    }
    assert_equal "404", Route.new(env).name, "/foo should return status 404"
  end

  def test_that_it_returns_valid_path
    env = {
      "PATH_INFO" => "/",
      "REQUEST_METHOD" => "GET"
    }
    assert_equal :survey, Route.new(env).name, "/ should return status 200"
  end
end
