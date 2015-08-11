class CalagatorsController < ApplicationController
	def update
		require 'open-uri'
		# require 'google/api_client'
		interests = ['ruby', 'python', 'javascript'].map(&:downcase)
		res = JSON.parse(open('http://calagator.org/events.json').read)
		res.each do |event|
			p event['title'] if event['title'].downcase.match(/#{interests.join('|')}/) || event['description'].downcase.match(/#{interests.join('|')}/)
		end
	end
end
