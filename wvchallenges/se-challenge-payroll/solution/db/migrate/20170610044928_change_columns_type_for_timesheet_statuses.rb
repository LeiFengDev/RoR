class ChangeColumnsTypeForTimesheetStatuses < ActiveRecord::Migration[5.1]
  def change
    change_column :timesheet_statuses, :employees, :text
    change_column :timesheet_statuses, :workgroups, :text
  end
end
