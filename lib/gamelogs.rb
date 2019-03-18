class Combine::Gamelogs
    attr_accessor :date, :opp, :score, :min, :fgm, :fga, :fgp, :tpm, :tpa, :tpp, :ftm, :fta, :ftp, :offreb, :defreb, :reb, :ast, :to, :stl, :blk, :pf, :pts, :name, :pos, :height, :weight, :age, :college, :drafted
    
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
    
    def self.games(player, url)
        doc = Nokogiri::HTML(open(url))
        @name = doc.css(".pull-left h1").text
        @pos = doc.css(".pull-left h5").text.strip
        doc.css(".bio-detail").each do |element|
            @height = element.text if element.text.include?("Height")
            @weight = element.text if element.text.include?("Weight")
            @age = element.text if element.text.include?("Age")
            @college = element.text if element.text.include?("College")
            @drafted = element.text if element.text.include?("Drafted")
        end
        doc.css("tbody tr").each do |element|
            gamelog = Combine::Gamelogs.new(doc)
            gamelog.date = element.css("td")[0].text
            gamelog.opp = element.css("td")[1].text
            gamelog.score = element.css("td")[2].text
            gamelog.min = element.css("td")[3].text.to_i
            gamelog.fgm = element.css("td")[4].text.to_i
            gamelog.fga = element.css("td")[5].text.to_i
            gamelog.fgp = element.css("td")[6].text.to_f
            gamelog.tpm = element.css("td")[7].text.to_i
            gamelog.tpa = element.css("td")[8].text.to_i
            gamelog.tpp = element.css("td")[9].text.to_f
            gamelog.ftm = element.css("td")[10].text.to_i
            gamelog.fta = element.css("td")[11].text.to_i
            gamelog.ftp = element.css("td")[12].text.to_f
            gamelog.offreb = element.css("td")[13].text.to_i
            gamelog.defreb = element.css("td")[14].text.to_i
            gamelog.reb = element.css("td")[15].text.to_i
            gamelog.ast = element.css("td")[16].text.to_i
            gamelog.to = element.css("td")[17].text.to_i
            gamelog.stl = element.css("td")[18].text.to_i
            gamelog.blk = element.css("td")[19].text.to_i
            gamelog.pf = element.css("td")[20].text.to_i
            gamelog.pts = element.css("td")[-1].text.to_i
            self.all << gamelog
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