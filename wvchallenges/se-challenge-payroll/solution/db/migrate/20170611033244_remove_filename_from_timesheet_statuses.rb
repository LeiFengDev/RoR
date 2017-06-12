class RemoveFilenameFromTimesheetStatuses < ActiveRecord::Migration[5.1]
  def change
    remove_column :timesheet_statuses, :filename, :string
  end
end
