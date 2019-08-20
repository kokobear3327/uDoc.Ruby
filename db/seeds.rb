require 'json'

response = RestClient.get("https://data.medicare.gov/resource/c8qv-268j.json")
doctors = JSON.parse(response.body)

doctors.each do | doctor |
	Doctor.create({
		
	})