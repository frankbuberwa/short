class CreateDoctors < ActiveRecord::Migration[8.0]
  def change
    create_table :doctors do |t|
      t.references :user, null: false, foreign_key: true
      t.string :specialty
      t.string :license_number
      t.integer :years_of_experience
      t.float :latitude
      t.float :longitude
      t.string :address
      t.string :city
      t.string :state
      t.string :country
      t.string :postal_code
      t.string :phone_number

      t.timestamps
    end
  end
end
