class Api::V1::AuthorsController < Api::V1::ApplicationController

  def index
  # will return the authors already included in the db    
    @authors = Author.all.to_a
  end

end
