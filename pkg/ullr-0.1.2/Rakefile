
begin
  require 'bones'
rescue LoadError
  abort '### Please install the "bones" gem ###'
end

require 'rspec/core/rake_task'

desc "Run all examples"
RSpec::Core::RakeTask.new('test') do |t|
end


task :default => 'test'
task 'gem:release' => 'test'

Bones {
  name     'ullr'
  authors  'Timmy Crawford'
  email    'timmydcrawford@gmail.com'
  url      'https://github.com/timmyc/ullr'
}

