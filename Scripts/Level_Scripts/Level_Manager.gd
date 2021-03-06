extends Node2D

export(String) var levelName
export(Vector2) var playerSpawn = Vector2(0,0)
var tileOffset:Vector2 #Offset from the center of the tile to the tile origin

#Player
onready var character = load("res://Scenes/Characters/Character.tscn")

#Setup ===============================================================================================
func _ready():
	randomize()
	tileOffset = Vector2(0,$World.cell_size.y/2)
	AI_Manager.connect("ai_character_move", self, "move_character_to")
	$Camera/CanvasLayer/UI.connect("action_pressed", self, "get_valid_targets_for_action")
	
	setup_level() #Adds some smaller entities to the grid
	$World/Selector.set_valid_cells(get_valid_cells()) #Sets up the selector to know which cells are valid
	
	#spawn_walls()
	update_managers_with_level_data() #Locks any existing entities to the grid and sets up currentLevelEntities in the manager
	spawn_players() #Spawn the player's crew
	
	start_game()
	
	print_level_details()

#Spawns a couple little entities to litter the scene to add some flair
func setup_level():
	pass

#Spawns wall prefabs on every blocked tile
onready var wall = load("res://Scenes/Prefabs/Wall.tscn")
func spawn_walls():
	for pos in $World.get_used_cells_by_id(0):
		var newWall = wall.instance()
		$World/Sorter.add_child(newWall)
		newWall.position = $World.map_to_world(pos) + tileOffset

#Sends the level data to the game manager
func update_managers_with_level_data():
	#Sets up all entities in the sorter and then stores them and their location in the game manager manager
	var entities = {}
	for child in $World/Sorter.get_children():
		var childLoc = $World.world_to_map(child.position) #grabs the position in tilemap coordinates
		child.position = $World.map_to_world(childLoc) + tileOffset #snaps the entity to the grid in case it's not already
		entities[childLoc] = child 
		
		#Any furthur setup for the entity as needed by type
		match child.type:
			Globals.ENTITY_TYPE.CHARACTER:
				child.connect("selected", self, "select_entity")
				child.connect("done_moving", self, "hide_movement_line")
	Game_Manager.new_level_entities(entities)
	
	#Gets data on each cell being used and sends in to the movement manager to set up the level's astar node
	var cellData = {}
	for cell in $World.get_used_cells():
		cellData[cell] = $World.get_cellv(cell)
	Movement_Manager.setup(cellData)

#Player is spawned and set to the player spawnpoint
func spawn_players():
	
	var spawnSquareTopLeft = playerSpawn - Vector2(2,2)
	
	var validSpawns = []
	for cell in $World.get_used_cells():
		if !$World.get_used_cells_by_id(0).has(cell): 
			#Grabs all cells in a 5x5 area around the spawn
			if cell.x >= spawnSquareTopLeft.x and cell.x < spawnSquareTopLeft.x+5 and cell.y >= spawnSquareTopLeft.y and cell.y < spawnSquareTopLeft.y+5:
				validSpawns.append(cell)
	
	for key in Game_Manager.currentLevelEntities.keys(): #Removes the already placed entities from the list of valid spawns
		validSpawns.erase(key)
	
	for i in range(Player_Manager.party.size()): #Gets all saved characters from the player's party
		var newCharacter:Character = character.instance()
		var newCharacterSpawn = validSpawns[randi()%validSpawns.size()]
		
		$World/Sorter.add_child(newCharacter) #Adds the character to the sorter
		newCharacter.position = $World.map_to_world(newCharacterSpawn) + tileOffset #Snaps the character to the grid
		newCharacter.setup(Player_Manager.party[i], true) #Sets up the character as the correct party member
		newCharacter.connect("selected", self, "select_entity") #Connects the signal for selecting the player
		newCharacter.connect("done_moving", self, "hide_movement_line")
		
		Game_Manager.currentLevelEntities[newCharacterSpawn] = newCharacter #Adds the character to the level entries dictionary
		validSpawns.erase(newCharacterSpawn) #Removes the spawn location from the list of valid spawns

#Debug use
func print_level_details():
	print(Game_Manager.currentLevelEntities)

func start_game():
	Game_Manager.setup_level_ai()
	$Camera/CanvasLayer/UI.game_start()

#Returns a list of each valid cell
func get_valid_cells():
	var validCells = []
	for cell in $World.get_used_cells():
		if !$World.get_used_cells_by_id(0).has(cell):
			validCells.append(cell)
	return validCells

