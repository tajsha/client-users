class AddMapableTypeToMapklubbs < ActiveRecord::Migration
  def change
    add_column :mapklubbs, :mapable_type, :string, :null => false
  end
end
