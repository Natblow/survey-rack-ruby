require "test/unit"
require "rack/test"
require_relative "../app"
require 'erb'

class AppTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    app = lambda { |env| [200, {'Content-Type' => 'text/html'}, ['All responses are OK']] }
    builder = Rack::Builder.new
    builder.run app
  end

  def set_request_headers
    header 'Accept-Charset', 'utf-8'
    get '/'

    assert last_response.ok?
    assert_equal last_response.body, 'All responses are OK'
  end

  def test_create_survey
    get '/'
    assert last_response.ok?
    assert_equal last_response.body, 'All responses are OK'

    post '/form', {
      "user_name" => 'one',
      "email" => 'email@one.ca',
      "rate" => '1',
      "usefulness" => '2',
      "clarity" => '2',
      "speed" => '1',
      "answered" => '4',
      "how_comfortable" => '1',
      "assignements" => '4',
      "improvements" => 'more details'
    }
    assert last_response.ok?
    assert last_response.set_cookie "already_submitted", :value => true
    assert_equal last_response.body, 'All responses are OK'

    get '/thank_you'
    assert last_response.ok?
    assert_equal last_response.body, 'All responses are OK'
  end

  def test_invalid_survey
    post '/form', {
      "user_name" => 'one',
      "email" => 'email@one.ca',
      "rate" => nil,
      "usefulness" => nil,
      "clarity" => nil,
      "speed" => '1',
      "answered" => '4',
      "how_comfortable" => '1',
      "assignements" => '4',
      "improvements" => 'more details'
    }
    assert last_response.ok?
    assert_equal last_response.body, 'All responses are OK'

    get '/form_errors'
    assert last_response.ok?
    assert_equal last_response.body, 'All responses are OK'
  end

  def test_wrong_email_format
    post '/form', params = {
      "user_name" => 'one',
      "email" => 'emailone.ca',
      "rate" => nil,
      "usefulness" => nil,
      "clarity" => nil,
      "speed" => '1',
      "answered" => '4',
      "how_comfortable" => '1',
      "assignements" => '4',
      "improvements" => 'more details'
    }
    assert !params['email'].match?(/\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i)
    assert last_response.ok?
    assert_equal last_response.body, 'All responses are OK'

    get '/form_errors'
    assert last_response.ok?
    assert_equal last_response.body, 'All responses are OK'
  end

  def test_already_submitted
    get '/already_submitted'
    assert last_response.ok?
    assert_equal last_response.body, 'All responses are OK'
  end

  def test_survey_result
    get '/survey_result'
    assert last_response.ok?
    assert_equal last_response.body, 'All responses are OK'
  end
end
