# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{ullr}
  s.version = "0.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Timmy Crawford}]
  s.date = %q{2011-12-21}
  s.description = %q{ullr is a little gem that consumes NOAA weather xml for a given lat/long, and returns an array of data with 12 hour forecasts along with some sugar to let you know if any sugar will be falling from the sky.}
  s.email = %q{timmydcrawford@gmail.com}
  s.executables = [%q{ullr}]
  s.extra_rdoc_files = [%q{History.txt}, %q{bin/ullr}]
  s.files = [%q{.bnsignore}, %q{History.txt}, %q{README.md}, %q{Rakefile}, %q{bin/ullr}, %q{lib/ullr.rb}, %q{lib/ullr/*.rb}, %q{spec/spec_helper.rb}, %q{spec/ullr_spec.rb}, %q{version.txt}]
  s.homepage = %q{https://github.com/timmyc/ullr}
  s.rdoc_options = [%q{--main}, %q{README.md}]
  s.require_paths = [%q{lib}]
  s.rubyforge_project = %q{ullr}
  s.rubygems_version = %q{1.8.6}
  s.summary = %q{ullr consumes NOAA weather xml for a given lat/long, and returns an array of forecast data.}
  s.test_files = [%q{spec/ullr_spec.rb}]
  s.add_dependency(%q<happymapper>, [">=0.4.0"])

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bones>, [">= 3.7.3"])
    else
      s.add_dependency(%q<bones>, [">= 3.7.3"])
    end
  else
    s.add_dependency(%q<bones>, [">= 3.7.3"])
  end
end
