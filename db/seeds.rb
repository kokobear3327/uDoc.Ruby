require 'json'
response = RestClient.get("https://data.medicare.gov/resource/c8qv-268j.json?cty=CONROE&st=TX&$limit=200000")
# response = RestClient.get("https://data.medicare.gov/resource/c*qv-268j.json") <-- Use to import the entire database
doctors = JSON.parse(response.body)

doctors.each do | doctor |
	Doctor.create({
		first_name: doctor["frst_nm"],
		last_name: doctor["lst_nm"],
		specialty: doctor["pri_spec"],
		city: doctor["cty"],
		state: doctor["st"]
	})
end