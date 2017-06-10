class TimesheetStatus < ApplicationRecord
  serialize :employees, Array
  serialize :workgroups, Array
end
