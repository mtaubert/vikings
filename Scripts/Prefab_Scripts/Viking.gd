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

var grid
var type
var controller
var vikingName

onready var defaultSprite = preload("res://Assets/player.png")
onready var crouchSprite = preload("res://Assets/player_crouch.png")

var playerColor = Color("00ff00")
var opponentColor = Color("ff0000")

#Customisation---------------------------------------------------------------------------------
func setup():
	grid = get_parent().get_parent()
	type = grid.ENTITIES.VIKING
	$Debug_Sprite.modulate = playerColor
	randomize()
	vikingName = names[randi()%names.size()] + " " + names[randi()%names.size()] + "sson"

func get_customisations():
	return $Viking_Sprites.customisationValues
#Customisation---------------------------------------------------------------------------------

#Movement---------------------------------------------------------------------------------
var path
var vikingMoving = false
var speed = 100

func move(newPath):
	path = newPath
	print(path)
	vikingMoving = true

func _process(delta):
	if !path:
		vikingMoving = false
		return

	if path.size() > 0:
		var distance: float = self.position.distance_to(path[0])
		if distance > 10:
			self.position = self.position.linear_interpolate(path[0], (speed * delta)/distance)
		else:
			if path.size() == 1:
				grid.update_cell(path[0], self)
			path.remove(0)
#Movement---------------------------------------------------------------------------------