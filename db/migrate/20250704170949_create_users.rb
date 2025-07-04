class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.string :flow_address
      t.string :name
      t.string :email
      t.string :profile_pic
      t.string :role

      t.timestamps
    end
  end
end
