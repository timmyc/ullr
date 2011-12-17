
begin
  require 'bones'
rescue LoadError
  abort '### Please install the "bones" gem ###'
end

task :default => 'test:run'
task 'gem:release' => 'test:run'

Bones {
  name     'ullr'
  authors  'Timmy Crawford'
  email    'timmydcrawford@gmail.com'
  url      'https://github.com/timmyc/ullr'
}

