class TimesheetStatus < ApplicationRecord
  serialize :employees, Array
  serialize :workgroups, Array

  validates :report_id, numericality: { greater_than: 0 }
  validates :process_time, presence: true
  validates :filename, presence: true

  enum status: [ :success, :failure ]
  enum error: [ :no_error, :filepath, :content_type, :duplicate_report, :employee_id_not_exist, :workgroup_id_not_exist, :record_format_invalid, :other_issue ]

  scope :success_report_id_eq, ->(rpt_id) { where("status = 0 AND report_id = #{rpt_id}") }

  AttrHidden = [:id, :created_at, :updated_at].freeze
  AttrForceUnique = [:employees, :workgroups].freeze

  def set_status(timesheet)
    self.process_time = DateTime.now.inspect
    self.filename = timesheet.filename
    self.report_id = timesheet.reportId
    self.employees = timesheet.timeRecords.map(&:employee_id)
    self.workgroups = timesheet.timeRecords.map(&:group_id)

    if timesheet.invalidFilepath
      self.error = 1
      self.status = 1
      return
    end

    if timesheet.invalidContentType
      self.error = 2
      self.status = 1
      return
    end

    @allCountedRptIds = Dailywork.all.map(&:report_id)
    @foundSameSuccessRptIds = TimesheetStatus.success_report_id_eq(self.report_id).size
    if @allCountedRptIds.include?(self.report_id) || @foundSameSuccessRptIds > 0
      self.error = 3
      self.status = 1
      return
    end

    @allEmpIds = Employee.all.map(&:id)
    unless (self.employees - @allEmpIds).empty?
      self.error = 4
      self.status = 1
      return
    end
    
    @allGrpIds = Workgroup.all.map(&:id)
    unless (self.workgroups - @allGrpIds).empty?
      self.error = 5
      self.status = 1
      return
    end

    if timesheet.invalidDataFormat
      self.error = 6
      self.status = 1
      return
    end
       
    unless timesheet.valid? 
      self.status = 1
      self.error = 7
      return
    end

    self.status = 0
    self.error = 0
  end


  private

  def timesheet_status_params
    params.require(:timesheet_status).permit(:filename, :process_time, :report_id, :status, :error, :employees, :workgroups)
  end
end
