extends Node

var resources_amount: Dictionary = {
	"blue": {
		amount = 0,
		objective = 9
	},
	"green": {
		amount = 0,
		objective = 10
	},
	"orange": {
		amount = 0,
		objective = 11
	}
}

var amount_arrows: int
var position_player: Vector2
var is_on_water: bool
