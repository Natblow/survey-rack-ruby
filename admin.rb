require 'rack'

class Authentication < Rack::Auth::Basic
  def call(env)
    if (env['PATH_INFO'] =~ /survey_report/)
      super
    else
      @app.call(env)
    end
  end
end
