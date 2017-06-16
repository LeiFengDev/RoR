module TimesheetStatusHelper
  def filename_w_prefix(prefix, filename)
    return "#{prefix}_#{filename}"
  end

  # add timestamp as prefix of the filename
  def filename_w_ts_prefix(filename)
    return filename_w_prefix(DateTime.now.strftime('%Y%m%d%I%M%S'), filename)
  end

  def filename_rm_prefix(filenameWithPrefix)
    # find first '_' and remove the prefix for filenames
    @filename = filenameWithPrefix.clone
    @prefix = filenameWithPrefix.slice(/.*?_/)
    unless @prefix.nil?
      @filename = filenameWithPrefix.sub! @prefix, ''
    end
    return @filename
  end

end
