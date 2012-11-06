ullr
===========

ullr is a little gem that consumes NOAA weather xml for a given lat/long, and returns a ruby object with 12 hour forecasts along with some sugar to let you know if any sugar will be falling from the sky.

Features
--------

* Grabs data that powers point forecast pages (http://forecast.weather.gov/MapClick.php?lat=43.98886243884903&lon=-121.68182373046875&site=pdt&smap=1&unit=0&lg=en&FcstType=text)
* Returns object with access to forecasted start_time, name (i.e. This Evening), text (i.e. Mostly sunny, high near 19), snow boolean, high_temperature, low_temperature, wind_direction, wind_speeds (array of low,high), snow_estimate (array of low,high)

Examples
--------

* iheartsnow = Ullr::Forecast.new(:lat => 43.98, :lon => -121.68)
* iheartsnow.get_noaa_forecast

Run Tests
---------

rake test

Stuff To Do
-----------

* Add support for other data sources (weatherbug, wunderground etc)
* Some more integration tests

Requirements
------------

* happymapper

Install
-------

* gem 'ullr'

Author
------

Original author: Timmy Crawford 

License
-------

The MIT License

Copyright (c) 2011 Timmy Crawford

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
