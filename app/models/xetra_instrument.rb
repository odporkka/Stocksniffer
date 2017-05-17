class XetraInstrument < ApplicationRecord
  validates :isin, :presence => true, :uniqueness => true
end
