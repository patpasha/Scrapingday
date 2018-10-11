require 'rubygems'
require 'nokogiri'         
require 'open-uri'

doc = Nokogiri::HTML(open("https://www.nosdeputes.fr/deputes"))
noms_deputes = doc.css('div > span.list_nom').map do |keys|
	keys.text
end

def deputes_downcase(array)
	array.map do |n|
		n.downcase
	end
end

deputes_downcased = deputes_downcase(noms_deputes)

def supprimer_espace_debut(array)
    array.map do |n|
        n.lstrip.rstrip
    end
end

espace_supprime = supprimer_espace_debut(deputes_downcased)

def depute_caracspeciaux(array)
    array.map do |n|
        a = n.tr(" ", "-").tr("àáâéèêëçïîìíô'", "aaaeeeeciiiio-").gsub("ö", "oe").gsub(/\n/, "")
    end
end

depute_sanscarac = depute_caracspeciaux(espace_supprime)

def selectionne_prenoms(array)
    array.map do |n|
        n.partition(",-").last
    end
end

def selectionne_noms(array)
    array.map do |n|
        n.partition(",-").first
    end
end

noms =  selectionne_noms(depute_sanscarac)
prenoms = selectionne_prenoms(depute_sanscarac)

site_web = noms.zip(prenoms).map {|noms, prenoms| "https://www.nosdeputes.fr/#{prenoms}-#{noms}"}


=begin
def emails_scrap(array)
    array.map do |emails|
doc = Nokogiri::HTML(open(emails))
emails_deputes = doc.css('#b1 > ul:nth-child(4) > li:nth-child(1) > ul > li:nth-child(1) > a').text
    end
end

email = puts emails_scrap(site_web)
=end

# !!!! Enlever le commentaire au dessus si besoin de rescrapper les mails. Sinon ils sont stockés dans un fichier 
# "emails.txt" !!!!

emails = File.readlines("emails.txt")

def emails_remove_n(array)
    array.map do |n|
        n.delete("/\n/")
    end
end

emails_final = emails_remove_n(emails)

def capitalize(array)
    array.map do |n|
        n.capitalize
    end
end

noms_capital = capitalize(noms)
prenoms_capital = capitalize(prenoms)

array_final = []
x = 0

while x < prenoms_capital.size
    array_final << { "Prenom" => prenoms_capital[x], "Nom" => noms_capital[x], "Email" => emails_final[x] }
      puts "\n***************************************************************************************************************************"
      puts array_final[x]
      puts "***************************************************************************************************************************\n"
    x += 1
end











