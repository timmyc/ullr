module Ullr
  class Forecast
    require 'open-uri'
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
      begin
        resp = open(@noaa_endpoint)
        resp = resp.read
      rescue SocketError
        @socket_error = true
      end
    end
  end
end
