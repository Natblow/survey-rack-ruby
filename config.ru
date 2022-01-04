#!/usr/bin/env ruby
require 'rack'
require 'rack-mini-profiler'
load 'admin.rb'
load 'app.rb'
load 'email.rb'
load 'confirmation.rb'

use Authentication, "survey_result" do |username, password|
  (username == 'king') && (password == 'queen')
end
use Rack::Static, :urls => ["/database", "/views/js","/views/css","/views/images"]
use Rack::ContentType
use Rack::Reloader
use Rack::MiniProfiler
use EmailConfirmation
run App.new
