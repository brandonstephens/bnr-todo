class Task
  include DataMapper::Resource

  property :id, Serial
  property :description, String
  property :done, Boolean
  property :due_date, Date

  def to_s
    description.to_s
  end

  def due_date=(date)
    date = nil if date == ''
    super date
  end
end
