class Hand

	attr_reader :cards, :value, :blackjack, :busted

	def initialize(name, cards)
		@busted = false
		@has_ace = false
		@name = name
		@cards = cards
		initial_deal
		if @value == 21
			@blackjack = true
		end
	end

	def initial_deal
		@value = 0
		@cards.each do |card|
			@value += card.value
			if card.rank == 'Ace'
				@has_ace = true
			end
		end
	end

	def hit(card)
		@value += card.value
		if card.rank == 'Ace'
			@has_ace = true
		end
		if @value <= 21
			return "#{@name} gets a #{card.rank}.  #{@name} now has #{@value}"
		elsif @value > 21 && @has_ace
			puts "#{@name} gets a #{card.rank}. #{@name} would have #{@value}"
			puts "Ace will be treated as a 1"
			@has_ace = false
			@value -= 10
			return "#{@name} now has #{@value}"
		elsif @value > 21
			bust_hand
			return "#{@name} gets a #{card.value}. #{@name} has busted with #{@value}"
		end
	end

	def bust_hand
		@busted = true
		@active = false
	end

end

class DealerHand < Hand
	def play(remaining_cards)
		puts "Dealer flips over a #{@cards[1].rank}.  They have #{@value}"
		until @value > 16
			sleep(1)
			self.hit(remaining_cards.pop)
		end
		if @value > 21
			@busted = true
			puts "Dealer has busted with a #{@value}"
		else
			puts "Dealer stays with a #{@value}"
		end

	end

end

class PlayerHand < Hand

	attr_accessor :active
	attr_reader :doubled

	def initialize(name, cards, bet)
		@busted = false
		@has_ace = false
		@name = name
		@cards = cards
		@active = true
		initial_deal
		if @value == 21
			@blackjack = true
		end
		@bet = bet
	end

	def double_down(card)
		@value += card.value
		@active = false
	end

	def bust
		@active = false
	end

end