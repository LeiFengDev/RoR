class Timesheet
  include ActiveModel::Validations

  attr_accessor :reportId, :filepath, :filename, :processTime, :timeRecords
  attr_reader   :errors, :invalidFilepath, :invalidContentType, :invalidDataFormat

  validates_presence_of :processTime
  validates_presence_of :filename
  validates_numericality_of :reportId, greater_than: 0
  validate :validate_records


  def initialize(import_class = TimesheetFromCsvFile)
    @import_class = import_class
    @processTime = DateTime.now
    @timeRecords = []
    @errors = ActiveModel::Errors.new(self)
  end

  def verify!(uploaded_io)
    @invalidFilepath = uploaded_io.original_filename.nil?
    @invalidContentType = uploaded_io.content_type != @import_class::ContentType

    @fileStream = uploaded_io
  end
  
  def upload!
    @upload_timestamp = @processTime.strftime('%Y%m%d%I%M%S')
    @upload_filename = @fileStream.original_filename
    @uploaded_filename = "#{@upload_timestamp}_#{@upload_filename}"
    @uploaded_filepath = Rails.root.join('public', 'uploads', @uploaded_filename)

    File.open(@uploaded_filepath, 'wb') do |file|
      file.write(@fileStream.read)
    end

    @filename = @uploaded_filename
    @filepath = @uploaded_filepath
  end
  
  def load(file_path = self.filepath)
    if file_path.nil?
      if @filename.nil?
        # code error: filepath is mandatory
        raise ArgumentError.new("Filename and filepath nil. File load stopped. Check uploaded filepath first.")  
        return
      end
      
      file_path = Rails.root.join('public', 'uploads', @filename)
    end

    @filepath = file_path.clone
    if @filename.nil?
      @filename = File.basename(file_path)
    end

    import_timesheet_rows_from(file_path).each do |row|
      @timeRecords << row
    end
    
    @invalidDataFormat = self.invalid?
  end

  def update_dailyworks!
    @dWorks = Array.new

    @timeRecords.each do |r|
      @dailywork = Dailywork.new({ :employee_id => r.employee_id, :workgroup_id => r.group_id, :date => r.date, :hours => r.hours, :report_id => @reportId })
      @dWorks << @dailywork
    end

    Dailywork.transaction do
      @dWorks.each(&:save)
    end
  end


    
  def to_model
    # avoid to_key error
  end
  def persisted?
    false
  end
  def id
    nil
  end

  private

  def validate_records
    if !timeRecords.is_a?(Array) || timeRecords.detect{|r| r.invalid?}
      @errors.add(:timeRecords, :invalid)
    end
  end

  def import_timesheet_rows_from(file_path)
    @imported = @import_class.new(file_path)
    @all_body_rows = @imported.timesheet_rows #.select(&:valid?)

    if (@import_class::HasFooters == true)
      @reportId = @imported.id_in_footer
    end

    return @all_body_rows
  end

end