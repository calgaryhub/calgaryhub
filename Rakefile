build_directory = "#{Dir.pwd}/build"
port = ENV['HTTP_PORT'] || 8000
task default: %w[preview]

task :serve do
  require 'webrick'
  s = WEBrick::HTTPServer.new(
    :Port => port,
    :DocumentRoot => build_directory
  )
  trap('INT') { s.shutdown }
  s.start
end

task :preview => [:build, :serve]

task :install_deps do
  sh 'bundle install --standalone'
end

task :build do
  sh 'bundle exec middleman build --verbose'
end
