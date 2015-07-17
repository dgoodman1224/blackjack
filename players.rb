class Player

	attr_accessor :bankroll, :current_bet, :name, :doubled


	def initialize(name, bankroll=1000)
		@name = name
		@bankroll = bankroll
		@current_bet = 50
		@doubled = false
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

	def place_bet
		puts "Welcome #{@name}, you have a bankroll of #{@bankroll}"
		puts "Current bet is #{@current_bet} enter a number"
		new_bet = gets.chomp.to_i
		update_bet(new_bet)
		puts "The new bet is now #{current_bet}"
	end

	def wins
		if @doubled = true
			@bankroll += 2 * @current_bet
		else
			@bankroll += @current_bet
		end
	end

	def loses
		if @doubled = true
			@bankroll -= 2 * @current_bet
		else
			@bankroll -= @current_bet
		end
	end

end