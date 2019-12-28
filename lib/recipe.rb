class Recipe
    attr_accessor :title, :href, :rating, :description

    @@all = []

    def initialize(title, href, rating, description)
        self.title = title.strip
        self.href = href
        self.rating = rating
        self.description = description

        @@all << self
    end

    def self.all 
        @@all
    end

    def self.clear_all
        @@all.clear
    end
end