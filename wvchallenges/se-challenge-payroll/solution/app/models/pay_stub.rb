class PayStub
  include ActiveModel::Validations

  attr_accessor :group_id, :rate, :hours
  attr_reader   :ordinal, :weekNumber, :startDate, :endDate, :amount
  
  def initialize(ordinal, week_number, start_date, end_date)
    @errors = ActiveModel::Errors.new(self)
    @ordinal = ordinal
    @weekNumber = week_number
    @startDate = start_date
    @endDate = end_date
    @group_id = 0
    @rate = 0.0
    @hours = 0.0

    @amount = 0.0
  end
  
  def self.parse(single_pay_date_range)
    stubs = Array.new
    pystb = PayStub.new(single_pay_date_range.ordinal, single_pay_date_range.week_number, single_pay_date_range.start_date, single_pay_date_range.end_date)

    pStub = pystb.clone
    single_pay_date_range.work_rows.sort_by(&:workgroup_id).each do |row|

      unless pStub.group_id == row.workgroup_id
        if pStub.hours > 0
          pStub.calc_amount
          stubs << pStub
        end
        
        pStub = pystb.clone
        pStub.group_id = row.workgroup_id
        pStub.rate = Workgroup.find(row.workgroup_id).rate
      end
      
      pStub.hours += row.hours
    end
    pStub.calc_amount
    stubs << pStub

    return stubs
  end

  def calc_amount
    @amount = @rate * @hours
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

end
