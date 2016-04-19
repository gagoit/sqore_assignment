class User
  ## Modules
  begin
    include Mongoid::Document
    include Mongoid::Timestamps
  end
  
  ## Relations
  begin
    has_many :submissions
    has_many :user_competitions
    has_many :user_cloud_storage_files

  end

end