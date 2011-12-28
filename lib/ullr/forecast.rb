module Ullr
  class Forecast
    require 'open-uri'
    require 'ostruct'
    attr_accessor :lat, :lon, :forecast_string, :noaa_endpoint, :data, :socket_error, :parsed_forecast
    NOAA_ENDPOINT = "http://forecast.weather.gov/MapClick.php?lat={{lat}}&lon={{lon}}&FcstType=dwml"

    def initialize(options={})
      [:lat,:lon].each do |o|
       raise(ArgumentError, "#{o.to_s} is required!") if !options[o] || !options[o].instance_of?(Float)
      end
      @lat = options[:lat]
      @lon = options[:lon]
      @noaa_endpoint = NOAA_ENDPOINT.gsub("{{lat}}",@lat.to_s).gsub("{{lon}}",@lon.to_s)
    end

    def parse_temps
      temps = {:minimum => [], :maximum => []}
      @parsed_forecast.parameters.temperatures.each do |temp_data|
        time_layout = @parsed_forecast.time_layouts.find{|t| t.layout_key =~ /#{temp_data.time_layout}/ }
        temp_data.values.each_with_index do |temperature, i|
          data = OpenStruct.new
          time = time_layout.start_valid_times[i]
          data.temperature = temperature.value
          data.start_time = time.period_start
          data.period_name = time.period_name
          temps[temp_data.type.to_sym] << data
        end
      end
      return temps
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
        @parsed_forecast = forecast
        if forecast
          time_layout = forecast.time_layouts.find{|t| t.layout_key =~ /k-p12h/ }
          temperature_data = parse_temps
          time_layout.start_valid_times.each_with_index do |time,i|
            params = forecast.parameters
            word = params.worded_forecast.texts[i]
            min_temp = temperature_data ? temperature_data[:minimum].find{|t| t.period_name =~ /#{time.period_name}/} : false
            max_temp = temperature_data ? temperature_data[:maximum].find{|t| t.period_name =~ /#{time.period_name}/} : false
            point = OpenStruct.new
            point.start_time = time.period_start
            point.name = time.period_name
            point.pop = params.pops.values[i].value
            point.text = word.value
            point.snow = word.has_snow?
            point.high_temperature = max_temp ? max_temp.temperature : nil
            point.low_temperature = min_temp ? min_temp.temperature : nil
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
