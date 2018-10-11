require 'rubygems'
require 'nokogiri'         
require 'open-uri'

doc = Nokogiri::HTML(open("https://coinmarketcap.com/all/views/all/"))
nom_monnaies = doc.css('a.currency-name-container').map do |keys|
	keys.text
end

doc = Nokogiri::HTML(open("https://coinmarketcap.com/all/views/all/"))
valeur_monnaies = doc.css('a.price').map do |keys|
	keys.text
end

final_hash = Hash[nom_monnaies.zip(valeur_monnaies)]

puts final_hash