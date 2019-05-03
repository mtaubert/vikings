extends "res://Scripts/Level_Scripts/Level_Manager.gd"

export(Globals.WORLD_TYPE) var worldType

#Grabs the level details from the encounter manager and sets the player spawn
func setup_level():
	var worldSize = Vector2(randi()%10+5, randi()%10+5)
	for x in range(worldSize.x):
		for y in range(worldSize.y):
			$World.set_cell(x,y,worldType)
	
	var playerSpawn = $World.get_used_cells()[randi()%$World.get_used_cells().size()]