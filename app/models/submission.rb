class Submission
  ## Modules
  begin
    include Mongoid::Document
    include Mongoid::Timestamps
  end
  
  ## Relations
  begin
    # De-nomalization when store question_set_id & competition_id - to optimize the query performance
    belongs_to :competition
    belongs_to :question_set
    belongs_to :question

    belongs_to :user
  end

  ## Fields
  begin
    field :answer,                type: String #(key of selected option, or textual answers)
    field :score,                 type: Integer, default: 0
  end

  ## Callbacks
  begin
    after_save :update_user_competition
  end

  ## Scopes & Indexes
  begin
    index({question_set_id: 1, user_id: 1})
  end

  ## Methods
  begin
    def update_user_competition
      return unless user && competition

      user_competition = UserCompetition.find_or_initialize_by(user_id: user_id, competition_id: competition_id)

      user_competition.init_default_data(user, competition)
      user_competition.need_recalculate_for << question_set_id
      user_competition.save

      true
    end
  end
end