build_directory = "#{Dir.pwd}/build"
port = ENV['HTTP_PORT'] || 8000
task default: %w[preview]

desc "Start dev httpd server (default port 8000)"
task :serve do
  require 'webrick'
  s = WEBrick::HTTPServer.new(
    :Port => port,
    :DocumentRoot => build_directory
  )
  trap('INT') { s.shutdown }
  s.start
end

desc "Monitor and rebuild on changes"
task :guard do
  sh 'bundle exec guard'
end

desc "Build and serve the site in development"
task :preview => [:build, :serve]

desc "Install build dependencies"
task :install_deps do
  sh 'bundle install --path bundled_gems'
end

desc "Build site"
task :build do
  sh 'bundle exec middleman build --verbose'
end
