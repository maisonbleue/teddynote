class BaragesInfoController < ApplicationController

	def order_tab
		@array.each do |k|
			if k.include? "French"
				@new_hash["French"] += 2
			elsif k.include? "TEPitech"
				@new_hash["TEPitech"] = 1
			elsif k.include? "SQL"
				@new_hash["SQL"] = 1
			elsif k.include? "Conf"
				@new_hash["Conf"] = 1
			else
				@new_hash["Reseaux"] = 1
			end
		end
	end

	def parsejson
		@data_hash.each do |key, value|
			if key['modules']
				value.each do |k, v|
					if (k['codemodule'].include? "B-PRO") && (k['title'].include? "French") && (k['grade'] != "Echec") && (k['grade'] != "-")
						@array << k['title']
					elsif (k['codemodule'].include? "G-EPI") && (k['grade'] == 'Acquis') && (k['title'].include? "Conf")
						@array << k['title']
					end
				end
			elsif key['notes']
				value.each do |k, v|
					if (k['codemodule'].include? "B-BDD") && (k['final_note'] >= 15) && (k['title'].include? "Test SQL")
						@array << k['title']
					elsif (k['codemodule'].include? "B-NET") && (k['final_note'] >= 15) && (k['title'].include? "Test Reseaux")
						@array << k['title']
					elsif (k['codemodule'].include? "B-ANG") && (k['final_note'] >= 750) && (k['titlemodule'].include? "750")
						@array << k['title']
					end
				end
			end
		end
		order_tab
	end

	def getjson
		login= "anasta_g"
		cookies = "curl/cookie.txt"
		url = "https://intra.epitech.eu/user/#{login}/notes/?format=json"
		result = `curl -b #{cookies} #{url}`

		@data_hash = JSON.parse(result, opts = {})
	end

	def index
		@array = []
		@new_hash = Hash["Conf" => 0, "TEPitech" => 0, "SQL" => 0, "Reseaux" => 0, "French" => 0]

		getjson
		parsejson
	end

end
