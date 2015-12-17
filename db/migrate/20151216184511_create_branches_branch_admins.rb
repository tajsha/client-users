class CreateBranchesBranchAdmins < ActiveRecord::Migration
  def change
    create_table :branches_users do |t|
      t.integer :user_id
      t.integer :branch_id
    end
  end
end
