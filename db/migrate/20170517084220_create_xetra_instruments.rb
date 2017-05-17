class CreateXetraInstruments < ActiveRecord::Migration[5.0]
  def change
    create_table :xetra_instruments do |t|
      t.string :name
      t.string :isin
      t.string :instrument_type

      t.timestamps
    end
  end
end
