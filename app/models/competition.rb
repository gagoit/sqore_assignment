class Competition
  ## Modules
  begin
    include Mongoid::Document
    include Mongoid::Timestamps
  end
  
  ## Relations
  begin
    has_many :question_sets
    has_many :questions
    has_many :submissions

    has_many :user_competitions

  end

  ## Fields
  begin
    field :name,              type: String
  end

  ## Validations
  begin
    validates_presence_of :name
  end
end