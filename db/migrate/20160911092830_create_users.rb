class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.string :braintree_id
      t.string :user_number
      t.string :friend_number
      t.datetime :wakeup_time
      t.timestamps
    end
  end
end
