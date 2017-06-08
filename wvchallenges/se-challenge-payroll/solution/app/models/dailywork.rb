class Dailywork < ApplicationRecord
  belongs_to :employee
  belongs_to :workgroup
  validates :date, presence: true
  validates :hours, numericality: { greater_than: 0 }
end
