class Forecast
  CONNECTION = Faraday.new url: 'http://api.wunderground.com' do |connection|
    connection.response :json, content_type: /\bjson$/
    connection.adapter Faraday.default_adapter
  end

  WEATHER_UNDERGROUND_API_KEY = ENV['WEATHER_UNDERGROUND_API_KEY']

  def self.ten_day_forecast(state, city)
    raise 'You must provide a Weather Underground API key' unless WEATHER_UNDERGROUND_API_KEY
    url = "/api/#{ WEATHER_UNDERGROUND_API_KEY }/forecast10day/q/#{ state }/#{ city }.json"
    consume(CONNECTION.get(url).body)
  end

  def self.consume(body)
    get_forecast_days(body).reduce({}) do |all, forecast_day|
      all.merge(get_date(forecast_day) => get_icon(forecast_day))
    end
  end

  def self.get_forecast_days(body)
    # binding.pry
    body['forecast']['simpleforecast']['forecastday']
  end

  def self.get_date(forecast_day)
    year, month, day = forecast_day['date'].values_at('year', 'month', 'day')
    Date.new(year, month, day)
  end

  def self.get_icon(forecast_day)
    forecast_day['icon_url']
  end
end