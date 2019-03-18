require 'open-uri'
require 'nokogiri'
require 'pry'

module Player

    def self.all
        @@all
    end

    def self.clear
        self.all.clear
    end
    
end