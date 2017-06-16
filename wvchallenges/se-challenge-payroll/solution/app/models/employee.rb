class Employee < ApplicationRecord
  validates :first_name, presence: true
  validates :last_name, presence: true

  enum gender: [ :unknown, :male, :female ]

  def self.build_id_list
    @ids = Array.new
    Employee.all.map { |e| @ids << e.id }
    return @ids
  end
  
end
