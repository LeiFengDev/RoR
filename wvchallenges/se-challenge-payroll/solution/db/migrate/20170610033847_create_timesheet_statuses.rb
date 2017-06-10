class CreateTimesheetStatuses < ActiveRecord::Migration[5.1]
  def change
    create_table :timesheet_statuses do |t|
      t.integer :report_id
      t.datetime :process_time
      t.integer :status
      t.integer :error
      t.integer :employees, array: true, default: []
      t.integer :workgroups, array: true, default: []

      t.timestamps
    end
    add_index :timesheet_statuses, :report_id
  end
end
