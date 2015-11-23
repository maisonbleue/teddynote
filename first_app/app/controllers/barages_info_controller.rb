class BaragesInfoController < ApplicationController

	def order_tab
		@array.each do |k|
			if k.include? "French"
				@new_hash["French"] += 2
			elsif (k.include? "TEPitech") || (k.include? "E-Toeic")
				@new_hash[k] = @new_hash.delete("TEPitech")
				@new_hash[k] = 1;
			elsif k.include? "SQL"
				@new_hash["SQL"] = 1
			elsif k.include? "Conf"
				@new_hash["Conf"] = 1
			else k.include? "Network individual tests"
				@new_hash["Reseaux"] = 1
			end
		end
	end

	def parsejson
		@data_hash.each do |key, value|
			if key['modules']
				value.each do |k, v|
					if (k['codemodule'].include? "B-PRO") && (k['title'].include? "French")
						@array << k['title']
					elsif (k['codemodule'].include? "G-EPI") && (k['grade'] == 'Acquis') && (k['title'].include? "Conf")
						@array << k['title']
					elsif (k['codemodule'].include? "B-BDD") && (k['title'].include? "SQL Individual tests") && (k['grade'] != "Echec") && (k['grade'] != "-")
						@array << k['title']
					elsif (k['codemodule'].include? "B-NET") && (k['title'].include? "Network individual tests") && (k['grade'] != "Echec") && (k['grade'] != "-")
						@array << k['title']
					end
				end
			elsif key['notes']
				value.each do |k, v|
					if (k['codemodule'].include? "B-BDD") && (k['final_note'] >= 15) && (k['titlemodule'].include? "SQL Individual tests")
						@array << k['title']
					elsif (k['codemodule'].include? "B-NET") && (k['final_note'] >= 15) && (k['title'].include? "Exam")
						@array << k['title']
					elsif (k['codemodule'].include? "B-ANG") && (((k['final_note'] >= 750) && ((k['titlemodule'].include? "750") || (k['titlemodule'].include? "TEPitech"))) || ((k['final_note'] >= 550) && ((k['titlemodule'].include? "550") || (k['titlemodule'].include? "TEPitech"))) || ((k['final_note'] >= 650) && ((k['titlemodule'].include? "650") || (k['titlemodule'].include? "TEPitech"))))
						if k['scolaryear'] == @yearS
							@array << k['titlemodule']
						end
					end
				end
			end
		end
		order_tab
	end

	def getjson
		login= "ballot_g"
		@yearS = 2015
		cookies = "curl/cookie.txt"
		url = "https://intra.epitech.eu/user/#{login}/notes/?format=json"
		result = `curl -b #{cookies} #{url}`

		@data_hash = JSON.parse(result, opts = {})
	end

	def index
		@array = []
		@new_hash = Hash["Conf" => 0, "SQL" => 0, "Reseaux" => 0, "French" => 0, "TEPitech" => 0]

		getjson
		parsejson
	end

end
