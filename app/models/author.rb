class Author
  include Mongoid::Document
  field :name, type: String
  field :author_about, type: String
  has_many :quotes
end
