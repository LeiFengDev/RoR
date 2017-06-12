class AddNotNullFilenameToTimesheetStatuses < ActiveRecord::Migration[5.1]
  def up
    add_column :timesheet_statuses, :filename, :string
    change_column_null :timesheet_statuses, :filename, false
  end

  def down
    remove_column :timesheet_statuses, :filename, :string
  end
end
