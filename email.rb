require 'net/smtp'
require 'rack'
require 'securerandom'
require 'json'

class ValidationMail < Net::SMTP

  def self.send_to(user_email)
    secure_token = SecureRandom.alphanumeric(10)
    match_email_with_token(user_email,secure_token)
    smtp = Net::SMTP.new 'smtp.gmail.com', 587
    message = ValidationMail.message(user_email, secure_token)

      smtp.enable_starttls
      smtp.start('localhost','surveyrackapp@gmail.com', 'RubyOnRack', :plain) do |smtp|
                        smtp.send_message message, 'surveyrackapp@gmail.com', user_email
                      end
  end

  private

  def self.match_email_with_token(user_email, secure_token)
    if File.zero?(JSON_DATA_PATH)
      write_new_json_data(user_email,secure_token)
    else
      update_json_data(user_email,secure_token)
    end
  end

  def self.write_new_json_data(user_email, secure_token)
    json_hash = JSON.generate({"#{secure_token}":"#{user_email}"})
    File.open(JSON_DATA_PATH,"wb") do |f|
      f.write(JSON.pretty_generate(json_hash))
    end
  end

  def self.update_json_data(user_email, secure_token)
    json_data = File.read(JSON_DATA_PATH)
    json_hash = JSON.parse(JSON.parse(json_data))
    new_json_hash = json_hash.merge! "#{secure_token}"=>"#{user_email}"
    new_json = new_json_hash.to_json
    File.open(JSON_DATA_PATH,"wb") do |f|
      f.write(JSON.pretty_generate(new_json))
    end
  end

  def self.message(user_email, secure_token)
    <<-MESSAGE_END.gsub(/^\s+/,'')
    From: SurveyRackApp <surveyrackapp@gmail.com>
    To: Survey Applicant <#{user_email}>
    MIME-Version: 1.0
    Content-type: text/html
    Subject: Please confirm your email
    <head>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <!-- Bootstrap CSS -->

    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css" integrity="sha384-9aIt2nRpC12Uk9gS9baDl411NQApFmC26EwAOH8WgZl5MYYxFfc+NcPb1dKGj7Sk" crossorigin="anonymous">
    </head>
    <body>

    <center><h1><b> Please confirm your email </b></h1><br></center>
    Thank you for submitting the survey ! In order to validate your submission,<br>
    please confirm your email simply by clicking <a href="http://localhost:9292/confirmation/#{secure_token}">HERE</a>.<br><br>
    Best regards,<br>
    SurveyRackApp.
    </body>
    MESSAGE_END
  end
end
