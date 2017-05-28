class GoogleFinanceObject < ApplicationRecord
  belongs_to :owner_isntrument, polymorphic: true
end