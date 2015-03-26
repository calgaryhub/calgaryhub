# Calgary Hub

This is the code to build calgaryhub.com

The site is created using Middleman. It's a static site generated from json files (that are currently located in another git repo at https://github.com/calgaryhub/calgary_hub_data

# Installation

Run `rake install_deps` in the top-level directory to install the necessary gems.

Run `rake build` to create the site.

Run `rake preview` to run the site locally on port 8000

# Customizing for your city

Interested in creating a similar site for your city? The general framework of the site has been extracted out for easy customization. In order to tailor the site to your city, adjust the following:

* `/site_details.rb` - constants such as timezone, site title, and URLs
* `/source/css/cityhub.css` - mobile jQuery CSS created by ThemeRoller (http://themeroller.jquerymobile.com/)
* `/source/img/app_icon.png` - icon for mobile site
* `/source/img/app_startup.png` - load screen for mobile site

# Contributing

Please see the GitHub issues page for bug reports and enhancement ideas.

The codebase is 'stable' insofar as it is currently in use for calgaryhub.com.

# License

The codebase is BSD-licensed except where otherwise noted in code headers of third-party libraries. See LICENSE for details
