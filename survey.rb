require 'csv'
require 'json'

CSV_DATA_PATH = File.join(File.dirname(__FILE__), '/database/survey_results.csv')
JSON_DATA_PATH = File.join(File.dirname(__FILE__), '/database/email_list.json')


class Survey
  attr_reader :user_name, :email, :rate, :usefulness, :clarity, :speed,
  :answered, :how_comfortable, :answered, :how_comfortable, :assignements, :improvements

@survey_result = CSV.open(CSV_DATA_PATH, col_sep: ",").reject { |row| row[0] == nil }.transpose[3..9]

  def self.create_answers(params)
    @user_name = params['user_name']
    @email = params['email']
    @rate = params['rate']
    @usefulness = params['usefulness']
    @clarity = params['clarity']
    @speed = params['speed']
    @answered = params['answered']
    @how_comfortable = params['how_comfortable']
    @assignements = params['assignements']
    @improvements = params['improvements']
    answers = [nil,@user_name,@email,@rate,@usefulness,@clarity,@speed,@answered,@how_comfortable,@assignements,@improvements]
    headers = []
    if File.zero?(CSV_DATA_PATH)
      headers = ['valid_id', 'user_name', 'email', 'rate', 'usefulness', 'clarity', 'speed', 'answered', 'how_comfortable', 'assignements', 'improvements']
    end
    CSV.open(CSV_DATA_PATH, "a+") do |csv|
        csv << headers unless headers.empty?
        csv << answers
    end
  end

  def self.email_exist?(email)
    csv = CSV.read(CSV_DATA_PATH, headers: true)
    csv.find {|column| column['email'] == email} ? true : false
  end

  def self.find_email_match(token)
    json_data = File.read(JSON_DATA_PATH)
    email_list = JSON.parse(JSON.parse(json_data))
    email_list[token] == nil ? nil : email_list[token]
  end

  def self.update_csv_file(email, token)
    create_tmp_csv_file(email, token)
    delete_old_csv_and_rename_tmp_csv
  end

  def self.answers_rate
    { Excellent: count_5[0][1], Very_Good: count_4[0][1], Good: count_3[0][1], Fair: count_2[0][1], Poor: count_1[0][1] }
  end

  def self.answers_usefulness
    { Extremely_useful: count_5[1][1], Very_useful: count_4[1][1], Somewhat_useful: count_3[1][1], Not_so_useful: count_2[1][1], Not_at_all_useful: count_1[1][1] }
  end

  def self.answers_clarity
    { Extremely_clearly: count_5[2][1], Very_clearly: count_4[2][1], Somewhat_clearly: count_3[2][1], Not_so_clearly: count_2[2][1], Not_at_all_clearly: count_1[2][1] }
  end

  def self.answers_speed
    { Much_too_fast: count_5[3][1], Too_fast: count_4[3][1], The_right_amount: count_3[3][1], Too_slow: count_2[3][1], Much_too_slow: count_1[3][1] }
  end

  def self.answers_answered
    { Extremely_well: count_5[4][1], Very_well: count_4[4][1], Somewhat_well: count_3[4][1], Not_so_well: count_2[4][1], Not_at_all_well: count_1[4][1] }
  end

  def self.answers_how_comfortable
    { Extremely_comfortable: count_5[5][1], Very_comfortable: count_4[5][1], Somewhat_comfortable: count_3[5][1], Not_so_comfortable: count_2[5][1], Not_at_all_comfortable: count_1[5][1] }
  end

  def self.answers_assignements
    { Extremely_helpful: count_5[6][1], Very_helpful: count_4[6][1], Somewhat_helpful: count_3[6][1], Not_so_helpful: count_2[6][1], Not_at_all_helpful: count_1[6][1] }
  end

  def self.answers_improvements
      CSV.open(CSV_DATA_PATH, headers: true).read
  end

  private

  def self.create_tmp_csv_file(email, token)
    csv_data_tmp = File.join(File.dirname(__FILE__), '/database/survey_results_temp.csv')
    headers = ['valid_id','user_name', 'email', 'rate', 'usefulness', 'clarity', 'speed', 'answered', 'how_comfortable', 'assignements', 'improvements']

    CSV.open(csv_data_tmp, "wb", headers: true) do |csv|
      csv << headers unless headers.empty?
      CSV.foreach(CSV_DATA_PATH, headers: true) do |row|
        write_token_id(row, email, token)
        csv << row
      end
    end
  end

  def self.write_token_id(row, email, token)
    if row['email'] == email
      row['valid_id'] = token
    end
    row
  end

  def self.delete_old_csv_and_rename_tmp_csv
    csv_data_tmp = File.join(File.dirname(__FILE__), '/database/survey_results_temp.csv')
    File.delete(CSV_DATA_PATH)
    File.rename(csv_data_tmp,CSV_DATA_PATH)
  end

  def self.count_5
    @survey_result.map { |(name, *data)| [name, data.count { |val| val == "5" }] }
  end

  def self.count_4
    @survey_result.map { |(name, *data)| [name, data.count { |val| val == "4" }] }
  end

  def self.count_3
    @survey_result.map { |(name, *data)| [name, data.count { |val| val == "3" }] }
  end

  def self.count_2
    @survey_result.map { |(name, *data)| [name, data.count { |val| val == "2" }] }
  end

  def self.count_1
    @survey_result.map { |(name, *data)| [name, data.count { |val| val == "1" }] }
  end
end
