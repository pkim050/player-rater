class Combine::News
    attr_accessor :p1, :p2, :p3, :p4, :author, :timestamp, :name, :pos, :height, :weight, :age, :college, :drafted

    @@all = []
    
    def initialize(doc)
        @name = doc.css(".pull-left h1").text
        @pos = doc.css(".pull-left h5").text.strip
        doc.css(".bio-detail").each do |element|
            @height = element.text if element.text.include?("Height")
            @weight = element.text if element.text.include?("Weight")
            @age = element.text if element.text.include?("Age")
            @college = element.text if element.text.include?("College")
            @drafted = element.text if element.text.include?("Drafted")
        end
    end

    def self.news(player, url)
        doc = Nokogiri::HTML(open(url))
        doc.css(".subsection.feature-stretch").each do |element|
            new_news = Combine::News.new(doc)
            if element.text.include?("no news")
                new_news.p1 = element.text.strip
                new_news.p2 = element.text.strip
                new_news.p3 = element.text.strip
                new_news.p4 = element.text.strip
            else
                new_news.p1 = element.css(".content a").text.strip
                new_news.p2 = element.css("p")[0].text.strip
                new_news.p3 = element.css("p")[1].text
                new_news.p4 = element.css("p")[2].text
                new_news.author = element.css("a.pull-left").text
                new_news.timestamp = element.css(".pull-right.timestamp").text
            end
            self.all << new_news
        end
        self.all
    end

    def self.all
        @@all
    end

    def self.clear
        self.all.clear
    end
end