class PayDateRange
  include ActiveModel::Validations

  attr_accessor :ordinal, :start_date, :end_date, :work_rows
  attr_reader   :week_number

  def initialize
    @work_rows = Array.new
  end
  
  def week_number
    @week_number = @start_date.strftime("%Y_%U") unless @start_date.nil?
  end
  
end
