class Workgroup < ApplicationRecord
  validates :category, presence: true
  validates :rate, numericality: { greater_than: 0 }

  # class << self; attr_accessor :category_map end
  # @category_map = build_category_map()

  def self.build_category_map
    @cate_map = Hash.new
    Workgroup.all.map { |g| @cate_map[g.category] = g.id }
    return @cate_map
  end
  
end
