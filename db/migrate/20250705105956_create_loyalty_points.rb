class CreateLoyaltyPoints < ActiveRecord::Migration[7.2]
  def change
    create_table :loyalty_points do |t|
      t.references :user, null: false, foreign_key: true
      t.references :campaign, null: false, foreign_key: true
      t.integer :balance, default: 0

      t.timestamps
    end
  end
end