#Sets camera limits, broken atm
func set_camera_limits():
	var usedRect:Rect2 = $World.get_used_rect()
	$Camera.set_limits($World.map_to_world(usedRect.position - Vector2(2,2)), $World.map_to_world(usedRect.end + Vector2(2,2)))
#Setup ===============================================================================================

#Selecting Entities ==================================================================================
var selectedEntity = null
var validTargets = []
var selectingTargets = false
#User input
func _input(event):
	if event.is_action_pressed("game_interact"): #Right click
		if selectedEntity != null and Game_Manager.isPlayerTurn:
			match selectedEntity.type:
				Globals.ENTITY_TYPE.CHARACTER:
					if selectedEntity.isPlayerOwned:
						move_character_to(selectedEntity, $World.world_to_map(get_global_mouse_position()))
	elif event.is_action_pressed("game_select"): #Left click
		var selectedCell = $World.world_to_map(get_global_mouse_position())
		if Game_Manager.currentLevelEntities.has(selectedCell):
			select_entity(Game_Manager.currentLevelEntities[selectedCell])
		else:
			select_entity(null)

#update selected entity
func select_entity(entity):
	selectedEntity = entity
	#$Camera/CanvasLayer/UI.unselect_character()
	if selectedEntity != null:
		match selectedEntity.type:
				Globals.ENTITY_TYPE.CHARACTER:
					$World/Selector.show_selector()
					$Camera/CanvasLayer/UI.select_character(selectedEntity)
					get_reachable_cells()
					#get_valid_targets_for_action(selectedEntity, "frag")
	else:
		$World/Movement_Line.hide()
		$World/Selector.hide_selector()

#Highlights the cells that can be reached by the character
func get_reachable_cells():
	$World/Movement_Line.show()
	var reachableCells = Movement_Manager.get_furthest_reachable_points($World.world_to_map(selectedEntity.position), 4)
	var outline = []
	
	var cellSize = $World.cell_size
	reachableCells.sort()
	
	for point in reachableCells:
		#All 4 corners of the cell
		var left = $World.map_to_world(point) - Vector2(cellSize.x/2, -cellSize.y/2)
		var top = $World.map_to_world(point)
		var right = $World.map_to_world(point) + Vector2(cellSize.x/2, cellSize.y/2)
		var bottom = $World.map_to_world(point) +Vector2(0,cellSize.y)

		if !reachableCells.has(point + Vector2(1,0)): #left cell not reachable
			outline.append(right)
			outline.append(bottom)
		if !reachableCells.has(point + Vector2(-1,0)): #right cel
			outline.append(left)
			outline.append(top)
		if !reachableCells.has(point + Vector2(0,1)): 
			outline.append(left)
			outline.append(bottom)
		if !reachableCells.has(point + Vector2(0,-1)):
			outline.append(right)
			outline.append(top)
	#outline.sort()
	$World/Movement_Line.points = outline
#Selecting Entities ==================================================================================

#Entity selection, movement and combat================================================================
#Moves the selected entity to the selected location
func move_character_to(character:Character,location:Vector2):
	if $World.get_used_cells().has(location) and $World.get_cellv(location) != 0 and character.characterStats["AP"] > 0:
		var characterLocation = $World.world_to_map(character.position)
		var path:PoolVector2Array = Movement_Manager.get_shortest_path(characterLocation, location)
		
		var worldPosPath:PoolVector2Array = []
		var distance = 0
		for point in path:
			if distance <= character.characterStats["Movement_Max"]:
				worldPosPath.append($World.map_to_world(point) + tileOffset)
				distance += 1
			else:
				break
		$World/Movement_Line.points = worldPosPath
		$World/Movement_Line.show()
		worldPosPath.remove(0) #Uncessesary first point that is just the character's current location
		character.move_character(worldPosPath)
		
		#Adds the character to the new location they are at
		Game_Manager.currentLevelEntities.erase(characterLocation)
		Game_Manager.currentLevelEntities[location] = selectedEntity

#Hides the movement line when the character is done moving
func hide_movement_line():
	$World/Movement_Line.hide()

#Gets every valid target for the action
func get_valid_targets_for_action(character:Character, action):
	var pos = $World.world_to_map(character.position)
	var possibleTargers = Combat_Manager.get_valid_targets(pos, Combat_Manager.actionData[action]["range"])
	validTargets = []
	for target in possibleTargers:
		if Game_Manager.currentLevelEntities.has(target) and target != pos:
			if Game_Manager.currentLevelEntities[target].type == Globals.ENTITY_TYPE.CHARACTER:
				validTargets.append(target)
	
	print(validTargets)
#Entity selection, movement and combat================================================================


func pass_turn():
	pass # Replace with function body.
