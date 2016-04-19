class UserCompetition
  ## Modules
  begin
    include Mongoid::Document
    include Mongoid::Timestamps
  end
  
  ## Relations
  begin
    belongs_to :user
    belongs_to :competition
  end

  ## Fields
  begin
    # {
    #   question_set_id_1: score,
    #   question_set_id_2: score,
    #   …
    #   total: score
    # }
    field :score_hash,            type: Hash, default: {"total" => 0}

    # Array of question set id that need to re-calculate. When user submit new submission for a question set, 
    #   we will insert this question set id to need_recalculate_for.
    # Example:
    # • is null if have no question set that needs re-calculate
    # • [question_set_id_1, question_set_id_2 ..]
    field :need_recalculate_for,  type: Array, default: nil

  end

  ## Scopes & Indexes
  begin
    scope :need_recalculate, -> {where(:need_recalculate_for.ne => nil)}
  
    index({need_recalculate_for: 1})
    index({competition_id: 1, user_id: 1})
  end

  ## Methods
  begin

    def init_default_data(user, competition)
      return unless user && competition

      self.user_id = user.id
      self.competition_id = competition.id
      self.score_hash ||= {"total" => 0}
      self.need_recalculate_for ||= []

      competition.question_set_ids.each do |qs_id|
        self.score_hash[qs_id.to_s] ||= 0

        self.score_hash["total"] += self.score_hash[qs_id.to_s]
      end
    end

  end
end