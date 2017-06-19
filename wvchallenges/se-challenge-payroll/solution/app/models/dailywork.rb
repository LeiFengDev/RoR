class Dailywork < ApplicationRecord
  belongs_to :employee
  belongs_to :workgroup
  validates :date, presence: true
  validates :hours, numericality: { greater_than: 0 }
  validates :report_id, numericality: { greater_than: 0 }

  default_scope { order(employee_id: :asc) }

  scope :bewteen_start_end_date, ->(start_date, end_date) { where("date BETWEEN datetime('#{start_date}') AND datetime('#{end_date}')") }
  scope :from_start_date, ->(date) { where("date >= datetime('#{date}')") }
  scope :to_end_date, ->(date) { where("date <= datetime('#{date}')") }
  scope :employee, ->(employee_id) { where("employee_id = #{employee_id}") }
  scope :workgroup, ->(group_id) { where("workgroup_id = #{group_id}") }
  
  def self.find_rows_sorted_by_employee_id(startDatetime, endDatetime, workgroupId, employeeId)
    if startDatetime.present? && endDatetime.present?
      @found = Dailywork.send(:bewteen_start_end_date, startDatetime, endDatetime)
      
      if workgroupId.present?
        @found = @found.send(:workgroup, workgroupId)
      end
      
      if employeeId.present?
        @found = @found.send(:employee, employeeId)
      end

      return @found
    end
    
    if startDatetime.present?
      @found = Dailywork.send(:from_start_date, startDatetime)

      if workgroupId.present?
        @found = @found.send(:workgroup, workgroupId)
      end
      
      if employeeId.present?
        @found = @found.send(:employee, employeeId)
      end

      return @found
    end
    
    if endDatetime.present?
      @found = Dailywork.send(:to_end_date, endDatetime)

      if workgroupId.present?
        @found = @found.send(:workgroup, workgroupId)
      end
      
      if employeeId.present?
        @found = @found.send(:employee, employeeId)
      end

      return @found
    end

    if workgroupId.present?
      @found = Dailywork.send(:workgroup, workgroupId)

      if employeeId.present?
        @found = @found.send(:employee, employeeId)
      end

      return @found
    end

    if employeeId.present?
      @found = Dailywork.send(:employee, employeeId)

      return @found
    end

    @found = Dailywork.all
    return @found
  end

end
