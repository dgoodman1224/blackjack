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
		@player = player
		system("clear")
		puts "Welcome to blackjack, type exit at any point to stop the game"
		until @player.bankroll == 0
			play(@player)
		end
	end

	def play(player)
		puts "Welcome #{player.name}, you have a bankroll of #{player.bankroll}"
		puts "Current bet is #{player.current_bet} enter a number"
		new_bet = gets.chomp.to_i
		player.update_bet(new_bet) 
		puts "The new bet is now #{player.current_bet}"
		system("clear")
		deal
		if @dealer_hand.blackjack
			@player.loses
			puts 'Player loses, dealer has blackjack'
			return
		elsif @player_hand.blackjack
			@player.current_bet *= 1.5
			@player.wins
			puts "Player has blackjack!  They are paid #{@player.current_bet}"
			return
		end
		round
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
		@player_hand = PlayerHand.new('Player', player_cards, @player.current_bet)
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
		if @dealer_hand.busted || @player_hand.value > @dealer_hand.value
			@player.wins
			return 'Player Wins'
		elsif @player_hand.busted || @dealer_hand.value > @player_hand.value
			@player.loses
			return 'Player loses'
		else @dealer_hand.value == @player_hand.value
			return 'It is a push bitch'
		end
			
	end

	def end_game
		puts "That was fun please come back soon!"
		sleep(2)
		exit
	end

end

start_game
