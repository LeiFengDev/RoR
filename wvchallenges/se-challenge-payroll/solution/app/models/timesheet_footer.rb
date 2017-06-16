class TimesheetFooter
  include ActiveModel::Validations

  attr_reader   :name, :reportId, :ordinal, :errors

  validates_presence_of :name
  validates_numericality_of :reportId, greater_than: 0
  validates_numericality_of :ordinal, greater_than: 0

  def initialize(ln, row)
    @errors = ActiveModel::Errors.new(self)
    
    @ordinal = ln
    @name = row.field("date")
    @reportId = row.field("hours worked")
  end


  def to_model
    # avoid to_model error
  end
  def persisted?
    false
  end
  def id
    nil
  end


end