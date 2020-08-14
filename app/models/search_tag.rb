class SearchTag
  include Mongoid::Document
  field :name, type: String
  has_many :quotes
end
