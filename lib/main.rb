require 'open-uri'
require 'nokogiri'
require 'pry'
require 'colorize'
require_relative "./stats-scraper"
require_relative "./player-card"
require_relative "./news"
require_relative "./gamelogs"
require_relative "./career-stats"

class Main
    attr_accessor :url_list, :rank_list

    def initialize
        @url_list = {}
        @rank_list = {}
    end

    def greeting
        puts "Fantasy Basketball Player Rater".bold
        doc = Nokogiri::HTML(open("https://www.fantasypros.com/nba/player-rater.php"))
        year = doc.css(".primary-heading-subheading.pull-left h4").text
        puts "#{year}".bold
    end
    
    def display(sort = "pr desc")
        puts "_____________________________________________________________________________________________________________________________"
        puts "| Rank |                  Player                  |  FG%  |  FT%  |  3PM  |  REB  |  AST  |  STL  |  BLK  |  PTS  | OVERALL |"
        puts "|------|------------------------------------------|-------|-------|-------|-------|-------|-------|-------|-------|---------|"
        stats = StatsScraper.scrape
        if sort == "name asc"
            stats = stats.sort_by {|cat| cat.name}
        elsif sort == "name desc"
            stats = stats.sort_by {|cat| cat.name}.reverse
        elsif sort == "fg desc"
            stats = stats.sort_by {|cat| cat.fg}.reverse
        elsif sort == "fg asc"
            stats = stats.sort_by {|cat| cat.fg}
        elsif sort == "ft desc"
            stats = stats.sort_by {|cat| cat.ft}.reverse
        elsif sort == "ft asc"
            stats = stats.sort_by {|cat| cat.ft}
        elsif sort == "tpm desc"
            stats = stats.sort_by {|cat| cat.tpm}.reverse
        elsif sort == "tpm asc"
            stats = stats.sort_by {|cat| cat.tpm}
        elsif sort == "reb desc"
            stats = stats.sort_by {|cat| cat.reb}.reverse
        elsif sort == "reb asc"
            stats = stats.sort_by {|cat| cat.reb}
        elsif sort == "ast desc"
            stats = stats.sort_by {|cat| cat.ast}.reverse
        elsif sort == "ast asc"
            stats = stats.sort_by {|cat| cat.ast}
        elsif sort == "stl desc"
            stats = stats.sort_by {|cat| cat.stl}.reverse
        elsif sort == "stl asc"
            stats = stats.sort_by {|cat| cat.stl}
        elsif sort == "blk desc"
            stats = stats.sort_by {|cat| cat.blk}.reverse
        elsif sort == "blk asc"
            stats = stats.sort_by {|cat| cat.blk}
        elsif sort == "pts desc"
            stats = stats.sort_by {|cat| cat.pts}.reverse
        elsif sort == "pts asc"
            stats = stats.sort_by {|cat| cat.pts}
        elsif sort == "pr desc"
            stats = stats.sort_by {|cat| cat.ovr}.reverse
        elsif sort == "pr asc"
            stats = stats.sort_by {|cat| cat.ovr}
        else
        end
        @url_list.clear if @url_list.size != 0
        @rank_list.clear if @rank_list.size != 0
        stats.each_with_index do |element, index|
            adding = "https://www.fantasypros.com" + element.card
            temp = element.name.split(" (")
            temp = temp[0]
            temp.downcase!
            @url_list[temp] = adding
            @rank_list[temp] = index + 1
            index_v2 = space_filler((index + 1).to_s, 5)
            name = space_filler(element.name, 41)
            fg = space_filler(element.fg.to_s, 6)
            ft = space_filler(element.ft.to_s, 6)
            tpm = space_filler(element.tpm.to_s, 6)
            reb = space_filler(element.reb.to_s, 6)
            ast = space_filler(element.ast.to_s, 6)
            stl = space_filler(element.stl.to_s, 6)
            blk = space_filler(element.blk.to_s, 6)
            pts = space_filler(element.pts.to_s, 6)
            ovr = space_filler(element.ovr.to_s, 8)
            puts "| #{index_v2} | #{name} | #{fg} | #{ft} | #{tpm} | #{reb} | #{ast} | #{stl} | #{blk} | #{pts} | #{ovr} |"
        end
        puts "|______|__________________________________________|_______|_______|_______|_______|_______|_______|_______|_______|_________|"
        StatsScraper.clear
    end

    def space_filler(string, max)
        space = max - string.length - 1
        space.times do
            string += " "
        end
        string
    end
    
    def menu
        puts "Abbreviations: Ascending = asc, Descending = desc, Field Goal = fg, Free Throw = ft, 3 Point Made = tpm, Rebound = reb, Assist = ast, Steal = stl, Block = blk, Points = pts, Player Rayer = pr."
        puts ""
        puts "Type any of the sorting options if desired: 'name asc' 'name desc', 'fg asc' 'fg desc', 'ft asc' 'ft desc', 'tpm asc' 'tpm desc', 'reb asc' 'reb desc', 'ast asc' 'ast desc', 'stl asc' 'stl desc', 'blk asc' 'blk desc', 'pts asc' 'pts desc', 'pr asc' 'pr desc'"
        puts "Or type any players name or rank according to the table above for more information about the player. Example: '1' or 'James Harden'."
        puts "Or type 'exit' to terminate."
        input = gets.chomp.downcase
        if @rank_list.has_value?(input.to_i)
            temp = @rank_list.key(input.to_i)
            url = @url_list[temp]
            system "clear"
            player = PlayerCard.new(url)
            player_display(player, url)
        elsif @rank_list.has_key?(input)
            url = @url_list[input]
            system "clear"
            player = PlayerCard.new(url)
            player_display(player, url)
        elsif input == "name asc" || input == "name desc" || input == "fg asc" || input == "fg desc" || input == "ft asc" || input == "ft desc" || input == "tpm asc" || input == "tpm desc" || input == "reb asc" || input == "reb desc" || input == "ast asc" || input == "ast desc" || input == "stl asc" || input == "stl desc" || input == "blk asc" || input == "blk desc" || input == "pts asc" || input == "pts desc" || input == "pr asc" || input == "pr desc"
            display(input)
        elsif input == "exit"
            system "clear"
            puts "Goodbye."
            exit
        else
            system "clear"
            puts "Error: Invalid input, try again..."
        end
        menu
    end

    def player_display(player, url)
        puts ""
        puts "#{player.name}"
        puts "#{player.pos}"
        puts ""
        puts "#{player.height} #{player.weight} #{player.age}"
        puts "#{player.college} #{player.drafted}"
        puts "==========================================================================================="
        puts "Overview".bold
        puts "==========================================================================================="
        puts "Player News"
        puts ""
        if player.news[0].include?("no news")
            puts "#{player.news[0]}"
        else
            puts "#{player.news[0][:p1_bold]}"
            puts ""
            puts "#{player.news[0][:p1]}"
            puts ""
            puts "#{player.news[0][:p2_bold]}"
            puts ""
            puts "#{player.news[0][:p2]}"
            puts ""
            puts "#{player.news[0][:author]} #{player.news[0][:timestamp]}"
        end
        puts "==========================================================================================="
        puts "Stats".bold
        puts ""
        puts "                                       Player Stats                                        ".bold
        puts "___________________________________________________________________________________________"
        puts "| SEASON | TEAM | GAMES |  MIN  |  REB  |  AST  |   TO   |  STL  |  BLK  |   PF   |  PTS  |"
        puts "|--------|------|-------|-------|-------|-------|--------|-------|-------|--------|-------|"
        player.stats.each do |element|
            season = space_filler(element[:season].to_s, 7)
            team = space_filler(element[:team], 5)
            games = space_filler(element[:games].to_s, 6)
            min = space_filler(element[:minutes].to_s, 6)
            reb = space_filler(element[:rebounds].to_s, 6)
            ast = space_filler(element[:assists].to_s, 6)
            to = space_filler(element[:turnovers].to_s, 7)
            stl = space_filler(element[:steals].to_s, 6)
            blk = space_filler(element[:blocks].to_s, 6)
            pf = space_filler(element[:personal_fouls].to_s, 7)
            pts = space_filler(element[:points].to_s, 6)
            puts "| #{season} | #{team} | #{games} | #{min} | #{reb} | #{ast} | #{to} | #{stl} | #{blk} | #{pf} | #{pts} |"
        end
        puts "|________|______|_______|_______|_______|_______|________|_______|_______|________|_______|"
        puts "==========================================================================================="
        puts "Game Log".bold
        puts "______________________________________________________________________________________"
        puts "|     GAME     |   OPP   |    SCORE    | MIN | REB | AST | TO | STL | BLK | PF | PTS |"
        puts "|--------------|---------|-------------|-----|-----|-----|----|-----|-----|----|-----|"
        player.gamelog.each do |element2|
            game = space_filler(element2[:game], 13)
            opp = space_filler(element2[:opponent], 8)
            score = space_filler(element2[:score], 12)
            min = space_filler(element2[:minutes].to_s, 4)
            reb = space_filler(element2[:rebounds].to_s, 4)
            ast = space_filler(element2[:assists].to_s, 4)
            to = space_filler(element2[:turnovers].to_s, 3)
            stl = space_filler(element2[:steals].to_s, 4)
            blk = space_filler(element2[:blocks].to_s, 4)
            pf = space_filler(element2[:personal_fouls].to_s, 3)
            pts = space_filler(element2[:points].to_s, 4)
            puts "| #{game} | #{opp} | #{score} | #{min} | #{reb} | #{ast} | #{to} | #{stl} | #{blk} | #{pf} | #{pts} |"
        end
        puts "|______________|_________|_____________|_____|_____|_____|____|_____|_____|____|_____|"
        puts ""
        puts "Type 'news' for more news. Type 'stats' for more stats. Type 'games' for more game logs."
        puts "Or type 'back' to go back to the main page."
        puts "Or type 'exit' to terminate."
        input = gets.chomp.downcase

        if input == "news"
            temp = url.split("/players/")
            temp2 = "#{temp[0]}/#{input}/#{temp[1]}"
            player_news = News.news(player, temp2)
            display_news(player_news, url)
        elsif input == "stats"
            temp = url.split("/players/")
            temp2 = "#{temp[0]}/#{input}/#{temp[1]}"
            player_stats = CareerStats.stats(player, temp2)
            display_stats(player_stats, url)
        elsif input == "games"
            temp = url.split("/players/")
            temp2 = "#{temp[0]}/#{input}/#{temp[1]}"
            player_gamelog = Gamelogs.games(player, temp2)
            display_gamelog(player_gamelog, url)
        elsif input == "back"
            display
            menu
        elsif input == "exit"
            system "clear"
            puts "Goodbye."
            exit
        else
            system "clear"
            puts "Error: Invalid input, try again..."
            display player_display(player, url)
        end
    end
    
    def display_news(player, url)
        system "clear"
        puts "#{player[0].name}"
        puts "#{player[0].pos}"
        puts ""
        puts "#{player[0].height} #{player[0].weight} #{player[0].age}"
        puts "#{player[0].college} #{player[0].drafted}"
        puts "================================================================================"
        puts "News".bold
        puts "================================================================================"
        player.each do |element|
            puts "#{element.p1}"
            puts ""
            puts "#{element.p2}"
            puts ""
            puts "#{element.p3}"
            puts ""
            puts "#{element.p4}"
            puts ""
            puts "#{element.author} #{element.timestamp}"
            puts "--------------------------------------------------------------------------"
        end
        puts ""
        puts "Type 'back' to go back to the overview page"
        puts "Or type 'exit' to terminate."
        News.clear
        input = gets.chomp.downcase

        if input == "back"
            system "clear"
            player = PlayerCard.new(url)
            player_display(player, url)
        elsif input == "exit"
            system "clear"
            puts "Goodbye."
            exit
        else
            system "clear"
            puts "Error: Invalid input, try again..."
            display_news(player, url)
        end
    end

    def display_stats(player, url)
        system "clear"
        puts "#{player[0].name}"
        puts "#{player[0].pos}"
        puts ""
        puts "#{player[0].height} #{player[0].weight} #{player[0].age}"
        puts "#{player[0].college} #{player[0].drafted}"
        puts "========================================================================================================================================================================================="
        puts "Stats".bold
        puts "========================================================================================================================================================================================="
        puts ""
        puts "_________________________________________________________________________________________________________________________________________________________________________________________"
        puts "| SEASON | TEAM | GAMES |  MIN  |  FGM  |  FGA  |   FG%   |  3PM  |  3PA  |   3P%   |  FTM  |  FTA  |   FT%   |  OFF  |  DEF  |  REB  |  AST  |   TO   |  STL  |  BLK  |   PF   |  PTS  |"
        puts "|--------|------|-------|-------|-------|-------|---------|-------|-------|---------|-------|-------|---------|-------|-------|-------|-------|--------|-------|-------|--------|-------|"
        player.each do |element|
            season = space_filler(element.season.to_s, 7)
            team = space_filler(element.team, 5)
            games = space_filler(element.games.to_s, 6)
            min = space_filler(element.min.to_s, 6)
            fgm = space_filler(element.fgm.to_s, 6)
            fga = space_filler(element.fga.to_s, 6)
            fgp = space_filler(element.fgp.to_s, 8)
            tpm = space_filler(element.tpm.to_s, 6)
            tpa = space_filler(element.tpa.to_s, 6)
            tpp = space_filler(element.tpp.to_s, 8)
            ftm = space_filler(element.ftm.to_s, 6)
            fta = space_filler(element.fta.to_s, 6)
            ftp = space_filler(element.ftp.to_s, 8)
            offreb = space_filler(element.offreb.to_s, 6)
            defreb = space_filler(element.defreb.to_s, 6)
            reb = space_filler(element.reb.to_s, 6)
            ast = space_filler(element.ast.to_s, 6)
            to = space_filler(element.to.to_s, 7)
            stl = space_filler(element.stl.to_s, 6)
            blk = space_filler(element.blk.to_s, 6)
            pf = space_filler(element.pf.to_s, 7)
            pts = space_filler(element.pts.to_s, 6)
            puts "| #{season} | #{team} | #{games} | #{min} | #{fgm} | #{fga} | #{fgp} | #{tpm} | #{tpa} | #{tpp} | #{ftm} | #{fta} | #{ftp} | #{offreb} | #{defreb} | #{reb} | #{ast} | #{to} | #{stl} | #{blk} | #{pf} | #{pts} |"
        end
        puts "|________|______|_______|_______|_______|_______|_________|_______|_______|_________|_______|_______|_________|_______|_______|_______|_______|________|_______|_______|________|_______|"
        puts ""
        puts "Type 'back' to go back to the overview page"
        puts "Or type 'exit' to terminate."
        CareerStats.clear
        input = gets.chomp.downcase

        if input == "back"
            system "clear"
            player = PlayerCard.new(url)
            player_display(player, url)
        elsif input == "exit"
            system "clear"
            puts "Goodbye."
            exit
        else
            system "clear"
            puts "Error: Invalid input, try again..."
            display_stats(player, url)
        end
    end

    def display_gamelog(player, url)
        system "clear"
        puts "#{player[0].name}"
        puts "#{player[0].pos}"
        puts ""
        puts "#{player[0].height} #{player[0].weight} #{player[0].age}"
        puts "#{player[0].college} #{player[0].drafted}"
        puts "=============================================================================================================================================================="
        puts "Game Logs".bold
        puts "=============================================================================================================================================================="
        puts ""
        puts "______________________________________________________________________________________________________________________________________________________________"
        puts "|     Date     |   OPP   |    SCORE    | MIN | FGM | FGA |  FG%  | 3PM | 3PA |  3P%  | FTM | FTA |  FT%  | OFF | DEF | REB | AST | TO | STL | BLK | PF | PTS |"
        puts "|--------------|---------|-------------|-----|-----|-----|-------|-----|-----|-------|-----|-----|-------|-----|-----|-----|-----|----|-----|-----|----|-----|"
        player.each do |element|
            date = space_filler(element.date, 13)
            opp = space_filler(element.opp, 8)
            score = space_filler(element.score, 12)
            min = space_filler(element.min.to_s, 4)
            fgm = space_filler(element.fgm.to_s, 4)
            fga = space_filler(element.fga.to_s, 4)
            fgp = space_filler(element.fgp.to_s, 6)
            tpm = space_filler(element.tpm.to_s, 4)
            tpa = space_filler(element.tpa.to_s, 4)
            tpp = space_filler(element.tpp.to_s, 6)
            ftm = space_filler(element.ftm.to_s, 4)
            fta = space_filler(element.fta.to_s, 4)
            ftp = space_filler(element.ftp.to_s, 6)
            offreb = space_filler(element.offreb.to_s, 4)
            defreb = space_filler(element.defreb.to_s, 4)
            reb = space_filler(element.reb.to_s, 4)
            ast = space_filler(element.ast.to_s, 4)
            to = space_filler(element.to.to_s, 3)
            stl = space_filler(element.stl.to_s, 4)
            blk = space_filler(element.blk.to_s, 4)
            pf = space_filler(element.pf.to_s, 3)
            pts = space_filler(element.pts.to_s, 4)
            puts "| #{date} | #{opp} | #{score} | #{min} | #{fgm} | #{fga} | #{fgp} | #{tpm} | #{tpa} | #{tpp} | #{ftm} | #{fta} | #{ftp} | #{offreb} | #{defreb} | #{reb} | #{ast} | #{to} | #{stl} | #{blk} | #{pf} | #{pts} |"
        end
        puts "|______________|_________|_____________|_____|_____|_____|_______|_____|_____|_______|_____|_____|_______|_____|_____|_____|_____|____|_____|_____|____|_____|"
        puts ""
        puts "Type 'back' to go back to the overview page"
        puts "Or type 'exit' to terminate."
        Gamelogs.clear
        input = gets.chomp.downcase

        if input == "back"
            system "clear"
            player = PlayerCard.new(url)
            player_display(player, url)
        elsif input == "exit"
            system "clear"
            puts "Goodbye."
            exit
        else
            system "clear"
            puts "Error: Invalid input, try again..."
            display_gamelog(player, url)
        end
    end
    
    def main
        greeting
        display
        menu
    end
end

test = Main.new
test.main