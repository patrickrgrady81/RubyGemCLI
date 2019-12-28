require 'pry'
require 'open-uri'
require 'nokogiri'
require_relative 'recipe'
require_relative 'menu'
require_relative 'scraper'

def run
    menu = Menu.new
    scraper = Scraper.new
    food = menu.intro
    doc = Nokogiri::HTML(open("https://www.allrecipes.com/search/results/?wt=#{food}&sort=re").read)
    scraper.scrape(doc)
    choice = menu.display_recipes

    url = Recipe.all[choice-1].href
    doc = Nokogiri::HTML(open(url).read)
    scraper.scrape(doc)
end 

#TODO - Add footnotes and maybe comments