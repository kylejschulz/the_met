class Museum
  attr_reader :name, :exhibits, :patrons
  def initialize(name)
    @name = name
    @exhibits = []
    @patrons = []
  end

  def add_exhibit(exhibit)
    @exhibits << exhibit
  end

  def recommend_exhibits(patron)
    #array of exhibit objects
    interested = []
    @exhibits.select do |exhibit|
       patron.interests.each do |interest|
         interested << exhibit if exhibit.name == interest
      end
    end
    interested
  end

  def admit(patron)
    @patrons << patron
  end

  def patrons_by_exhibit_interest
    hash = Hash.new { |h, k| h[k] = [] }
    @exhibits.each do |exhibit|
      @patrons.each do |patron|
        if hash[exhibit].nil?
          hash[exhibit] = []
        end
        hash[exhibit] << patron if patron.interests.include?(exhibit.name)
      end
    end
    hash
  end

  def ticket_lottery_contestants(exhibit)
    eligible = patrons_by_exhibit_interest[exhibit].select do |patron|
      patron.poor_AF?(exhibit.cost)
    end
    eligible
  end

  def draw_lottery_winner(exhibit)
    ticket_lottery_contestants(exhibit).sample
  end

  def announce_lottery_winner(exhibit)
    if draw_lottery_winner(exhibit).nil?
      puts "No winners for this lottery"
    else
      puts "#{draw_lottery_winner(exhibit)} has won the #{exhibit.name} lottery"
    end
  end 
end
