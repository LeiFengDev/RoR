class CreateWorkgroups < ActiveRecord::Migration[5.1]
  def change
    create_table :workgroups do |t|
      t.string :category
      t.string :name
      t.decimal :rate

      t.timestamps
    end
  end
end
