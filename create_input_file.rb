#! /usr/bin/env ruby

require 'csv'

# countries file URL: http://opengeocode.org/cude/download.php?file=/home/fashions/public_html/opengeocode.org/download/cow.txt
countries_file = File.readlines("cow.txt").reject{ |line| line =~ /^\uFEFF?#/u }[1..-1].map{ |line| line.split /\s*;\s*/ }

# Fields are (metadata is available here: http://opengeocode.org/download/cow.php): 
#  0 - country code
#  63 - maximum longitude for the country
#  64 - minimum longitude for the country
#  65 - maximum latitude
#  66 - minimum latitude

# ctry2avglatlong = { country => [avg_lat, avg_long] }
ctry2avglatlong = countries_file.map{ |row| [row[0], [(row[64].to_f+row[63].to_f)/2,(row[66].to_f+row[65].to_f)/2]] }.to_h

# cities file URL: http://opengeocode.org/download/worldcities.zip (file is inside the zip)
cities_file = File.readlines("worldcities.csv")[1..-1].map{ |line| CSV.parse(line).first }

# For each city, take its own lat/long and the country's average.
# Fields are: 
# 0 - country code
# 5 - city name
# 6 - city lat 
# 7 - city long
data = cities_file.map{ |row| [row[0], row[5], row[6].to_f, row[7].to_f] + ctry2avglatlong[row[0]] rescue nil}.compact

File.write("input.txt", data.map{ |row| row.join("\t") }.join("\n"))

puts "Done. input.txt is ready"

