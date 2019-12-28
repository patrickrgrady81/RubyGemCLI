require_relative 'recipe'
require 'open-uri'
require 'nokogiri'

class Scraper
    attr_accessor :food, :menu

    def initialize(menu)
        self.menu = menu 
        
    end

    def start
        continue = true
        while continue do 
            self.food = self.menu.intro
            doc = self.get_page(1)
            self.scrape(doc, 1)
        
            choice = self.menu.display_recipes
        
            doc = self.get_full_recipe(choice - 1)
            self.scrape(doc, 2)
            continue = self.menu.go_again?
        end
        self.menu.say_bye
    end

    def scrape(doc, level)
        case level
        when 1
            recipes = doc.css("div.fixed-recipe-card__info")
            recipes.each{|recipe|
                title = recipe.css("span.fixed-recipe-card__title-link").text
                href = recipe.css("h3.fixed-recipe-card__h3 a").attribute("href").value
                rating = recipe.css("div.fixed-recipe-card__ratings span.stars").attribute("aria-label").text
                description = recipe.css("div.fixed-recipe-card__description").text
                Recipe.new(title, href, rating, description)
            }

        when 2
            ingredient_list = []
            index = 1
            while doc.css("ul#lst_ingredients_" + index.to_s).count > 0 do
                doc.css("ul#lst_ingredients_" + index.to_s + " li").each{|ing|
                    ingredient_list << ing.inner_text.strip.to_s
                }
                index += 1
            end
            ingredient_list = ingredient_list[0...-1]
            self.menu.display_ingredients(ingredient_list)


            directions_list = []
            directions = doc.css("ol.list-numbers.recipe-directions__list li").each{|direction|
                 directions_list << direction.text.strip
            }
            self.menu.display_directions(directions_list)
        end
    end

    def get_page(page)
        #https://www.allrecipes.com/search/results/?wt=apples&sort=re&page=1
        doc = Nokogiri::HTML(open("https://www.allrecipes.com/search/results/?wt=#{self.food}&sort=re&page=#{page}").read)
        return doc
    end

    def get_full_recipe(choice)
        url = Recipe.all[choice].href
        doc = Nokogiri::HTML(open(url).read)
        return doc
    end
end