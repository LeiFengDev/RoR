class Workgroup < ApplicationRecord
  validates :category, presence: true
  validates :rate, numericality: { greater_than: 0 }
end
