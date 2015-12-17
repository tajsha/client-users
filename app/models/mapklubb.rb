class Mapklubb < ActiveRecord::Base
  belongs_to :mapable, polymorphic: true
  has_closure_tree
end
