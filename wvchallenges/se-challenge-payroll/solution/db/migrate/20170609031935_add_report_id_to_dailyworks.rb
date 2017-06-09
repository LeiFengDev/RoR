class AddReportIdToDailyworks < ActiveRecord::Migration[5.1]
  def change
    add_column :dailyworks, :report_id, :integer
    add_index :dailyworks, :report_id
  end
end
