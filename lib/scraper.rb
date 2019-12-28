
require_relative 'recipe'

class Scraper
    attr_accessor :first_time
    def initialize
        self.first_time = true
    end

    def scrape(doc)
        if self.first_time == true
            self.first_time = false
            recipes = doc.css("div.fixed-recipe-card__info")
            recipes.each{|recipe|
                title = recipe.css("span.fixed-recipe-card__title-link").text
                href = recipe.css("h3.fixed-recipe-card__h3 a").attribute("href").value
                rating = recipe.css("div.fixed-recipe-card__ratings span.stars").attribute("aria-label").text
                description = recipe.css("div.fixed-recipe-card__description").text
                Recipe.new(title, href, rating, description)
            }
        else
            ingerdient_list = []
            index = 1
            while doc.css("ul#lst_ingredients_" + index.to_s).count > 0 do
                doc.css("ul#lst_ingredients_" + index.to_s + " li").each{|ing|
                    ingerdient_list << ing.inner_text.strip.to_s
                }
                index += 1

            end
            
            ingerdient_list = ingerdient_list[0...-1]
            puts ""
            puts "INGREDIENTS".bold.underline
            ingerdient_list.each{|ingredient|
                puts ingredient
            }
            directions_list = []
            directions = doc.css("ol.list-numbers.recipe-directions__list li").each{|direction|
                 directions_list << direction.text.strip
            }

            puts ""
            puts "DIRECTIONS".bold.underline
            directions_list.each_with_index{|d, i|
                puts "#{i+1}) #{d}" if d!= ""


            }
        end
    end
end