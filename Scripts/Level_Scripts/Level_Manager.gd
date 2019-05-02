extends Node2D

export(String) var levelName
export(Vector2) var playerSpawn = Vector2(0,0)
var tileOffset:Vector2 #Offset from the center of the tile to the tile origin

#Player
onready var character = load("res://Scenes/Characters/Character.tscn")

var levelEntities = {}
var selectedEntity = null


#Setup ===============================================================================================
func _ready():
	randomize()
	tileOffset = Vector2(0,$World.cell_size.y/2)
	spawn_walls()
	get_level_entities()
	spawn_players()
	update_game_manager_with_level_data()

onready var wall = load("res://Scenes/Prefabs/Wall.tscn")
func spawn_walls():
	for pos in $World.get_used_cells_by_id(0):
		var newWall = wall.instance()
		$World/Sorter.add_child(newWall)
		newWall.position = $World.map_to_world(pos) + tileOffset

#Loads all entities and locks them to the world grid if they aren't already
func get_level_entities():
	for child in $World/Sorter.get_children():
		var childLoc = $World.world_to_map(child.position)
		match child.type:
			Globals.ENTITY_TYPE.CHARACTER:
				child.connect("selected", self, "select_entity")
				levelEntities[childLoc] = child
				child.position = $World.map_to_world(childLoc) + tileOffset
			Globals.ENTITY_TYPE.WALL:
				levelEntities[childLoc] = child

#Player is spawned and set to the player spawnpoint
func spawn_players():
	var validSpawns = $World.get_used_cells_by_id(1)
	
	for key in levelEntities.keys(): #Removes the already placed entities from the list of valid spawns
		validSpawns.erase(key)
	
	for i in range(Player_Manager.characters.size()): #Gets all saved characters from the player's party
		var newCharacter:Character = character.instance()
		var newCharacterSpawn = validSpawns[randi()%validSpawns.size()]
		
		$World/Sorter.add_child(newCharacter) #Adds the character to the sorter
		newCharacter.position = $World.map_to_world(newCharacterSpawn) + tileOffset #Snaps the character to the grid
		newCharacter.setup(Player_Manager.characters[i])
		
		levelEntities[playerSpawn] = newCharacter #Adds the character to the level entries dictionary
		newCharacter.connect("selected", self, "select_entity") #Connects the signal for selecting the player
		validSpawns.erase(newCharacterSpawn) #Removes the spawn location from the list of valid spawns

#Sends the level data to the game manager
func update_game_manager_with_level_data():
	var cellData = {}
	for cell in $World.get_used_cells():
		cellData[cell] = $World.get_cellv(cell)
	Game_Manager.astar_setup(cellData)

#Debug use
func print_level_details():
	print(levelName)
	print($World.get_used_rect())

func set_camera_limits():
	var usedRect:Rect2 = $World.get_used_rect()
	$Camera.set_limits($World.map_to_world(usedRect.position - Vector2(2,2)), $World.map_to_world(usedRect.end + Vector2(2,2)))
#Setup ===============================================================================================

#User input
func _input(event):
	if event.is_action_pressed("game_move"): #Right click
		if selectedEntity != null:
			move_character_to($World.world_to_map(get_global_mouse_position()))

#Entity selection and movement =======================================================================

#update selected entity
func select_entity(entity):
	print(entity)
	selectedEntity = entity

#Moves the selected entity to the selected location
func move_character_to(location:Vector2):
	if $World.get_used_cells().has(location) and $World.get_cellv(location) != 0:
		var path:PoolVector2Array = Game_Manager.astar_get_path($World.world_to_map(selectedEntity.position), location)
		path.remove(0)
		var worldPosPath:PoolVector2Array = []
		for point in path:
			worldPosPath.append($World.map_to_world(point) + tileOffset)
		print(path)
		selectedEntity.move_character(worldPosPath)
#Entity selection and movement =======================================================================

func quit():
	get_tree().quit()