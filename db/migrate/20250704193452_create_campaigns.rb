class CreateCampaigns < ActiveRecord::Migration[7.2]
  def change
    create_table :campaigns do |t|
      t.string :title
      t.text :description
      t.integer :total_reward_amount
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
