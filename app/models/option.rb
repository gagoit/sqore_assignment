class Option
  ## Modules
  begin
    include Mongoid::Document
  end
  
  ## Relations
  begin
    embedded_in :question
    
  end

  ## Fields
  begin
    field :text,            type: String

    # 0 if incorrect, more than 0 if correct
    field :score,           type: Integer, default: 0
  end

  ## Validations
  begin
    validates_presence_of :text, :score
  end
end