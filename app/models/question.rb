class Question
  ## Modules
  begin
    include Mongoid::Document
    include Mongoid::Timestamps
  end

  ## Constants
  begin
    MULTIPLE_CHOICE = "multiple­-choice"
    OPEN_ENDED = "open­-ended"
  end
  
  ## Relations
  begin
    belongs_to :competition
    belongs_to :question_set
    has_many :submissions
    
    embeds_many :options
  end

  ## Fields
  begin
    # multiple­-choice || open­-ended
    field :type,            type: String
  end

  ## Validations
  begin
    validates :type, presence: true, inclusion: { in: [MULTIPLE_CHOICE, OPEN_ENDED] }
  end
end