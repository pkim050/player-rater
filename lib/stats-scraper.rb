class Combine::StatsScraper
    attr_accessor :name, :fg, :ft, :tpm, :reb, :ast, :stl, :blk, :pts, :ovr, :card, :indicator

    @@all = [] #Collects each player

    def self.scrape
        doc = Nokogiri::HTML(open("https://www.fantasypros.com/nba/player-rater.php"))
        chart = doc.css("tbody")
        chart.css("tr").each do |element|
            #player_rank = element.css("td").first.text     Does not matter since if you sort by any categories, numbers would change
            player = Combine::StatsScraper.new
            player.name = element.css(".player-label").text.strip
            player.card = element.css(".player-label a").first['href']
            player.fg = element.css("td")[2].text.to_f
            player.ft = element.css("td")[3].text.to_f
            player.tpm = element.css("td")[4].text.to_f
            player.reb = element.css("td")[5].text.to_f
            player.ast = element.css("td")[6].text.to_f
            player.stl = element.css("td")[7].text.to_f
            player.blk = element.css("td")[8].text.to_f
            player.pts = element.css("td")[9].text.to_f
            player.ovr = element.css("td").last.text.to_f
            self.all << player
        end
        self.all
    end

    def self.all
        @@all
    end

    def self.clear
        self.all.clear
    end

    def self.statsscraper(num = 1)
        #arr = []
        self.all.select {|element| element.tpm >= num}
        #arr
    end
end