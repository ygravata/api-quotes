class Quote
  include Mongoid::Document
  field :quote, type: String
  belongs_to :author
  field :author_about, type: String
  field :tag_list, type: Array
  has_and_belongs_to_many :search_tags, inverse_of: nil

  
  # has_and_belongs_to_many :tags
    # in a second version of the api, replace the relation of search_tags for the relation bellow. Then delete the tag_list relation
  
  # index({ provider: 1, uid: 1 }, { unique: true})
    # in a second version, manage to implement the indexing of the class, for better performance

  private

  def self.quotes_with_search_tags(search_tag_param)
    # a class method to return an array of only the quotes that have an specific search_tag in the search_tags field
    array = []
    self.each do |quote|
      array << quote if quote.search_tags.find(search_tag_param.id)
    end
    array
  end

end
