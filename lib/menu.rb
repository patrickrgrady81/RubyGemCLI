require 'colorize'
class Menu
    attr_accessor :recipe_choice

    def intro
        puts ""
        puts "Hello, I am going to try to find some recipes for you"
        print "   What would you like recipes for? : "
        food = gets.chomp
        food = food.gsub(" ", "_")
        return food
    end

    def display_recipes
        if Recipe.all.count > 0
            index = 1
            puts ""
            Recipe.all.each{|recipe|
                puts "#{index}: #{recipe.title}"
                index += 1
            }
            print "    Which recipe would you like more information on? (Enter 1 - #{index-1}): "
            answer = gets.chomp
            display_details(answer.to_i)
        else
            return 0
        end
    end

    def display_details(choice)
        self.recipe_choice = choice
        puts ""
        recipe = choice - 1
        puts Recipe.all[recipe].title.bold.underline
        puts Recipe.all[recipe].description
        puts Recipe.all[recipe].rating

        puts ""
        puts "1) See this recipe"
        puts "2) Go back"
        puts "3) Exit"

        print "   Please enter your choice (Enter 1-3): "
        choice = gets.chomp.to_i

        case choice 
        when 1
            return self.recipe_choice
        when 2
            display_recipes
        when 3
            say_bye
            exit!
        end
    end

    def display_ingredients(ingredient_list)
        puts ""
        puts "INGREDIENTS".bold.underline
        ingredient_list.each{|ingredient|
            puts ingredient
        }
    end

    def display_directions(direction_list)
        puts ""
        puts "DIRECTIONS".bold.underline
        direction_list.each_with_index{|d, i|
            puts "#{i+1}) #{d}" if d!= ""
        }
    end

    def none_found(food)
        puts ""
        puts "Sorry, no recipes were found for '#{food}''"
        go_again?
    end

    def go_again?
        puts ""
        print "   Would you like to search again? (1: yes, 2: no): "
        answer = gets.chomp.to_i
        case answer
        when 1
            return true
        when 2
            return false
        end
    end

    def say_bye    
        puts ""
        puts "Thank you for using my recipe finder."
        puts "Come back any time you need a new recipe!"
    end
end