class CreateOldUsers < ActiveRecord::Migration
  def change


      add_column :users, :new_pass,  :string

  end
end
