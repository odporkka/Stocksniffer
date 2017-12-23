class XetraInstrument < ApplicationRecord
  has_one :finance_object, as: :owner_instrument, dependent: :destroy
  validates :name, :presence => true
  validates :symbol, :presence => true, :uniqueness => true
end
