class CreateDoctors < ActiveRecord::Migration[8.0]
  def change
    create_table :doctors do |t|
      t.references :user, null: false, foreign_key: true
      t.string :specialty
      t.string :license_number
      t.integer :years_of_experience

      t.timestamps
    end
  end
end
