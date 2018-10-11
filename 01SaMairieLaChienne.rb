require 'rubygems'
require 'nokogiri'         
require 'open-uri'

# Workflow:
# Chopper les villes
# Passer les villes en minuscules
# URL remplace les espaces et les apostrophes par des -
# URL = http://annuaire-des-mairies.com/95/ + nom_de_la_ville + .html
# Loop qui met chaque URL de cet array dans le nokogiri

doc = Nokogiri::HTML(open("http://annuaire-des-mairies.com/val-d-oise.html"))
villes = doc.css('a.lientxt').map do |keys|
	keys.text
end
# J'ai mes villes

def villes_downcase(array)
	array.map do |n|
		n.downcase
	end
end
# Je les downcase (sinon bah ERROR 404)

villes_downcased = villes_downcase(villes)

def remove_villes_tirrets(array)
	array.each do |n|
		n.gsub!(/ /,'-')
	end
end
# Methode qui remplace tous les espaces par des - dans un array

villes_site = remove_villes_tirrets(villes_downcased)
# Application de la méthode sur mon array des villes

site_web = villes_site.map {|word| "http://annuaire-des-mairies.com/95/#{word}.html"}
# Créé un array avec chaque site web de chaque ville

def emails_scrap(array)
	array.map do |mails|
		doc = Nokogiri::HTML(open(mails))
			doc.css('body > div > main > section:nth-child(2) > div > table > tbody > tr:nth-child(4) > td:nth-child(2)').text
	end
end
# Loop sur chaque site de mon array dans nokogiri pour aller chercher les mails de ces villes

emails = emails_scrap(site_web)

final_hash = Hash[villes.zip(emails)] 

puts final_hash

# PUTAIN CA MARCHE!!!!!


