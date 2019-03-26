extends Node2D

var names = [
"Sighadd", 
"Balli", 
"Hallfred", 
"Thorlak", 
"Tore", 
"Bothvar", 
"Kabbi", 
"Mursi", 
"Sigestæl", 
"Bui",
"Sighadd",
"Ragnar" 
]

var type
var controller
var vikingName

onready var defaultSprite = preload("res://Assets/player.png")
onready var crouchSprite = preload("res://Assets/player_crouch.png")

var playerColor = Color("00ff00")
var opponentColor = Color("ff0000")

func cartesian_to_isometric(vector):
	return Vector2(vector.x - vector.y, (vector.x + vector.y) / 2)

func setup():
	type = get_parent().get_parent().ENTITIES.VIKING
	$Debug_Sprite.modulate = playerColor
	randomize()
	vikingName = names[randi()%names.size()] + " " + names[randi()%names.size()] + "sson"

func get_customisations():
	return $Viking_Sprites.colors

func _input(event):
	#Player_Inputs
	if Input.is_action_pressed("ui_page_down"):
		$Debug_Sprite.texture = crouchSprite
	elif Input.is_action_pressed("ui_page_up"):
		$Debug_Sprite.texture = defaultSprite