require 'date'
ENV["TZ"] = "US/Mountain"
###
# Compass
###

# Change Compass configuration
# compass_config do |config|
#   config.output_style = :compact
# end

###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
# page "/path/to/file.html", :layout => false
#
# With alternative layout
# page "/path/to/file.html", :layout => :otherlayout
#
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

# Proxy pages (http://middlemanapp.com/basics/dynamic-pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", :locals => {
#  :which_fake_page => "Rendering a fake page with a local variable" }

###
# Helpers
###

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

# Reload the browser automatically whenever files change
activate :livereload

# Methods defined in the helpers block are available in templates
# helpers do
#   def some_helper
#     "Helping"
#   end
# end

activate :asset_host
set :asset_host, 'http://assets.calgaryhub.com'

set :css_dir, 'css'
set :js_dir, 'js'
set :images_dir, 'img'

set :mobile_dir, '/mobile.calgaryhub.com'
set :mobile_root, 'http://mobile.calgaryhub.com'

# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  # activate :minify_css

  # Minify Javascript on build
  # activate :minify_javascript

  # Enable cache buster
  activate :asset_hash

  # Use relative URLs
  # activate :relative_assets

  # Or use a different image path
  # set :http_prefix, "/Content/images/"

  activate :directory_indexes

  activate :gzip

  activate :minify_html
end

set :event_date_format, '%F %l:%M %p'

live_events = data.events.select{ |id, event| DateTime.parse(event["start"]) > DateTime.now }
live_events = live_events.map{ |id,ev| ev["id"] = id ; ev }
live_events.sort_by!{ |e| DateTime.parse(e["start"]).to_time.to_i }

page "/about.html"
page "/locations.html"
proxy "/events.html", "/events_list.html", locals: { live_events: live_events }, ignore: true
page "/activities.html"

proxy "#{mobile_dir}/about.html", "/mobile/about.html", :ignore => true
proxy "#{mobile_dir}/index.html", "/mobile/index.html", :ignore => true
proxy "#{mobile_dir}/locations.html", "/mobile/locations.html", :ignore => true
proxy "#{mobile_dir}/events.html", "/mobile/events.html", ignore: true, locals: { events: live_events }
proxy "#{mobile_dir}/activities.html", "/mobile/activities.html", :ignore => true

data.locations.each do |id, place|
  proxy "/location/#{id}.html", "/location_template.html", :locals => { :place => place }, :ignore => true
  proxy "#{mobile_dir}/location/#{id}.html", "/mobile/location_template.html", :locals => { :place => place }, :ignore => true
end

live_events.each do |event|
  proxy "/event/#{event.id}.html", "/event_template.html", :locals => { :event => event, :all_locations => data.locations }, :ignore => true
  proxy "#{mobile_dir}/event/#{event.id}.html", "/mobile/event_template.html", :locals => { :event => event, :all_locations => data.locations }, :ignore => true
end

data.activities.each do |id, activity|
  proxy "/activity/#{id}.html", "/activity_template.html", :locals => { :activity => activity, :all_locations => data.locations }, :ignore => true
  proxy "#{mobile_dir}/activity/#{id}.html", "/mobile/activity_template.html", :locals => { :activity => activity, :all_locations => data.locations }, :ignore => true
end
