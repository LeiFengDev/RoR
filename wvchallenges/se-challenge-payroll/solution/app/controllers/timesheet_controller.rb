class TimesheetController < ApplicationController
  #before_filter :method-name
  rescue_from TimesheetFromCsvFile::FetchCSVFileError, with: :show_message

  def show_message(csv_exception)
    #flash[:error] = "IO Error"
    @exceptionDetails = { "action" => csv_exception.inner_action, "exception" => csv_exception.inner_exception }
    
    render json: @exceptionDetails
    #redirect_to "/"
  end


  def index
    @tsStatus = TimesheetStatus.last
    @timesheet = Timesheet.new
    unless @tsStatus.nil? || @tsStatus.filename.nil?
      @timesheet.load(Rails.root.join('public', 'uploads', @tsStatus.filename))
    end

    @timeRecordAttrExcludes = TimesheetStatus::AttrHidden
    @timeRecordAttrForceUnique = TimesheetStatus::AttrForceUnique
  end
  
  def upload
    @tsStatusList = TimesheetStatus.order(id: :DESC).all
  end
  
  def create
    @timesheet = Timesheet.new()

    # get file stream
    if params.nil? || params[:timesheet].nil?
      redirect_to :action => :upload
      return
    end
    
    uploaded_io = params[:timesheet][:filename] 
    if uploaded_io.nil?
      redirect_to :action => :upload
      return
    end

    # verify file stream
    @timesheet.verify!(uploaded_io)
    if @timesheet.invalidFilepath
      @filepathError = { "Error" => "File path blank" }

      render json: @filepathError
      return
    end
    if @timesheet.invalidContentType
      @fileTypeError = { "Error" => "File type invalid: #{uploaded_io.content_type}", "Filename" => uploaded_io.original_filename };

      render json: @fileTypeError
      return
    end

    # save to /public/uploads with timestamps
    @timesheet.upload!

    # read uploaded csv file into TimesheetStatus obj
    @timesheet.load

    #@timesheet.produce_status
    @tsStatus = TimesheetStatus.new
    @tsStatus.set_status(@timesheet)

    if @tsStatus.valid?
      if @tsStatus.success?
        @timesheet.update_dailyworks!
      end
      
      @tsStatus.save!
    end
    
    redirect_to :action => :index
  end


  private

  def timesheet_params
    params.require(:timesheet).permit(:reportId, :filename, :processTime, :timeRecords)
  end
end
