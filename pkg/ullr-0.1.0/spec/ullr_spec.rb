
require File.join(File.dirname(__FILE__), %w[spec_helper])

describe Ullr do
  context Ullr::NOAA do
    before do
      @noaa_fixture = File.new( File.join(File.dirname(__FILE__),'fixtures','noaa.xml'))
      @noaa_data = @noaa_fixture.read
    end

    context Ullr::NOAA::Data do
      before do
        @results = Ullr::NOAA::Data.parse(@noaa_data)
      end

      it "should find two data elements" do
        @results.size.should eql(2)
      end

      context 'Forecast Data' do
        before do
          @data = @results.find{|o| o.type == 'forecast'}
        end

        it "should respond to type" do
          @data.respond_to?(:type).should be_true
        end

        it "should have a type of forecast" do
          @data.type.should eql('forecast')
        end

        context 'Paremeters' do
          before do
            @parameters = @data.parameters
          end
          
          it "should have one parameters" do
            @parameters.instance_of?(Ullr::NOAA::Parameters).should be_true
          end

          context 'Worded Forecast' do
            before do
              @worded_forecast = @parameters.worded_forecast
            end
            
            it "should have one worded_forecast" do
              @worded_forecast.instance_of?(Ullr::NOAA::WordedForecast).should be_true
            end

            it "should have a time-layout" do
              @worded_forecast.time_layout.should eql('k-p12h-n13-1')
            end

            it "should have a data_source" do
              @worded_forecast.dataSource.should eql('pdtNetcdf')
            end

            it "should have a wordGenerator" do
              @worded_forecast.wordGenerator.should eql('markMitchell')
            end

            context 'Text' do
              before do
                @text = @worded_forecast.texts.first
              end

              it "should have many icon_links" do
                @worded_forecast.texts.instance_of?(Array).should be_true
              end

              it "should have a value" do
                @text.value.should eql('A 20 percent chance of snow.  Partly sunny, with a high near 39. West wind around 9 mph. ')
              end

              it "should respond to has_snow?" do
                @text.respond_to?(:has_snow?).should be_true
              end

              it "should return true to has_snow? if snow exists" do
                @text.has_snow?.should be_true
              end

              it "should return false to has_snow? if no snow exists" do
                @text.value = "foo"
                @text.has_snow?.should be_false
              end

              it "should respond to snow_estimate" do
                @text.respond_to?(:snow_estimate).should be_true
              end

              it "should return [0,1] as the estimate when snow exists but no estimate given" do
                @text.snow_estimate.should eql(['0','1'])
              end

              it "should return zeros when no snow exists" do
                @text.value = "foo"
                @text.snow_estimate.should eql(['0','0'])
              end

              it "should return the proper snow estimate when range is given" do
                @text.value = "blah blah blah. New snow accumulation of 6 to 8"
                @text.snow_estimate.should eql(['6','8'])
              end

              it "should support sickter double digit days" do
                @text.value = "blah blah blah. New snow accumulation of 16 to 18"
                @text.snow_estimate.should eql(['16','18'])
              end

              it "should support less than an inch" do
                @text.value = "blah blah blah around an inch possible"
                @text.snow_estimate.should eql(['0','1'])
              end

              context 'Temperatures' do
                it "should set a low temperature if present" do
                  @text.value = "Mostly cloudy, with a low around 27. North wind between 5 and 8 mph."
                  @text.low_temperature.should eql('27')
                end
                it "should not set a low temperature if none present" do
                  @text.value = "Mostly cloudy, with a high near 39. Northwest wind around 9 mph."
                  @text.low_temperature.should eql('')
                end
                it "should set a high temperature if present" do
                  @text.value = "Mostly cloudy, with a high near 39. Northwest wind around 9 mph."
                  @text.high_temperature.should eql('39')
                end
                it "should not set a high temperature if none present" do
                  @text.value = "Mostly cloudy, with a low around 27. North wind between 5 and 8 mph."
                  @text.high_temperature.should eql('')
                end
              end

              context 'Winds' do
                it "should set a wind direction if present" do
                  @text.value = "Mostly sunny, with a high near 38. East wind around 5 mph."
                  @text.wind_direction.should eql('east')
                end
                it "should not set a wind direction if none present" do
                  @text.value = "Mostly sunny, with a high near 38."
                  @text.wind_direction.should eql('')
                end
                it "should return an array of wind speeds with the same value" do
                  @text.value = "Mostly sunny, with a high near 38. East wind around 5 mph."
                  @text.wind_speeds.should eql(['5','5'])
                end
                it "should return an array of wind speeds with the min and max values" do
                  @text.value = "Mostly sunny, with a high near 38. North wind between 5 and 8 mph."
                  @text.wind_speeds.should eql(['5','8'])
                end
                it "should return an empty array if not wind data present" do
                  @text.value = "Mostly sunny, with a high near 38."
                  @text.wind_speeds.should eql(['',''])
                end
              end
            end

          end
          
          context 'Icons' do
            before do
              @icons = @parameters.conditions_icon
            end
            
            it "should have one weather" do
              @icons.instance_of?(Ullr::NOAA::ConditionsIcon).should be_true
            end

            it "should have a time-layout" do
              @icons.time_layout.should eql('k-p12h-n13-1')
            end

            it "should have a name" do
              @icons.name.should eql('Conditions Icon')
            end

            context 'Icon Links' do
              before do
                @icon_link = @icons.icon_links.first
              end

              it "should have many icon_links" do
                @icons.icon_links.instance_of?(Array).should be_true
              end

              it "should have a url" do
                @icon_link.url.should eql("http://forecast.weather.gov/images/wtf/sn20.jpg")
              end
            end

          end

          context 'Weather' do
            before do
              @weather = @parameters.weather
            end
            
            it "should have one weather" do
              @weather.instance_of?(Ullr::NOAA::Weather).should be_true
            end

            it "should have a time-layout" do
              @weather.time_layout.should eql('k-p12h-n13-1')
            end

            it "should have a name" do
              @weather.name.should eql('Weather Type, Coverage, Intensity')
            end

            context 'Weather Conditions' do
              before do
                @weather_conditions = @weather.weather_conditions.first
              end

              it "should have many weather_conditions" do
                @weather.weather_conditions.instance_of?(Array).should be_true
              end

              it "should have a weather_summary" do
                @weather_conditions.weather_summary.should eql("Slight Chc Snow")
              end
            end

          end

          context 'Probability of Precipitation' do
            it "should have one pops" do
              @parameters.pops.instance_of?(Ullr::NOAA::POP).should be_true
            end

            context 'instance of' do
              before do
                @pop = @parameters.pops
              end

              it "should have a type" do
                @pop.type.should eql('12 hour')
              end

              it "should have a units" do
                @pop.units.should eql('percent')
              end

              it "should have a time_layout" do
                @pop.time_layout.should eql('k-p12h-n13-1')
              end

              it "should have many values" do
                @pop.values.instance_of?(Array).should be_true
              end

              it "should have the correct number of values" do
                @pop.values.size.should eql(13)
              end
            end
          end

          context 'Temperatures' do
            it "should have many temperatures" do
              @parameters.temperatures.instance_of?(Array).should be_true
            end

            context 'instance of' do
              before do
                @temperature = @parameters.temperatures.first
              end

              it "should have a type" do
                @temperature.type.should eql('maximum')
              end

              it "should have a units" do
                @temperature.units.should eql('Fahrenheit')
              end

              it "should have a time_layout" do
                @temperature.time_layout.should eql('k-p24h-n7-1')
              end
            end
          end
        end

        context 'TimeLayouts' do
          it "should have many time_layouts" do
            @data.time_layouts.instance_of?(Array).should be_true
          end

          it "should have four time_layouts" do
            @data.time_layouts.size.should eql(4)
          end

          context 'Instance of TimeLayout' do
            before do
              @time_layout = @data.time_layouts[1]
            end

            it "should have a time_coordinate" do
              @time_layout.time_coordinate.should eql('local')
            end

            it "should have a summarization" do
              @time_layout.summarization.should eql('12hourly')
            end

            it "should have a layout_key" do
              @time_layout.layout_key.should eql('k-p12h-n13-1')
            end

            context 'Start Valid Times' do
              it "should have many start_valid_times" do
                @time_layout.start_valid_times.instance_of?(Array).should be_true
              end

              it "should have two start_valid_times" do
                @time_layout.start_valid_times.size.should eql(13)
              end

              context 'Instance of' do
                before do
                  @start_valid_time = @time_layout.start_valid_times.first
                end

                it "should have a period_name" do
                  @start_valid_time.period_name.should eql('This Afternoon')
                end

                it "should have a DateTime period_start" do
                  @start_valid_time.period_start.should eql(DateTime.parse('2011-12-18T12:00:00-08:00'))
                end
              end
            end
          end
        end

        context 'Location' do
          before do
            @location = @data.location
          end

          it "should have one location" do
            @location.instance_of?(Ullr::NOAA::Location).should be_true
          end

          it "should have a key" do
            @location.location_key.should eql('point1')
          end

          it "should have a description" do
            @location.description.should eql('Mount Bachelor, OR')
          end

          context 'Point' do
            before do
              @point = @location.point
            end

            it "should have one point" do
              @point.instance_of?(Ullr::NOAA::Point).should be_true
            end

            it "should have a latitude" do
              @point.latitude.should eql('43.99')
            end
            
            it "should have a longitude" do
              @point.longitude.should eql('-121.68')
            end
          end

          context 'City' do
            before do
              @city = @location.city
            end

            it "should have one city" do
              @city.instance_of?(Ullr::NOAA::City).should be_true
            end

            it "should have a name" do
              @city.name.should eql('Mount Bachelor')
            end

            it "should have a state" do
              @city.state.should eql('OR')
            end
          end

          context 'Height' do
            before do
              @height = @location.height
            end

            it "should have one height" do
              @height.instance_of?(Ullr::NOAA::Height).should be_true
            end

            it "should have an elevation" do
              @height.elevation.should eql('7636')
            end

            it "should have a datum" do
              @height.datum.should eql('mean sea level')
            end
          end
        end

        it "should have many time layouts" do
          @data.time_layouts.instance_of?(Array).should be_true
        end
      end
    end
  end

  context Ullr::Forecast do
    before do
      @noaa_fixture = File.new( File.join(File.dirname(__FILE__),'fixtures','noaa.xml'))
    end
    describe "required options" do
      it "should require a lon to be passed in" do
        expect{ Ullr::Forecast.new(:lat => 'blah') }.to raise_error(ArgumentError)
      end

      it "should require a lat to be passed in" do
        expect{ Ullr::Forecast.new(:lon => 'blah') }.to raise_error(ArgumentError)
      end

      it "should require lat,lon to be floating points" do
        expect{ Ullr::Forecast.new(:lat => 'blah', :lon => 'meh') }.to raise_error(ArgumentError)
      end

      it "should not rais an error if lat lon are passed and are both floats" do
        expect{ Ullr::Forecast.new(:lat => 43.98, :lon => -121.68) }.to_not raise_error(ArgumentError)
      end
    end

    describe "instance varialbes" do
      before do
        @lat = 43.98
        @lon = -121.68
        @forecast = Ullr::Forecast.new(:lat => @lat, :lon => @lon)
      end

      it "should set the lat lng instance variables" do
        @forecast.lat.should eql(@lat)
        @forecast.lon.should eql(@lon)
      end

      it "should set the endpoint instance variable" do
        @forecast.noaa_endpoint.should eql("http://forecast.weather.gov/MapClick.php?lat=#{@lat}&lon=#{@lon}&FcstType=dwml")
      end
    end

    describe "get noaa data" do
      before do
        @lat = 43.98
        @lon = -121.68
        @forecast = Ullr::Forecast.new(:lat => @lat, :lon => @lon)
      end

      it "should call open to endpoint url" do
        @forecast.should_receive(:open).with(@forecast.noaa_endpoint).and_return(@noaa_fixture)
        @forecast.get_noaa_forecast
      end

      it "should handle socket errors to noaa endpoint" do
        @forecast.should_receive(:open).with(@forecast.noaa_endpoint).and_raise(SocketError)
        @forecast.get_noaa_forecast
        @forecast.socket_error.should be_true
      end
    end

  end
end

