class AddFilenameToTimesheetStatuses < ActiveRecord::Migration[5.1]
  def change
    add_column :timesheet_statuses, :filename, :string, null: false, default:''
    change_column :timesheet_statuses, :filename, :string, null: false
  end
end
