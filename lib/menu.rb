class Menu

    def run
        scraper = Scraper.new
        Recipe.clear_all
        intro
        food = get_food
        scraper.get_recipe_list(food, 1)
        answer = display_recipe_list(food) -1
        answer = display_details(answer, food)
        recipe = Recipe.all[answer]
        scraper.update_recipe(recipe) if !recipe.ingredients
        display_ingredients(recipe.ingredients)
        display_directions(recipe.directions)
        go_again?
    end

    def intro 
        clear_screen
        puts ""
        puts "Hello, I am going to try to find some recipes for you"
    end
    
    def get_food
        print "   What would you like recipes for? : "
        food = gets.chomp
        food = food.gsub(" ", "_")
    end

    def display_recipe_list(food)
        if Recipe.count > 0
            puts ""
            Recipe.all.each.with_index(1){|recipe, index|
                puts "#{index}: #{recipe.title}"
            }
            get_info
        else
            none_found(food)
        end
    end

    def get_info
        print "    Which recipe would you like more information on? (Enter 1 - #{Recipe.count}): "
        inp = gets.chomp.to_i
        if inp.between?(1, Recipe.count)
            return inp 
        else
            puts "Sorry, invalid input, please try again... "
            get_info
        end
    end

    def display_details(recipe_choice, food)
        puts ""
        puts Recipe.all[recipe_choice].title
        puts Recipe.all[recipe_choice].description
        puts Recipe.all[recipe_choice].rating

        puts ""
        puts "1) See this recipe"
        puts "2) Go back"
        puts "3) Exit"
        get_detail_choice(recipe_choice, food)
    end

    def get_detail_choice(recipe_choice, food)
        print "   Please enter your choice (Enter 1-3): "
        answer = gets.chomp.to_i
        if answer.between?(1,3)
        case answer 
            when 1
                return recipe_choice
            when 2
                display_recipe_list(food)
            when 3
                quit
            end
        else 
            puts "Sorry, invalid input, please try again... "
            get_detail_choice(recipe_choice, food)
        end
    end

    def display_ingredients(ingredients)
        puts ""
        puts "INGREDIENTS"
        ingredients.each{|ingredient|
            puts ingredient
        }
    end

    def display_directions(directions)
        puts ""
        puts "DIRECTIONS"
        directions.each_with_index{|d, i|
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
        if answer.between?(1,2)
            case answer
            when 1
                run
            when 2
                quit
            end
        else
            go_again?
        end 
    end

    def clear_screen
        puts "amit"
        if RUBY_PLATFORM =~ /win32|win64|\.NET|windows|cygwin|mingw32/i
           system('cls')
         else
           system('clear')
        end
     end
     

    def say_bye    
        puts ""
        puts "Thank you for using my recipe finder."
        puts "Come back any time you need a new recipe!"
    end

    def quit
        say_bye
        exit!
    end
end