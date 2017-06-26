# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# init Employees
Employee.create({:first_name => 'Jerry', :last_name => 'Land', :gender => 1, :description => 'test employee 1'})
Employee.create({:first_name => 'Larry', :last_name => 'Ocean', :gender => 1, :description => 'test employee 2'})
Employee.create({:first_name => 'Elissabath', :last_name => 'Norland', :gender => 2, :description => 'test employee 3'})
Employee.create({:first_name => 'John', :last_name => 'Parker', :gender => 1, :description => 'test employee 4'})
Employee.create({:first_name => 'Mith', :last_name => 'Konan', :gender => 0, :description => 'test employee 5'})

# init Workgroups
Workgroup.create({:category => 'A', :name => 'Junior', :rate => 20.0})
Workgroup.create({:category => 'B', :name => 'Senior', :rate => 30.0})