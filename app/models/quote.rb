class Quote
  include Mongoid::Document
  field :quote, type: String
  field :author_about, type: String
  belongs_to :author
  has_and_belongs_to_many :tags
end
