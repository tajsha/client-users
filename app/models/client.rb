class Client < ActiveRecord::Base
  has_many :branches
  has_one :mapklubb, as: :mapable
end
