class NasdaqInstrument < ApplicationRecord
  validates :symbol, :presence => true, :uniqueness => true
end
