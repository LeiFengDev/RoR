class CreateDailyworksOld < ActiveRecord::Migration[5.1]
  def change
    create_table :dailyworks do |t|
      t.integer :employee_id
      t.integer :workgroup_id
      t.date :date
      t.float :hours

      t.timestamps
    end
  end
end
