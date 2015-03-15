require 'byebug'
require_relative 'hands'

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
		card_values = {'Two' => 2,'Three' => 3,'Four' => 4,'Five' => 5,'Six' => 6,'Seven' => 7,'Eight' => 8,
						'Nine' => 9,'Ten' => 10,'Jack' => 10,'Queen' => 10,'King' => 10,'Ace' => 11}
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
		deal
		if @dealer_hand.blackjack
			return 'Player loses, dealer has blackjack'
		elsif @player_hand.blackjack
			return 'Player wins, they have blackjack'
		end
		round
	end

	def round
		if @dealer_hand.busted || @player_hand.busted
			return compare
		end
		puts 'What would you like to do?'
		move = gets.chomp
		if ['hit', 'Hit', 'h'].include?(move)
			@player_hand.hit(@cards.pop)
			round
		else
			@dealer_hand.play(@cards)
			compare
		end
	end

	def deal
		dealer_cards = []
		player_cards = []
		2.times {dealer_cards.push(@cards.pop); player_cards.push(@cards.pop)}
		@dealer_hand = DealerHand.new('Dealer', dealer_cards)
		@player_hand = PlayerHand.new('Player', player_cards)
		show_status
	end

	def show_status
		@dealer_hand.initial_deal
		@player_hand.initial_deal
		puts "Dealer is showing a #{dealer_shows}."
		puts "Player has a #{player_string}"
	end

	def dealer_shows
		@dealer_hand.cards.first.rank
	end


	def player_string
		"#{@player_hand.cards[0].rank} and #{@player_hand.cards[1].rank}.  Value: #{@player_hand.value}"
	end

	def compare
		if @dealer_hand.busted
			'Player Wins'
		elsif @player_hand.busted
			'Player loses'
		elsif @player_hand.value > @dealer_hand.value
			return 'Player wins'
		elsif @dealer_hand.value > @player_hand.value
			return 'Player loses'
		end
			
	end

end

shoe = Shoe.new
shoe.add_decks(6)
shoe.shuffle_shoe
blackjack = Blackjack.new(shoe)
system("clear")
puts blackjack.play
