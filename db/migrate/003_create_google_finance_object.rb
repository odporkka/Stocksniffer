class CreateGoogleFinanceObject < ActiveRecord::Migration[5.0]
  def change
    create_table :google_finance_objects do |t|
      t.references :owner_instrument, polymorphic: true, index: {:name => "index_owner_instrument_on_google_finance_object"}
      t.float :mktcap
      t.float :shares
      t.float :open
      t.float :pe
      t.float :eps
      t.float :beta
      t.float :inst_own

      t.string :range
      t.string :one_year
      t.string :vol_per_avg
      t.string :div_per_yield

      t.timestamps
    end
  end
end
