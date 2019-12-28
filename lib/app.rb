require_relative 'menu'
require_relative 'scraper'

def run
    menu = Menu.new
    scraper = Scraper.new(menu)
    scraper.start
end 