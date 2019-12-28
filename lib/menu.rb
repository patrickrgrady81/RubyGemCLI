require 'colorize'
class Menu
    attr_accessor :recipe_choice

    def intro
        puts "Hello, I am going to try to find some recipes for you"
        print "What would you like recipes for? : "
        food = gets.chomp
        food = food.gsub(" ", "_")
        food
    end

    def display_recipes
        index = 1
        puts ""
        Recipe.all.each{|recipe|
            puts "#{index}: #{recipe.title}"
            index += 1
        }
        print "Which recipe would you like more information on? (Enter 1 - #{index-1}): "
        self.recipe_choice = gets.chomp.to_i
        self.display_details(self.recipe_choice)
    end

    def display_details(choice)
        puts ""
        puts Recipe.all[choice-1].title.bold.underline
        puts Recipe.all[choice-1].description
        puts Recipe.all[choice-1].rating
        self.display_choices
    end

    def display_choices
        puts ""
        puts "1) See this recipe"
        puts "2) Go back"
        puts "3) Exit"

        print "Please enter your choice (Enter 1-3): "
        choice = gets.chomp.to_i

        case choice 
        when 1
            return self.recipe_choice
        when 2
            self.dsiplay_recipes
        when 3
            exit!
        end
    end
end