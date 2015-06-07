require 'date'
require 'site_details'
require 'icalendar'
require 'haml'
ENV["TZ"] = CityHub::Timezone
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

set :event_datetime_format, '%F %l:%M %p'
set :event_date_format, '%F'
set :pretty_mobile_list_date_format, '%b %d, %Y'
set :sortby_date_format, '%F'

# Methods defined in the helpers block are available in templates
helpers do
  def complete_phone_number num
    "#{CityHub::PhoneCountryCodePrefix}-#{num}"
  end

  def neat_address place
    if place.address
      return "#{place.address}, #{place.city}" if place.city
      return place.address
    end
  end

  def format_ts timestamp, format
    DateTime.parse(timestamp).strftime(format)
  end

  def sortby_date timestamp
    DateTime.parse(timestamp).strftime('%F')
  end

  def pretty_mobile_list_date timestamp
    DateTime.parse(timestamp).strftime('%b %d, %Y')
  end

  def location_name_from_id id
    data.locations[id].title
  end
end

activate :asset_host unless ENV['local_mode']

set :site_title, CityHub::SiteTitle
set :site_tagline, CityHub::SiteTagline
set :asset_host, "https://#{CityHub::AssetURL}"

set :css_dir, 'css'
set :js_dir, 'js'
set :images_dir, 'img'

# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  # activate :minify_css

  # Minify Javascript on build
  # activate :minify_javascript

  # Enable cache buster
  activate :asset_hash

  # Use relative URLs
  activate :relative_assets if ENV['local_mode']

  # Or use a different image path
  # set :http_prefix, "/Content/images/"

  activate :directory_indexes

  activate :gzip

  activate :minify_html
end

set :event_datetime_format, '%b %d, %l:%M %p'
set :event_date_format, '%F'
set :pretty_mobile_list_date_format, '%b %d, %Y'
set :sortby_date_format, '%F'

set :haml, { :ugly => true, :format => :html5 }

live_events = data.events.select{ |id, event|
  if event["end"]
    DateTime.parse(event["end"]) >= DateTime.now
  else
    DateTime.parse(event["start"]) >= DateTime.now
  end
}
live_events = live_events.map{ |id,ev| ev["id"] = id ; ev }
live_events.sort_by!{ |e| DateTime.parse(e["start"]).to_time.to_i }

page "/about.html"
page "/locations.html"
proxy "/events.html", "/events_list.html", locals: { live_events: live_events }, ignore: true
page "/activities.html"

data.locations.each do |id, place|
  proxy "/location/#{id}.html", "/location_template.html", :locals => { :place => place }, :ignore => true
end

cal = Icalendar::Calendar.new
live_events.each do |event|
  proxy "/event/#{event.id}.html", "/event_template.html", :locals => { :event => event, :all_locations => data.locations }, :ignore => true
  cal.event do |e|
    e.summary = event.title
    e.dtstart = DateTime.parse(event.start)
    e.dtend = DateTime.parse(event.end)
    e.description = event.description if event.description
    e.url = event.website if event.website
    e.location = event.locations.map{|l| data.locations[l].title }.join(', ') if event.locations
    e.transp = "TRANSPARENT"
  end
end

fp = File.open('calgaryhub.ical', 'w')
fp.write(cal.to_ical)
fp.close

data.activities.each do |id, activity|
  proxy "/activity/#{id}.html", "/activity_template.html", :locals => { :activity => activity, :all_locations => data.locations }, :ignore => true
end
