require 'happymapper'
module Ullr
  module NOAA
    class StartValidTime
      include HappyMapper
      tag 'start-valid-time'
      content :period_start
      attribute :'period-name', String
      set_time = lambda{|ob|  
        if ob.period_start =~ /[0-9]*\-[0-9]*\-[0-9]*/ 
          ob.period_start = DateTime.parse(ob.period_start)
        end
      }
      after_parse(&set_time)
    end

    class TimeLayout
      include HappyMapper
      tag 'time-layout'
      attribute :'time-coordinate', String
      attribute :summarization, String
      element :'layout-key', String
      has_many :start_valid_times, StartValidTime
    end

    class Value
      include HappyMapper
      content :value
    end

    class Temperature
      include HappyMapper
      tag 'temperature'
      element :name, String
      attribute :type, String
      attribute :units, String
      attribute :'time-layout', String
      has_many :values, Value
    end

    class POP
      include HappyMapper
      tag 'probability-of-precipitation'
      element :name, String
      attribute :type, String
      attribute :units, String
      attribute :'time-layout', String
      has_many :values, Value
    end

    class WeatherCondition
      include HappyMapper
      tag 'weather-conditions'
      attribute :'weather-summary', String
    end

    class Weather
      include HappyMapper
      tag 'weather'
      attribute :'time-layout', String
      element :name, String
      has_many :weather_conditions, WeatherCondition
    end

    class IconLink
      include HappyMapper
      tag 'icon-link'
      content :url
    end

    class ConditionsIcon
      include HappyMapper
      tag 'conditions-icon'
      attribute :'time-layout', String
      element :name, String
      has_many :icon_links, IconLink
    end

    class Text
      include HappyMapper
      tag 'text'
      content :value

      def has_snow?
        if self.value =~ /snow/i
          return true
        else
          return false
        end
      end

      def snow_estimate
        rng = ['0','0']
        range = self.value.scan(/snow accumulation of (0|[1-9]\d*) to (0|[1-9]\d*)/)
        one = self.value.scan(/around an inch possible/)
        if !one.empty?
          rng = ['0','1']
        elsif !range.empty?
          rng = range.first
        elsif self.has_snow?
          rng = ['0','1']
        end
        return rng
      end

      def wind_direction
        direction = self.value.scan(/ (\w*) wind [around|between]/i)
        if !direction.empty?
          direction = direction.first[0].downcase
        else
          direction = ''
        end
        return direction
      end

      def wind_speeds
        rng = ['','']
        range = self.value.scan(/ wind between (0|[1-9]\d*) and (0|[1-9]\d*)/i)
        one = self.value.scan(/ wind around (0|[1-9]\d*)/i)
        if !one.empty?
          speed = one.first[0]
          rng = [speed,speed]
        elsif !range.empty?
          rng = range.first
        end
        return rng
      end

      def high_temperature
        high = ''
        high_temp = self.value.scan(/high near (0|[1-9]\d*)/)
        if !high_temp.empty?
          high = high_temp.first[0]
        end
        return high
      end

      def low_temperature
        low = ''
        low_temp = self.value.scan(/low around (0|[1-9]\d*)/)
        if !low_temp.empty?
          low = low_temp.first[0]
        end
        return low
      end
    end

    class WordedForecast
      include HappyMapper
      tag 'wordedForecast'
      attribute :'time-layout', String
      attribute :dataSource, String
      attribute :wordGenerator, String
      element :name, String
      has_many :texts, Text
    end

    class Parameters
      include HappyMapper
      tag 'parameters'
      has_many :temperatures, Temperature
      has_one :pops, POP
      has_one :weather, Weather
      has_one :conditions_icon, ConditionsIcon
      has_one :worded_forecast, WordedForecast
    end

    class Point
      include HappyMapper
      tag 'point'
      attribute :latitude, String
      attribute :longitude, String
    end

    class City
      include HappyMapper
      tag 'city'
      content :name
      attribute :state, String
    end

    class Height
      include HappyMapper
      tag 'height'
      attribute :datum, String
      content :elevation
    end

    class Location
      include HappyMapper
      tag 'location'
      element :'location-key', String
      element :description, String
      has_one :point, Point
      has_one :city, City
      has_one :height, Height
    end

    class Data
      include HappyMapper
      tag 'data'
      has_one :parameters, Parameters
      has_one :location, Location
      has_many :time_layouts, TimeLayout
      attribute :type, String
    end

  end
end
