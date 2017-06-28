# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# init Employees
(1..10).each do |i|
  Employee.create({:first_name => "first_#{i}", :last_name => "last_#{i}", :gender => rand(0..2), :description => "test employee #{i}"})
end

# init Workgroups
('A'..'E').each_with_index do |s, i| 
  Workgroup.create({:category => s, :name => "group #{s}", :rate => (20.0 + 10.0 * i)})
end