class List
  TEMPLATE = ERB.new(File.read('views/list.erb'), nil, '-')

  def initialize(tasks)
    @tasks = tasks
    @forecast = Forecast.ten_day_forecast('GA', 'Atlanta')
  end

  def to_markdown
    TEMPLATE.result(binding)
  end

end