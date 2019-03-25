extends TileMap

enum ENTITIES {
	VIKING, 
	COVER, 
	DOOR
	}

var tileSize = get_cell_size()
var yOffset = Vector2(0, tileSize.y/2)
var gridSize = Vector2(15,15)

var grid = []

onready var viking = preload("res://Scenes/Prefabs/Viking.tscn")

func _ready():
	for x in range(gridSize.x):
		grid.append([])
		for y in range(gridSize.y):
			grid[x].append(null)
			set_cell(x,y,0)
	
	randomize()
	var vikingSpawn = Vector2(randi()%int(gridSize.x), randi()%int(gridSize.y))
	set_cell(vikingSpawn.x,vikingSpawn.y,1)
	var newViking = viking.instance()
	newViking.setup(self)
	newViking.position = map_to_world(vikingSpawn) + yOffset
	grid[vikingSpawn.x][vikingSpawn.y] = newViking.get_name()
	$Sorter.add_child(newViking)

#Checks if the tile is empty
func is_tile_empty(currentPos:Vector2, direction:Vector2):
	var destination = world_to_map(currentPos) + direction
	if destination.x in range(gridSize.x) and destination.y in range(gridSize.y):
		if grid[destination.x][destination.y] == null:	
			return true
	return false

#Returns the type of entity on the tile
func get_tile_contents(clickPos:Vector2):
	var tilePos = world_to_map(clickPos)
	if tilePos.x in range(gridSize.x) and tilePos.y in range(gridSize.y):
		return grid[tilePos.x][tilePos.y]

func update_position(oldPos:Vector2, direction:Vector2, name):
	var gridPos = world_to_map(oldPos)
	grid[gridPos.x][gridPos.y] = null
	grid[gridPos.x + direction.x][gridPos.y + direction.y] = name
	
	return map_to_world(oldPos + direction) + yOffset