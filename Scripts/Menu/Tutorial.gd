extends Control

onready var text: Label = get_node("paper/text")
onready var sprite: Sprite = get_node("paper/Sprite")

var current_page: int
var limit: int = 4

const list_tutorial: Dictionary = {
	'1': {
		text = "Colete os recursos necessários antes que o tempo acabe para vencer",
		image = "res://Textures/ui/Tutorial/resources.png"
	},
	'2': {
		text = 'Use sua arma para enfrentar os inimigos. Aperte a tecla (1) e (2) para mudar o modo de ataque',
		image = 'res://Textures/ui/Tutorial/weapom.png'
	},
	'3': {
		text = 'Ao pressionar a tecla (E) seu personagem vai se deslocar para a posição da última flecha, pressionando a (Z) a aumente o campo de visão. (A) e (D) para de movimentar e (SHIFT) para pular ',
		image = "res://Textures/ui/Tutorial/keys.png"
	},
	'4': {
		text = "Cuidado na água, certifique-se que tenha como sair caso entre",
		image = ''
	}
}

func _ready():
	current_page = 1
	change_page()

func change_page() -> void:
	if current_page > limit:
		current_page = 1
	elif current_page < 1:
		current_page = limit

	text.text = list_tutorial[str(current_page)].text
	sprite.texture = load(list_tutorial[str(current_page)].image)

func _on_next_page_pressed():
	current_page += 1
	change_page()
func _on_before_page_pressed():
	current_page -= 1
	change_page()


func _on_voltar_pressed():
	get_tree().change_scene('res://Scenes/game_interface/Menu.tscn')
