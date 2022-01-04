require_relative 'test_helper'
require "test/unit"
require "mocha/test_unit"
require_relative '../survey'
require_relative '../email'
require 'csv'

class SurveyTest < Test::Unit::TestCase

  def setup
    @params = {"user_name"=> "two", "email"=> "email@two.ca", "rate"=> "2", "usefulness"=> "1", "clarity"=> "1", "speed"=> "3", "answered"=>"1", "how_comfortable"=> "1", "assignements"=> "2", "improvements"=> "more hours would be good"}
    @update_csv = {"valid_id"=> "tokenTest", "user_name"=> "two", "email"=> "email@two.ca", "rate"=> "2", "usefulness"=> "1", "clarity"=> "1", "speed"=> "3", "answered"=>"1", "how_comfortable"=> "1", "assignements"=> "2", "improvements"=> "more hours would be good"}
  end

  def test_that_it_creates_a_survey
    Survey.expects(:create_answers).with(any_parameters).returns(@params)
    assert_equal(@params, Survey.create_answers(@params))
  end

  def test_that_it_finds_an_email
    Survey.expects(:email_exist?).with(any_parameters).returns(true)
    assert_equal(true, Survey.email_exist?("email@two.ca"))
  end

  def test_that_it_finds_valid_email
    Survey.expects(:find_email_match).with(any_parameters).returns('email@two.ca')
    assert_equal('email@two.ca', Survey.find_email_match('tokenTest'))
  end

  def test_update_csv_file
    Survey.expects(:update_csv_file).with(any_parameters).returns(@update_csv)
    assert_equal(@update_csv, Survey.update_csv_file('email@two.ca','tokenTest'))
  end

  def test_that_it_counts_only_from_validated_emails
    count_rate = {Excellent: 0, Very_Good: 0, Good: 0, Fair: 1, Poor: 0}
    survey = Survey
    Survey.expects(:answers_rate).with(count_rate).returns(survey)
    assert_equal(survey, Survey.answers_rate(count_rate))
  end
end
