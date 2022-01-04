require 'rack'
require_relative 'survey'
require_relative 'template'

class EmailConfirmation < Template

  def initialize(app)
      @app = app
   end

  def call(env)
    request = Rack::Request.new(env)
    headers = {}
    route = Route.new(env)
    status = route.name =~ /^\d\d\d$/ ? route.name.to_i : 200

    if request.path.match(/confirmation/)
      token = request.path.split("/confirmation/").last
      email = Survey.find_email_match(token)
      if email == nil || token == nil
        [status, headers, [erb("/failure")]]
      end
      Survey.update_csv_file(email, token)
        [status, headers, [erb("/success")]]
    else
      @app.call(env)
    end
  end
end
