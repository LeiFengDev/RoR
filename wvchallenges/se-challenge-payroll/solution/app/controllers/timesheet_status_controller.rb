class TimesheetStatusController < ApplicationController
  def index
    @timesheetStatus = TimesheetStatus.all

    render json: @timesheetStatus
  end

end
