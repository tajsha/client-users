class Address < ActiveRecord::Base
  has_many :mapklubbs, as: :mapable
end
