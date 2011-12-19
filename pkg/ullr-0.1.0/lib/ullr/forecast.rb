module Ullr
  class Forecast
    require 'open-uri'
    require 'ostruct'
    attr_accessor :lat, :lon, :forecast_string, :noaa_endpoint, :data, :socket_error
    NOAA_ENDPOINT = "http://forecast.weather.gov/MapClick.php?lat={{lat}}&lon={{lon}}&FcstType=dwml"

    def initialize(options={})
      [:lat,:lon].each do |o|
       raise(ArgumentError, "#{o.to_s} is required!") if !options[o] || !options[o].instance_of?(Float)
      end
      @lat = options[:lat]
      @lon = options[:lon]
      @noaa_endpoint = NOAA_ENDPOINT.gsub("{{lat}}",@lat.to_s).gsub("{{lon}}",@lon.to_s)
    end

    def get_noaa_forecast
      @socket_error = false
      @data = []
      begin
        resp = open(@noaa_endpoint)
        @forecast_string = resp.read
      rescue SocketError
        @socket_error = true
      end
      if !@socket_error
        data = Ullr::NOAA::Data.parse(@forecast_string)
        forecast = data.find{|o| o.type == 'forecast'}
        if forecast
          time_layout = forecast.time_layouts.find{|t| t.layout_key =~ /k-p12h/ }
          time_layout.start_valid_times.each_with_index do |time,i|
            params = forecast.parameters
            word = params.worded_forecast.texts[i]
            point = OpenStruct.new
            point.start_time = time.period_start
            point.name = time.period_name
            point.pop = params.pops.values[i].value
            point.text = word.value
            point.snow = word.has_snow?
            point.high_temperature = word.high_temperature
            point.low_temperature = word.low_temperature
            point.wind_direction = word.wind_direction
            point.wind_speeds = word.wind_speeds
            point.snow_estimate = word.snow_estimate
            @data << point
          end
        end
      end
      return @data
    end
  end
end
