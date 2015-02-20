#! /usr/bin/env ruby

gem 'geokit', '1.5.0'  # later versions have some problem with OpenSSL which are not related to this demonstration
require 'geokit'

ARGF.each_line do |line|
	country_code, city, city_lat, city_long, country_center_lat, country_center_long = line.split("\t")
	distance = GeoKit::LatLng.distance_between [city_lat, city_long], [country_center_lat, country_center_long], {units: :kms}
	puts "#{country_code}\t#{city}\t#{distance}"
end
