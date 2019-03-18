class Combine::CareerStats
    attr_accessor :season, :team, :games, :min, :fgm, :fga, :fgp, :tpm, :tpa, :tpp, :ftm, :fta, :ftp, :offreb, :defreb, :reb, :ast, :to, :stl, :blk, :pf, :pts, :name, :pos, :height, :weight, :age, :college, :drafted
    
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
    
    def self.stats(player, url)
        doc = Nokogiri::HTML(open(url))
        doc.css("tbody tr").each do |element|
            stats = Combine::CareerStats.new(doc)
            stats.season = element.css("td")[0].text.to_i
            stats.team = element.css("td")[1].text
            stats.games = element.css("td")[2].text.to_i
            stats.min = element.css("td")[3].text.delete(",").to_i
            stats.fgm = element.css("td")[4].text.delete(",").to_i
            stats.fga = element.css("td")[5].text.delete(",").to_i
            stats.fgp = element.css("td")[6].text.to_f
            stats.tpm = element.css("td")[7].text.delete(",").to_i
            stats.tpa = element.css("td")[8].text.delete(",").to_i
            stats.tpp = element.css("td")[9].text.to_f
            stats.ftm = element.css("td")[10].text.delete(",").to_i
            stats.fta = element.css("td")[11].text.delete(",").to_i
            stats.ftp = element.css("td")[12].text.to_f
            stats.offreb = element.css("td")[13].text.delete(",").to_i
            stats.defreb = element.css("td")[14].text.delete(",").to_i
            stats.reb = element.css("td")[15].text.delete(",").to_i
            stats.ast = element.css("td")[16].text.delete(",").to_i
            stats.to = element.css("td")[17].text.delete(",").to_i
            stats.stl = element.css("td")[18].text.delete(",").to_i
            stats.blk = element.css("td")[19].text.delete(",").to_i
            stats.pf = element.css("td")[20].text.delete(",").to_i
            stats.pts = element.css("td")[-1].text.delete(",").to_i
            self.all << stats
        end
        doc.css("tfoot").each do |element|
            total = Combine::CareerStats.new(doc)
            total.season = element.css("td")[0].text
            total.team = element.css("td")[1].text
            total.games = element.css("td")[2].text.to_i
            total.min = element.css("td")[3].text.delete(",").to_i
            total.fgm = element.css("td")[4].text.delete(",").to_i
            total.fga = element.css("td")[5].text.delete(",").to_i
            total.fgp = element.css("td")[6].text.to_f
            total.tpm = element.css("td")[7].text.delete(",").to_i
            total.tpa = element.css("td")[8].text.delete(",").to_i
            total.tpp = element.css("td")[9].text.to_f
            total.ftm = element.css("td")[10].text.delete(",").to_i
            total.fta = element.css("td")[11].text.delete(",").to_i
            total.ftp = element.css("td")[12].text.to_f
            total.offreb = element.css("td")[13].text.delete(",").to_i
            total.defreb = element.css("td")[14].text.delete(",").to_i
            total.reb = element.css("td")[15].text.delete(",").to_i
            total.ast = element.css("td")[16].text.delete(",").to_i
            total.to = element.css("td")[17].text.delete(",").to_i
            total.stl = element.css("td")[18].text.delete(",").to_i
            total.blk = element.css("td")[19].text.delete(",").to_i
            total.pf = element.css("td")[20].text.delete(",").to_i
            total.pts = element.css("td")[-1].text.delete(",").to_i
            self.all << total
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