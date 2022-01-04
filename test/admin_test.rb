require_relative 'test_helper'
require 'test/unit'
require 'rack/test'
require_relative '../admin'

config = File.join(File.dirname(__FILE__), '../config.ru')
OUTER_APP = Rack::Builder.parse_file(config).first

class AdminTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    OUTER_APP
  end

  def test_that_admin_page_is_secured
    get '/survey_result'
    assert(Authentication.new("king","queen"))
  end
end
