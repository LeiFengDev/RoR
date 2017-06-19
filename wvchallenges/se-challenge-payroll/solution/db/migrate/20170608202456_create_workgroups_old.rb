class CreateWorkgroupsOld < ActiveRecord::Migration[5.1]
  def change
    create_table :workgroups do |t|
      t.string :category
      t.string :name
      t.float :rate

      t.timestamps
    end
  end
end
