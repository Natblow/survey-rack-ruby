require_relative 'test_helper'
require 'test/unit'
require 'rack/test'
require 'mocha/test_unit'
require_relative '../template'


class TemplateTest < Test::Unit::TestCase
  include Rack::Test::Methods

    def test_that_it_renders_page
      Template.expects(:erb).with(any_parameters).returns("/survey")
      assert_equal("/survey",Template.erb(:survey))
    end
end
