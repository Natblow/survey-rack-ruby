require 'rack'
require 'cgi'
require 'csv'
require_relative 'template'
require_relative 'route'
require_relative 'survey'
require_relative 'email'

class App < Template

  def call(env)
    @request = Rack::Request.new(env)
    @request_cookies = Rack::Utils.parse_cookies(env)
    @headers = {}
    @route = Route.new(env)
    status = @route.name =~ /^\d\d\d$/ ? @route.name.to_i : 200

    if @request.path == "/form" && @request.post? == true
      process_survey_submission
    end
    [status, @headers, [erb(@route.name)]]
  end

  private

  def process_survey_submission
    if submission_is_not_valid
      @route.name = :form_errors
    elsif email_has_already_been_submitted
      @route.name = :already_submitted
      set_cookie_to_remember_this
    else
      save_to_csv_file
      send_email_verification
      @route.name = :thank_you
      set_cookie_to_remember_this
    end
  end

  def cookies_has_already_been_set
    @request_cookies.has_key? 'survey_submitted'
  end

  def submission_is_not_valid
    @request.params.empty? || !@request.params["email"] =~ /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  end

  def email_has_already_been_submitted
    Survey.email_exist?(@request.params["email"]) == true
  end

  def set_cookie_to_remember_this
    Rack::Utils.set_cookie_header!(@headers, ['survey_submitted'].first, true)
  end

  def save_to_csv_file
    Survey.create_answers(@request.params)
  end

  def send_email_verification
    ValidationMail.send_to(@request.params["email"])
  end
end
