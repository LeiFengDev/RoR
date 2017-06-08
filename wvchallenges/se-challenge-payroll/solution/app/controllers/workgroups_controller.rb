class WorkgroupsController < ApplicationController
  def index
    @workgroups = Workgroup.all
  end
  
  def new
    @workgroup = Workgroup.new
  end
  
  def create
    @workgroup = Workgroup.new(workgroup_params)
    
    @workgroup.save!

    redirect_to :action => :index
  end
  

  private

  def workgroup_params
    params.require(:workgroup).permit(:category, :name, :rate)
  end
end
