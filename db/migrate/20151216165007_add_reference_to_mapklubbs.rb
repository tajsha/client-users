class AddReferenceToMapklubbs < ActiveRecord::Migration
  def change
    add_reference :mapklubbs, :mapable, index: true
  end
end
