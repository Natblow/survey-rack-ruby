require 'csv'
require 'chartkick'
require 'rack'
require_relative 'survey'

LAYOUT_FILE = File.join(File.dirname(__FILE__), "/views/application.html.erb")

class Template
  include Chartkick::Helper

  class TemplateRenderer
  end

  def erb(page, local = {})
    @local = local
    @page = page
    file = File.join(File.dirname(__FILE__), "/views/#{page}.html.erb")
    @layout_template = File.read(LAYOUT_FILE)
    @inner_template = File.read(file)
    render(page)
  end

  def render(page)
    layout = ERB.new(@layout_template)
    inner = ERB.new(@inner_template)
    layout.def_method(TemplateRenderer, 'render', page.to_s)
    result = TemplateRenderer.new.render do
      inner.result(binding)
    end
    result
  end

  def answers_rate
    @answers_rate = Survey.answers_rate
  end

  def answers_usefulness
    @answers_usefulness = Survey.answers_usefulness
  end

  def answers_answered
    @answers_answered = Survey.answers_answered
  end

  def answers_clarity
    @answers_clarity = Survey.answers_clarity
  end

  def answers_speed
    @answers_speed = Survey.answers_speed
  end

  def answers_how_comfortable
    @answers_how_comfortable = Survey.answers_how_comfortable
  end

  def answers_assignements
    @answers_assignements = Survey.answers_assignements
  end

  def answers_improvements
    @answers_improvements = Survey.answers_improvements
  end
end
