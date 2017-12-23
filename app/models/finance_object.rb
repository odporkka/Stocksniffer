class FinanceObject < ApplicationRecord
  belongs_to :owner_isntrument, polymorphic: true
end