require 'uri'
require 'rack'

class Route

    ROUTES = {
      "GET" => {
        "/" => :survey,
        "/survey_report" => :survey_report,
        "/thank_you" => :thank_you,
        "/already_submitted" => :already_submitted,
        "/form_errors" => :form_errors,
        "/confirmation" => :confirmation,
        "/success" => :success,
        "/failure" => :failure,
      },
      "POST" => {
        "/thank_you" => :thank_you,
        "/already_submitted" => :already_submitted,
        "/form" => :form,
      }
    }

    attr_accessor :name

    def initialize(env)
      @request = Rack::Request.new(env)
      http_method = @request.request_method
      path = @request.path
      @name = ROUTES[http_method] && ROUTES[http_method][path]
    end

    def name
      @name || "404"
    end
  end
