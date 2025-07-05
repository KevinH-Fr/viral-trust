class CreateReferrals < ActiveRecord::Migration[7.2]
  def change
    create_table :referrals do |t|
      t.string :code
      t.references :user, null: false, foreign_key: true
      t.references :campaign, null: false, foreign_key: true
      t.datetime :clicked_at
      t.string :ip

      t.timestamps
    end
  end
end
