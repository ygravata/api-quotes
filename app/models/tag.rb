class Tag
  include Mongoid::Document
  field :name, type: String
  field :searched, type: Mongoid::Boolean, default: false
  has_and_belongs_to_many :quotes
end
