class EmployeesController < ApplicationController
  def index
    @employees = Employee.all
  end
  
  def new
    @employee = Employee.new
  end

  def create
    @employee = Employee.new(employee_params)
    
    @employee.save!

    redirect_to :action => :index
  end


  private

  def employee_params
    params.require(:employee).permit(:first_name, :last_name, :gender, :description)
  end
end