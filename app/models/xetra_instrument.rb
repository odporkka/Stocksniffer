class XetraInstrument < ApplicationRecord
  validates :name, :presence => true
  validates :isin, :presence => true, :uniqueness => true
end
