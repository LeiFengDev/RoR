class DailyworksController < ApplicationController
  def index
    @dailyworks = Dailywork.all
  end
  
  def new
    @dailywork = Dailywork.new
  end
  
  def create
    @dailywork = Dailywork.new(dailywork_params)
    
    @dailywork.save!

    redirect_to :action => :index
  end
  

  private

  def dailywork_params
    params.require(:dailywork).permit(:employee_id, :workgroup_id, :date, :hours)
  end
end
