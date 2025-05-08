class CreateHospitals < ActiveRecord::Migration[8.0]
  def change
    create_table :hospitals do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.text :address
      t.string :phone
      t.string :website
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
