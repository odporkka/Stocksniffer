class XetraInstrument < ApplicationRecord
  has_one :google_finance_object, as: :owner_instrument
  validates :name, :presence => true
  validates :symbol, :presence => true, :uniqueness => true
end
