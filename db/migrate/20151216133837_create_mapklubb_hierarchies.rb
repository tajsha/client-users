class CreateMapklubbHierarchies < ActiveRecord::Migration
  def change
    create_table :mapklubb_hierarchies, id: false do |t|
      t.integer :ancestor_id, null: false
      t.integer :descendant_id, null: false
      t.integer :generations, null: false
    end

    add_index :mapklubb_hierarchies, [:ancestor_id, :descendant_id, :generations],
      unique: true,
      name: "mapklubb_anc_desc_idx"

    add_index :mapklubb_hierarchies, [:descendant_id],
      name: "mapklubb_desc_idx"
  end
end
