require_relative 'test_helper'
require 'test/unit'
require 'rack/test'
require 'mocha/test_unit'
require_relative '../email'

class EmailTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def test_that_it_sends_email
    ValidationMail.expects(:send_to).with(any_parameters).returns('email sent')
    assert_equal('email sent', ValidationMail.send_to('natesbell@gmail.com'))
  end
end
