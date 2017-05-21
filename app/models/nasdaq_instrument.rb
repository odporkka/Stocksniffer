class NasdaqInstrument < ApplicationRecord
  validates :name, :presence => true
  validates :symbol, :presence => true, :uniqueness => true
end
