class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :uid
      t.string :name
      t.string :last_name
      
      t.string :phone
      t.string :password
      t.string :address

      t.string :provider

      t.timestamps
    end
  end
end
