class Hand

	attr_reader :cards, :value, :blackjack, :busted

	def initialize(name, cards)
		@busted = false
		@name = name
		@cards = cards
		initial_deal
		if @value == 21
			@blackjack = true
		end
	end

	def initial_deal
		@value = 0
		@cards.each {|card| @value += card.value}
	end

	def hit(card)
		@value += card.value
		if @value < 21
			puts "#{@name} gets a #{card.value}.  #{@name} now has #{@value}"
			return
		elsif @value > 21
			puts "#{@name} gets a #{card.value}. #{@name} has busted with #{@value}"
			@busted = true
		else
			puts "#{@name} gets a #{card.value}. #{@name} now has has 21"
		end
	end
end

class DealerHand < Hand
	def play(remaining_cards)
		puts "Dealer flips over a #{@cards[1].rank}.  They have #{@value}"
		until @value > 16
			self.hit(remaining_cards.pop)
		end
		puts "Dealer has a #{@value}"
		
	end
end

class PlayerHand < Hand
end