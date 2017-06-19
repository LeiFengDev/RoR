class ReportController < ApplicationController

  def index
    @report = Report.new(params)

    @employee_total = Employee.all.size
    @workgroup_total = Workgroup.all.size
  end

  def show_json
    @report = Report.new(params)

    render json: { "report" => @report }
  end
  
  private

  def report_params
    params.require(:report).permit(:start_datetime, :end_datetime, :workgroup_id, :employee_id, :pay_period)
  end
end
