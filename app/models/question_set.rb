class QuestionSet
  ## Modules
  begin
    include Mongoid::Document
    include Mongoid::Timestamps
  end
  
  ## Relations
  begin
    belongs_to :competition
    has_many :questions
    has_many :submissions
    
  end

  ## Fields
  begin
    field :name,              type: String
  end

end