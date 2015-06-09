require_relative 'blackjack'

def start_game
	shoe = Shoe.new
	shoe.add_decks(6)
	shoe.shuffle_shoe
	blackjack = Blackjack.new(shoe)
	player = Player.new('David')
	blackjack.start_game(player)
end

start_game