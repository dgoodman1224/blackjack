require 'byebug'
require_relative 'hands'
require_relative 'decks'
require_relative 'players'

class Blackjack

	def initialize(shoe)
		@cards = shoe.cards
	end

	def start_game(player)
		@player = player
		system("clear")
		puts "Welcome to blackjack, type exit at any point to stop the game"
		until @player.bankroll == 0
			play
		end
	end

	def play
		@player.place_bet
		system("clear")
		deal
		check_for_double
		until @player_hand.active == false
			round
		end
		compare
	end

	def check_for_double
		puts 'Would you like to double?'
		response = gets.chomp
		if response == 'yes'
			@player.doubled = true
			@player_hand.double_down(@cards.pop)
		end
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
			puts @player_hand.hit(@cards.pop)
			round
		else
			@dealer_hand.play(@cards)
			@player_hand.active = false
			puts compare
		end
	end

	def deal
		dealer_cards = []
		player_cards = []
		2.times {player_cards.push(@cards.pop); dealer_cards.push(@cards.pop)}
		@dealer_hand = DealerHand.new('Dealer', dealer_cards)
		@player_hand = PlayerHand.new('Player', player_cards, @player.current_bet)
		if @dealer_hand.blackjack || @player_hand.blackjack
			return dealt_blackjack
		end
		show_status
	end

	def show_status
		@dealer_hand.initial_deal
		@player_hand.initial_deal
		puts "Dealer is showing a #{dealer_shows}."
		puts "Player has a #{player_string}"
	end

	def dealt_blackjack
		if @dealer_hand.blackjack
			@player.loses
			puts 'Player loses, dealer has blackjack'
		elsif @player_hand.blackjack
			@player.current_bet *= 1.5
			@player.wins
			puts "Player has blackjack!  They are paid #{@player.current_bet}"
		end
	end

	def dealer_shows
		@dealer_hand.cards.first.rank
	end


	def player_string
		"#{@player_hand.cards[0].rank} and #{@player_hand.cards[1].rank}.  Value: #{@player_hand.value}"
	end

	def compare
		@player_hand.active = false
		if @dealer_hand.busted || (@player_hand.value > @dealer_hand.value && !@player_hand.busted)
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
