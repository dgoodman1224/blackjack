class Player

	attr_accessor :bankroll, :current_bet, :name


	def initialize(name, bankroll=1000)
		@name = name
		@bankroll = bankroll
		@current_bet = 50
		print 'We got a player'
	end

	def update_bet(new_bet)
		if new_bet.to_i.is_a? Integer
			@current_bet = new_bet
		end
	end

end


david = Player.new('DAvid')

print david.name