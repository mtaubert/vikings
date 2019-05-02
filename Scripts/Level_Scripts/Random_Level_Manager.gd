extends "res://Scripts/Level_Scripts/Level_Manager.gd"

func _ready():
	randomize()
	var randomX = (randi()%10) + 5
	$World.set_cell(randomX,0,1)
	playerSpawn = Vector2(randomX,0)
	.print_level_details()

func print_level_details():
	print("test")
