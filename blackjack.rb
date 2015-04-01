require 'byebug'
require_relative 'hands'
require_relative 'decks'
require_relative 'players'

def start_game
	shoe = Shoe.new
	shoe.add_decks(6)
	shoe.shuffle_shoe
	blackjack = Blackjack.new(shoe)
	player = Player.new('David')
	blackjack.start_game(player)
end

class Blackjack

	def initialize(shoe)
		@cards = shoe.cards
	end

	def start_game(player)
		system("clear")
		puts "Welcome to blackjack, type exit at any point to stop the game"
		sleep(1.25)
		100.times { play(player) }
	end

	def play(player)
		puts "Welcome #{player.name}, you have a bankroll of #{player.bankroll}"
		puts "Current bet is #{player.current_bet} enter a number"
		new_bet = gets.chomp
		player.update_bet(new_bet) 
		puts "The new bet is now #{player.current_bet}"
		deal
		if @dealer_hand.blackjack
			return 'Player loses, dealer has blackjack'
		elsif @player_hand.blackjack
			return 'Player wins, they have blackjack'
		end
		round
		compare
	end

	def round
		if @dealer_hand.busted || @player_hand.busted
			return compare
		end
		puts 'What would you like to do?'
		move = gets.chomp
		if move.downcase == 'exit'
			end_game
		end
		if ['hit', 'Hit', 'h'].include?(move)
			@player_hand.hit(@cards.pop)
			round
		else
			@dealer_hand.play(@cards)
			puts compare
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
		#debugger
		if @dealer_hand.busted
			return 'Player Wins'
		elsif @player_hand.busted
			return 'Player loses'
		elsif @player_hand.value > @dealer_hand.value
			return 'Player wins'
		elsif @dealer_hand.value > @player_hand.value
			return 'Player loses'
		elsif @dealer_hand.value == @player_hand.value
			return 'It is a push bitch'
		end
			
	end

	def end_game
		puts "That was fun please come back soon"
		exit
	end

end

start_game
