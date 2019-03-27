extends TileMap

enum ENTITIES {
	VIKING, 
	COVER, 
	DOOR
	}

var tileSize = get_cell_size()
var yOffset = Vector2(0, tileSize.y/2)

var grid
var gridSize = Vector2(40, 40)
var used_cells

onready var viking = preload("res://Scenes/Prefabs/Viking.tscn")

func _ready():
	create_grid_array()
	for i in range(5):
		if i < gridSize.x * gridSize.y:
			spawn_viking()

#Sets up the used_cells and grid arrays
func create_grid_array():
	used_cells = get_used_cells() #Gets coordinates of used cells
	
	#Creates the grid
	grid = []
	for x in range(gridSize.x):
		grid.append([])
		for y in range(gridSize.y):
			grid[x].append(null)
	
	for cell in used_cells: #Checks if each cell is in a valid location (x and y greater than or equal to 0)
		if not cell.x in range(gridSize.x) or not cell.y in range(gridSize.y):
			set_cell(cell.x, cell.y, -1)
	
	used_cells = get_used_cells()
	Movement_Manager.calculate_next_nodes(used_cells)

#Spawns a viking in a random spot on the grid
func spawn_viking():
	randomize()
	
	#Finds a random spot that is unused
	var vikingSpawn = used_cells[randi()%int(used_cells.size())]
	while grid[vikingSpawn.x][vikingSpawn.y] != null:
		vikingSpawn = used_cells[randi()%int(used_cells.size())]
	
	#set_cell(vikingSpawn.x,vikingSpawn.y,1)
	var newViking = viking.instance()
	newViking.position = map_to_world(vikingSpawn) + yOffset
	$Sorter.add_child(newViking)
	newViking.setup()
	grid[vikingSpawn.x][vikingSpawn.y] = newViking

#Returns the type of entity on the tile
func get_cell_contents(clickPos:Vector2):
	var tilePos = world_to_map(clickPos)
	#if in the bounds of the grid, returns the object at the location or null
	if tilePos.x in range(gridSize.x) and tilePos.y in range(gridSize.y): 
		return grid[tilePos.x][tilePos.y]

#Returns if a cell is in use
func is_cell(pos:Vector2):
	var tilePos = world_to_map(pos)
	#if in the bounds of the grid, returns the object at the location or null
	if tilePos.x in range(gridSize.x) and tilePos.y in range(gridSize.y): 
		if tilePos in used_cells:
			if get_cellv(tilePos) in [0,1]:
				return true
	return false

#Updates 
func update_cell(pos:Vector2, entity):
	var tilePos = world_to_map(pos)
	#Checks the location is valid then sets that tile to contain the entity
	if tilePos.x in range(gridSize.x) and tilePos.y in range(gridSize.y): 
		grid[tilePos.x][tilePos.y] = entity

#Gets the world coordinate of the center of a tile clicked
func get_tile_in_world_vector2(clickPos:Vector2):
	return map_to_world(world_to_map(clickPos)) + yOffset

#Returns the grid position of the clicked tile
func convert_to_grid_pos(clickPos:Vector2):
	return world_to_map(clickPos)

#Returns the world position of the clicked tile
func convert_to_world_pos(gridPos:Vector2):
	return map_to_world(gridPos) + yOffset