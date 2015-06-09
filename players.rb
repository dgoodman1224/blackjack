class Player

	attr_accessor :bankroll, :current_bet, :name


	def initialize(name, bankroll=1000)
		@name = name
		@bankroll = bankroll
		@current_bet = 50
	end

	def update_bet(new_bet)
		int_bet = new_bet.to_i
		if int_bet <= 0
			puts 'Please enter a valid number'
			new_bet = gets.chomp
			return update_bet(new_bet)
		end
		@current_bet = int_bet
	end

	def wins
		@bankroll += @current_bet
	end

	def loses
		@bankroll -= @current_bet
	end

end