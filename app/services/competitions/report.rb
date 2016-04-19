require 'csv'
module Competitions
  class Report

    PER_PAGE = 200
    USER_KEYS = ["name", "email", "contact_details", "country_of_studies", "university"]

    def initialize(competition)
      @competition = competition

      @headers, @headers_key = get_headers
    end

    ##
    # 
    ##
    def export_xls()
      export_time = Time.now.utc
      file_name = "report-for-#{@competition.id}-#{export_time.strftime('%m-%d-%Y-at-%H-%M-%S')}.xls"

      user_competitions = @competition.user_competitions.order([[:created_at, :asc]]).includes(:user)
      num_page = user_competitions.size/PER_PAGE + 1

      CSV.open("tmp/#{file_name}", "a+") do |csv|
        csv << @headers
      end

      (1..num_page).to_a.each do |page|
        user_competitions_in_page = user_competitions.paginate(:page => page, :per_page => PER_PAGE)
        user_ids = user_competitions_in_page.pluck(:user_id)

        users_info = ScApi.get_users_info(user_ids)

        user_competitions_in_page.each do |u_competition|
          score_hash = if u_competition.need_recalculate_for.blank?
              u_competition.score_hash
            else
              Competitions::Ultility.get_total_score(@competition, u_competition.user)
            end

          user_info = users_info[u_competition.user_id]

          insert_to_csv(file_name, user_info, score_hash)
        end
      end

      file_name
    end

    ##
    # Currently I use CSV to export report, but if you want to export to XLS 
    #   -> we can use a gem like axlsx (https://github.com/randym/axlsx)
    ##
    def insert_to_csv(file_name, user_info, score_hash)
      CSV.open("tmp/#{file_name}", "a+") do |csv|
        row_data = []

        @headers_key.each do |key|
          row_data << if USER_KEYS.include?(key)
                    user_info[key]
                  else
                    score_hash[key]
                  end
        end

        csv << row_data
      end
    end

    def get_headers
      headers = ["Name", "Email", "Contact Details", "Country Of Studies", "University"]
      headers_key = USER_KEYS.dup
      
      @competition.question_sets.each do |question_set|
        headers << "#{question_set.name} Score"
        headers_key << question_set.id.to_s
      end

      headers << "Total Score"
      headers_key << "total"

      return headers, headers_key
    end
  end
end