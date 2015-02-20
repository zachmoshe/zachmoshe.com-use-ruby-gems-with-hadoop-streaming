#! /usr/bin/env ruby

def handle_results(results)
	best_city = results.sort_by{ |res| res[2].to_f }.first
	puts best_city.join("\t")
end

current_res = []
current_country = nil
ARGF.each_line do |line|
	city_res = line.strip.split("\t")
	if city_res[0] == current_country
		current_res << city_res
	else 
		handle_results(current_res) unless current_res.empty?
		current_res = [city_res]
		current_country = city_res[0]
	end
end

handle_results(current_res) unless current_res.empty?