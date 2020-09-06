class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.string :office_address
      t.string :phone_number
      t.string :profile_picture
      t.string :confirm_token
      t.boolean :email_confirmed

      t.timestamps
    end
  end
end
