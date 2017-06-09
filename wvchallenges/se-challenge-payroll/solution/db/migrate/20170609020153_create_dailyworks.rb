class CreateDailyworks < ActiveRecord::Migration[5.1]
  def change
    create_table :dailyworks do |t|
      t.references :employee, foreign_key: true
      t.references :workgroup, foreign_key: true
      t.datetime :date
      t.float :hours

      t.timestamps
    end
  end
end
