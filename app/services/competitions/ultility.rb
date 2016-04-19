module Competitions
  class Ultility

    ##
    # Get total score of a user for each question set of a competition
    # @params:
    #   competition
    #   user
    # @return:
    #   {
    #     question_set_key_1: 100,
    #     question_set_key_2: 200,
    #     ..
    #     total:  1000
    #   }
    #   
    #   total: is total score of list question set that we process
    ##
    def self.get_total_score(competition, user, question_set_ids = [])
      if question_set_ids.blank?
        question_set_ids = competition.question_set_ids
      end
   
      score_hash = { "total" => 0 }
      
      question_set_ids.each do |question_set_id|
        score = Submission.where(:question_set_id => question_set_id, user_id: user.id).sum(:score)

        score_hash[question_set_id.to_s] = score
        score_hash["total"] += score
      end

      score_hash
    end

    ##
    # - cron job to check and calculate the score for UserCompetition
    ##
    def self.calculate_score_for_user_competition
      UserCompetition.includes(:user, :competition).need_recalculate.each do |u_competition|
        need_recalculate_for = u_competition.need_recalculate_for
        scores_hash = u_competition.score_hash.dup

        while !need_recalculate_for.blank?
          need_recalculate_for = u_competition.need_recalculate_for
          scores = get_total_score(u_competition.competition, u_competition.user, need_recalculate_for)
          
          scores.each do |key, value|
            next if key == "total"

            old_score = scores_hash[key] || 0
            scores_hash[key] = value

            scores_hash["total"] += value - old_score
          end

          u_competition.reload
          need_recalculate_for = (u_competition.need_recalculate_for || []) - need_recalculate_for
        end

        u_competition.need_recalculate_for = nil
        u_competition.score_hash = scores_hash
        u_competition.save
      end
    end
  end
end