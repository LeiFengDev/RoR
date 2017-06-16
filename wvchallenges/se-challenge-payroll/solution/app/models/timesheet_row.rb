class TimesheetRow
  include ActiveModel::Validations

  attr_accessor :date, :hours, :employee_id, :group, :group_id, :ordinal
  attr_reader   :errors, :validEmployeeId, :validGroupId, :validDate

  validates_presence_of :group
  validates_numericality_of :hours, greater_than: 0
  validates_numericality_of :ordinal, greater_than: 0

  validate :validate_employee_id, :validate_group_id, :validate_date

  WorkgroupCategoryMap = Workgroup::build_category_map().freeze
  EmployeeIdList = Employee::build_id_list().freeze

  def initialize(ln, row)
    @validEmployeeId = true
    @validGroupId = true
    @validDate = true
    @errors = ActiveModel::Errors.new(self)
    
    @ordinal = ln
    
    @timeStr = row.field("date")
    # format '%d/%m/%Y' failed DateTime parsing; have to apply .to_time first
    @date = @timeStr.to_time.to_s.to_datetime unless @timeStr.blank?

    @hours = row.field("hours worked").to_f
    @employee_id = row.field("employee id")
    @group = row.field("job group")
    @group_id = WorkgroupCategoryMap[row.field("job group")]
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

  def validate_employee_id
    unless EmployeeIdList.include?(@employee_id)
      @validEmployeeId = false
      @errors[:employee_id] << "not found"
    end
  end

  def validate_group_id
    if @group_id.nil?
      @validGroupId = false
      @errors[:group_id] << "not found"
    end
  end

  def validate_date
    unless @date.is_a?(DateTime)
      @validDate = false
      @errors.add(:date, "not valid") 
    end
  end

end