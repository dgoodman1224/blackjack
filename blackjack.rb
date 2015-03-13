class Shoe
	attr_reader :cards

	def initialize
		@cards = []
		@decks = []
		@deck_number = 0
		@discard_pile = []
	end

	def add_decks(decks=1)
		decks.times do
			deck = Deck.new
			@decks.push(deck)
			@cards += deck.cards
			@deck_number += 1
		end
	end

	def cut_deck
		#places an imaginary stopper, like when you put the yellow thing in
		length_of_deck = @cards.length
		ending_point = (length_of_deck/2..length_of_deck*(3/4)).to_a.sample()
		@cards[ending_point] = 'break'
	end

	def shuffle_shoe
		@cards.shuffle!
	end

end

class Deck
	attr_reader :cards

	def initialize
		@cards = []
		create_standard_deck
	end

	def create_standard_deck
		card_values = {'Two' => 2,'Three' => 3,'Four' => 4,'Five' => 5,'Six' => 6,'Seven' => 7,'Eight' => 8,
						'Nine' => 9,'Ten' => 10,'Jack' => 11,'Queen' => 12,'King' => 13,'Ace' => 11}
		suits = ['S', 'D', 'C', 'H']
		suits.each do |suit|
			card_values.each do |rank, value|
				card = Card.new(rank, value, suit)
				@cards.push(card)
			end
		end
	end

	def shuffle
		@cards.shuffle!
	end
end

class Card

	attr_reader  :value,  :rank,  :suit

	def initialize(rank, value, suit)
		@value = value
		@rank = rank
		@suit = suit
	end
end

class Blackjack

	def initialize(shoe)
		@cards = shoe.cards
	end

	def play
		@dealer_cards = []
		@player_cards = []
		@player_score = 0
		@dealer_score = 0
		deal
	end

	def deal
		2.times {@dealer_cards.push(@cards.pop); @player_cards.push(@cards.pop)}
		show_status
	end

	def show_status
		puts "Dealer is showing a #{dealer_shows}. Player has a #{player_string}"
	end

	def dealer_shows
		@dealer_score += @dealer_cards.first.value
		@dealer_cards.first.rank
	end

	def player_string
		@player_cards.each {|card| @player_score += card.value }
		"#{@player_cards[0].rank} and #{@player_cards[1].rank}.  Value: #{@player_score}"
	end

end

shoe = Shoe.new
puts shoe.cards.length == 0
shoe.add_decks(3)
puts shoe.cards.length == 156
game = Blackjack.new(shoe)
shoe.shuffle_shoe
game.play



