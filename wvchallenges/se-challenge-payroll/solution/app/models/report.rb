class Report
  include ActiveModel::Validations

  attr_accessor :start_datetime, :end_datetime, :workgroup_id, :employee_id, :pay_period
  attr_reader   :employeeIds, :workgroupIds

  def initialize(params)
    @errors = ActiveModel::Errors.new(self)

    @start_datetime = params[:start_datetime].to_time.to_s.to_datetime unless params[:start_datetime].blank?
    @end_datetime = params[:end_datetime].to_time.to_s.to_datetime unless params[:end_datetime].blank?
    @workgroup_id = params[:workgroup_id].to_i unless params[:workgroup_id].blank?
    @employee_id = params[:employee_id].to_i unless params[:employee_id].blank?

    @pay_period_type_str = params[:pay_period]
    @pay_period_type_str ||= params[:default][:pay_period]
    @pay_period = PayPeriod.get_value(@pay_period_type_str)

    @payments = Array.new
    @employeeIds = Array.new
    @workgroupIds = Array.new
    load_payments(Dailywork.find_rows_sorted_by_employee_id(@start_datetime, @end_datetime, @workgroup_id, @employee_id), @pay_period)
  end

  def payments
    return @payments
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

  def load_payments(rowsOrderedByEmployeeId, payPeriodType)
    empId = 1
    rows4CurrentEmployee = Array.new
    rowsOrderedByEmployeeId.each do |r|
      if r.employee_id != empId
        if rows4CurrentEmployee.size > 0
          @employeeIds << empId
          @payments << Payment.new(empId, rows4CurrentEmployee, payPeriodType)
        end
        
        empId = r.employee_id
        rows4CurrentEmployee = Array.new
      end
      
      unless @workgroupIds.include?(r.workgroup_id)
        @workgroupIds << r.workgroup_id
      end
      
      rows4CurrentEmployee << r
    end

    if rows4CurrentEmployee.size > 0
      @employeeIds << empId
      @payments << Payment.new(empId, rows4CurrentEmployee, payPeriodType)
    end
  end
  
end
