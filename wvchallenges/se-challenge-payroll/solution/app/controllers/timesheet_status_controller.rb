class TimesheetStatusController < ApplicationController
  def index
    @timesheetStatus = TimesheetStatus.all
  end

end
