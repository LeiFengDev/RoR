require 'csv'

class TimesheetFromCsvFile
  attr_reader :header_row, :footer_row, :id_in_footer

  ContentType = "text/csv"
  HasHeaders = true
  HasFooters = true

  class FetchCSVFileError < StandardError
    attr_reader :inner_action, :inner_exception 
    def initialize(e)
      @inner_action = self.class.name
      @inner_exception = e
    end
  end
  
  def initialize(file_path)
    @file_path = file_path
  end

  def timesheet_rows
    @timeRecords = []
    
    begin
      CSV.foreach(@file_path, { headers: HasHeaders, return_headers: HasHeaders, converters: :all }).with_index(HasHeaders ? 0 : 1) do |row, ln|
        @lastRow = row
        @timeRecords << TimesheetRow.new(ln, row)
      end

    rescue => e
      raise FetchCSVFileError.new(e)
    end

    if HasHeaders
      @header_row = @timeRecords.shift
    end
    if HasFooters
      @ln = @timeRecords.pop.ordinal

      @footer_row = TimesheetFooter.new(@ln, @lastRow)
      @id_in_footer = @footer_row.reportId
    end

    return @timeRecords
  end

  def timesheet_footer_row
    return row
  end
  
end