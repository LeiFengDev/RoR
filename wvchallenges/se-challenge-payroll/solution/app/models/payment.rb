class Payment
  include ActiveModel::Validations

  attr_accessor :employee_id, :pay_rows
  attr_reader   :pay_stubs
  
  def initialize(employeeId, dailyworkRows, periodType)
    @errors = ActiveModel::Errors.new(self)

    @employee_id = employeeId
    @pay_stubs = Array.new

    load_pay_stubs(dailyworkRows, periodType)
  end

  def to_model
    # avoid to_model error
  end
  def persisted?
    false
  end
  def id
    nil
  end

  private

  def load_pay_stubs(dailyworkRows, payPeriodType)
    @dWorkRowsSortedByDatetimeAsc = dailyworkRows.sort_by(&:date)

    @payDateRanges = get_all_pay_date_ranges(@dWorkRowsSortedByDatetimeAsc, payPeriodType)

    @payDateRanges.each do |week_number, range|
      @pay_stubs += PayStub.parse(range)
    end
  end

  def get_all_pay_date_ranges(workRows, payPeriodType)
    payDateRanges = Hash.new

    workRows.each do |r| 
      currentPayDateRange = get_current_pay_date_range(r.date, payPeriodType)

      unless payDateRanges.detect { |week_number, range| week_number == currentPayDateRange.week_number }
        currentPayDateRange.ordinal = payDateRanges.size + 1
        payDateRanges[currentPayDateRange.week_number] = currentPayDateRange
      end

      payDateRanges[currentPayDateRange.week_number].work_rows << r
    end
    
    return payDateRanges
  end
  
  def get_current_pay_date_range(date, periodType)
    range = PayDateRange.new

      case periodType 
    when PayPeriod::MONTHLY
      year = date.year
      month = date.month

      range.start_date = Date.new(year, month, 1)
      range.end_date = Date.new(year, month, -1)
    when PayPeriod::SEMIMONTHLY
      year = date.year
      month = date.month
      mid_date_of_month = Date.new(year, month, 15)

      if date <= mid_date_of_month
        range.start_date = Date.new(year, month, 1)
        range.end_date = mid_date_of_month
      else
        range.start_date = mid_date_of_month.next
        range.end_date = Date.new(year, month, -1)
      end
    when PayPeriod::BIWEEKLY
      currentWeekNumber = date.strftime("%U").to_i
      
      if currentWeekNumber % 2 == 0   # even week number 
        range.start_date = date.beginning_of_week(:sunday) - 7.days
        range.end_date = date.end_of_week(:sunday)
      else
        range.start_date = date.beginning_of_week(:sunday)
        range.end_date = date.end_of_week(:sunday) + 7.days
      end
    when PayPeriod::WEEKLY
      range.start_date = date.beginning_of_week(:sunday)
      range.end_date = date.end_of_week(:sunday)
    else
      raise ArgumentError, 'Argument is not in range of ENUM PayPeriod'
    end

    return range
  end

end
