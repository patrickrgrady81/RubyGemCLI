class Scraper
    def self.get_recipe_list(food)
        doc = get_page(food)
        scrape_for_recipes(doc)
    end

    def self.get_page(food)
        Nokogiri::HTML(open("https://www.allrecipes.com/search/results/?wt=#{food}&sort=re&page=#1").read)
    end

    def self.scrape_for_recipes(doc)
        recipes = doc.css("div.fixed-recipe-card__info")
        recipes.each{|recipe|
            title = recipe.css("span.fixed-recipe-card__title-link").text
            href = recipe.css("h3.fixed-recipe-card__h3 a").attribute("href").value
            rating = recipe.css("div.fixed-recipe-card__ratings span.stars").attribute("aria-label").text
            description = recipe.css("div.fixed-recipe-card__description").text
            Recipe.new(title, href, rating, description)
        }
    end

    def self.update_recipe(recipe)
        doc = Nokogiri::HTML(open(recipe.href).read)
        scrape_for_ingredients(doc, recipe)
        scrape_for_directions(doc, recipe)
    end

    def self.scrape_for_ingredients(doc, recipe)
        recipe.ingredients = doc.css("span.recipe-ingred_txt, span.ingredients-item-name").map do |el|
            el.text.strip
        end
    end

    def self.scrape_for_directions(doc, recipe)
        directions = doc.css("ol.list-numbers.recipe-directions__list li, li.instructions-section-item p").map{|direction|
            direction.text.strip
        }
        recipe.directions = directions
    end
end