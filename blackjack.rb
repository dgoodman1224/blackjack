require 'byebug'
require_relative 'hands'
require_relative 'decks'
class Blackjack

	def initialize(shoe)
		@cards = shoe.cards
	end

	def play
		3.times {puts ''}
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
		elsif @dealer_hand.value == @player_hand.value
			return 'It is a push bitch'
		end
			
	end

end

shoe = Shoe.new
shoe.add_decks(6)
shoe.shuffle_shoe
blackjack = Blackjack.new(shoe)
system("clear")
puts blackjack.play
puts blackjack.play
puts blackjack.play
puts blackjack.play
puts blackjack.play
puts blackjack.play
puts blackjack.play
