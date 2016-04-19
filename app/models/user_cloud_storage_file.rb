class UserCloudStorageFile
  
  ## Modules
  begin
    include Mongoid::Document
    include Mongoid::Timestamps
  end
  
  ## Relations
  begin
    belongs_to :user

  end

end