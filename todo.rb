$LOAD_PATH.unshift File.dirname(__FILE__)

require 'task'
require 'list'
require 'forecast'

DATABASE_URL = ENV['DATABASE_URL'] || 'postgres://localhost/to_do_app'

DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, DATABASE_URL)

DataMapper.finalize
Task.auto_upgrade!

class ToDoApp < Sinatra::Base
  
  get '/' do
    @tasks = Task.all
    @forecast = Forecast.ten_day_forecast('GA', 'Atlanta')
    erb :index
  end

  get '/:id' do
    @task = Task.get(params[:id])
    erb :show
  end

  post '/' do
     Task.create(params)
     redirect '/'
  end

  patch '/:id' do
    task = Task.get(params[:id])

    # puts task.done?

    # if task.done?
    #   task.update(done: false)
    # else
    #   task.update(done: true)
    # end

    # same as comment above @jordan's version
    task.update(done: !task.done?)

    redirect '/'
  end

  delete '/:id' do
    task = Task.get(params[:id])
    task.destroy
    redirect '/'
  end

  post '/export' do
    list = List.new(Task.all)
    gist = Gist.gist(list.to_markdown, filename: 'To Do List.md')
    redirect gist['html_url']
  end

  put '/:id' do
    task = Task.get(params[:id])
    task.update(
      description: params[:description],
      done: params[:done],
      due_date: params[:due_date]
    )
    redirect '/'
  end

end
