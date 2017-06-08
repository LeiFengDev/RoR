class CreateEmployees < ActiveRecord::Migration[5.1]
  def change
    create_table :employees do |t|
      t.string :first_name
      t.string :last_name
      t.integer :gender
      t.text :description

      t.timestamps
    end
  end
end
