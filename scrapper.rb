require 'open-uri'
require 'nokogiri'
require 'csv'
# array having all the peruvian species
all_species = []
# transforming python's csv
table = CSV.parse(File.read("images_count.csv"))
count = {}
table.each do |row|
  count[row[0]] = row[1].to_i
end
# Scrapping
html_content = URI.open('https://biodiversidadacuatica.imarpe.gob.pe/Catalogo/Grupos_Biologicos?id=127').read
doc = Nokogiri::HTML(html_content)


doc.search('#especie').each_with_index do |element, index|
  next if index.odd?
  species = element.search('b').text
  scientific_name = element.search('span').text
  all_species << [species, scientific_name]
end
#adding extra species
extra_species_table = CSV.parse(File.read("extra_species.csv"))

extra_species_table.each do |specie|
  all_species << specie
end

csv = CSV.open("final_csv.csv", "wb")

all_species.each do |row|
  unless count[row[1]].nil?
    csv << [row[0], row[1], count[row[1]]]
  end
end
