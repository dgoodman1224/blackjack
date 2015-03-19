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

	def pop
		@cards.pop
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
		card_values = {'Two' => 2,'Three' => 3,'Four' => 4,'Five' => 5,'Six' => 6,#'Seven' => 7,'Eight' => 8,
						'Nine' => 9,'Ten' => 10,'Jack' => 10,'Queen' => 10,'King' => 10,
						'Ace' => 11}
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

	attr_reader  :rank,  :suit
	attr_accessor :value

	def initialize(rank, value, suit)
		@value = value
		@rank = rank
		@suit = suit
	end
end