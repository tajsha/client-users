class CreateMapklubbs < ActiveRecord::Migration
  def change
    create_table :mapklubbs do |t|
      t.integer :parent_id

      t.timestamps null: false
    end
  end
end
