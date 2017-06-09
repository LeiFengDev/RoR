class DropTableModelName < ActiveRecord::Migration[5.1]
  def change
    drop_table :dailyworks
    drop_table :workgroups
  end
end