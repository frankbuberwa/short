class AddPatientIdToAppointments < ActiveRecord::Migration[8.0]
  def change
    add_reference :appointments, :patient, null: false, foreign_key: { to_table: :users }
  end
end
