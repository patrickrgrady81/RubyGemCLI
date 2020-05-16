class Menu
    def run
        Recipe.clear_all
        intro
        food = get_food
        Scraper.get_recipe_list(food)
        display_recipe_list 
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

    def display_recipe_list
        if Recipe.count > 0
            clear_screen
            Recipe.all.each.with_index(1){|recipe, index|
                puts "#{index}: #{recipe.title}"
            }
            which_recipe_info?
        else
            none_found
        end
    end

    def which_recipe_info?
        print "    Which recipe would you like more information on? (Enter 1 - #{Recipe.count}): "
        inp = (gets.chomp.to_i) -1
        if inp.between?(0, Recipe.count-1)
            display_details(inp) 
        else
            puts "Sorry, invalid input, please try again... "
            which_recipe_info?
        end
    end

    def display_details(recipe_choice)
        clear_screen
        puts Recipe.all[recipe_choice].title
        puts Recipe.all[recipe_choice].description
        puts Recipe.all[recipe_choice].rating

        puts ""
        puts "1) See this recipe"
        puts "2) Go back"
        puts "3) Exit"
        get_detail_choice(recipe_choice)
    end

    def get_detail_choice(recipe_choice)
        print "   Please enter your choice (Enter 1-3): "
        answer = gets.chomp.to_i
        if answer.between?(1,3)
        case answer 
            when 1
                ingredients_and_directions(recipe_choice)
            when 2
                display_recipe_list
            when 3
                quit
            end
        else 
            puts "Sorry, invalid input, please try again... "
            get_detail_choice(recipe_choice)
        end
    end

    def ingredients_and_directions(recipe_choice)
        recipe = Recipe.all[recipe_choice]
        Scraper.update_recipe(recipe) if !recipe.ingredients
        clear_screen
        display_ingredients(recipe.ingredients)
        display_directions(recipe.directions)
        go_again?
    end

    def display_ingredients(ingredients)
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
            puts ""
        }
    end

    def none_found
        puts ""
        puts "Sorry, no recipes were found..."
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
            puts "Sorry, invalid input, please try again... "
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
        puts "Thank you for using my recipe finder."
        puts "Come back any time you need a new recipe!"
    end

    def quit
        clear_screen
        say_bye
        exit!
    end
end