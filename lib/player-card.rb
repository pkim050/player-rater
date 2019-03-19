class Combine::PlayerCard
    attr_accessor :name, :pos, :height, :weight, :age, :college, :drafted, :news, :stats, :gamelog

    @@all = [] #Collects are links

    def initialize(url)
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

        @news = []
        @stats = []
        @gamelog = []
        counter = 0 #For news purpose
        doc.css(".subsection.feature-stretch").each do |element|
            if element.text.include?("News")
                counter += 1
                news_p1 = element.css("p")[0].text.strip
                news_p2 = element.css("p")[1].text.strip
                news_p3 = element.css("p")[2].text
                news_p4 = element.css("p")[3].text
                author = element.css("a.pull-left").text
                timestamp = element.css(".pull-right.timestamp").text
                @news << {
                    p1_bold: news_p1,
                    p1: news_p2,
                    p2_bold: news_p3,
                    p2: news_p4,
                    author: author,
                    timestamp: timestamp
                
                }
                @@all << element.css(".view-more.pull-right")[0]['href']

            elsif element.text.include?("Stats")
                @@all << element.css(".view-more.pull-right")[0]['href']
                season = element.css("td")[0].text.to_i
                team = element.css("td")[1].text
                games = element.css("td")[2].text.to_i
                min = element.css("td")[3].text.delete(",").to_i
                reb = element.css("td")[4].text.delete(",").to_i
                ast = element.css("td")[5].text.delete(",").to_i
                to = element.css("td")[6].text.delete(",").to_i
                stl = element.css("td")[7].text.delete(",").to_i
                blk = element.css("td")[8].text.delete(",").to_i
                pf = element.css("td")[9].text.delete(",").to_i
                pts = element.css("td")[-1].text.delete(",").to_i
                @stats << {
                    season: season,
                    team: team,
                    games: games,
                    minutes: min,
                    rebounds: reb,
                    assists: ast,
                    turnovers: to,
                    steals: stl,
                    blocks: blk,
                    personal_fouls: pf,
                    points: pts
                }

            elsif element.text.include?("Game Log")
                @@all << element.css(".view-more.pull-right")[0]['href']
                if element.css("td").text.include?("Player does not")
                    @gamelog = element.css("td").text
                else
                    element.css("tbody tr").each do |element2|
                        if element2.css("td")[0].text.include?("Player")
                            game = element2.css("td")[0].text
                            @gamelog << {
                                game: game
                            }
                        else
                            game = element2.css("td")[0].text
                            opp = element2.css("td")[1].text
                            score = element2.css("td")[2].text
                            min = element2.css("td")[3].text.to_i
                            reb = element2.css("td")[4].text.to_i
                            ast = element2.css("td")[5].text.to_i
                            to = element2.css("td")[6].text.to_i
                            stl = element2.css("td")[7].text.to_i
                            blk = element2.css("td")[8].text.to_i
                            pf = element2.css("td")[9].text.to_i
                            pts = element2.css("td")[-1].text.to_i
                            @gamelog << {
                                game: game,
                                opponent: opp,
                                score: score,
                                minutes: min,
                                rebounds: reb,
                                assists: ast,
                                turnovers: to,
                                steals: stl,
                                blocks: blk,
                                personal_fouls: pf,
                                points: pts
                            }
                        end
                    end
                end

            else
                
            end
            @news << "There are currently no news items for this player." if counter == 0
        end
    end

    def self.all
        @@all
    end

    def self.clear
        self.all.clear
    end
end