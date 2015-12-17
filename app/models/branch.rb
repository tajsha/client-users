class Branch < ActiveRecord::Base
  belongs_to :client
  has_one :mapklubb, as: :mapable
  has_and_belongs_to_many :admins, -> { where role: 1 }, :class_name => 'User'
end
