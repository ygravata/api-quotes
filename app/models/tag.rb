class Tag
  include Mongoid::Document
  field :name, type: String
  field :searched, type: Mongoid::Boolean, default: false
  # has_and_belongs_to_many :quotes
    # in a second version of this api, the Tag class will replace the SearchTag class and the tags field of Quote object. should have two functions  to each tag, 
    # a tag will be created when inserted in the endpoint or when a quote have this said tag
    # a tag will have the searched field: default=false, when searched through endpoint the field will be set to true
end