extends Node

onready var viking = preload("res://Scenes/Prefabs/Viking.tscn")
onready var obstacle = preload("res://Scenes/Prefabs/Obstacle.tscn")
onready var cover = preload("res://Scenes/Prefabs/Cover.tscn")

func _ready():
	randomize()

#Generates an new encounter of given size
func new_enounter(size:Vector2):
	var grid = []
	
	for x in range(size.x):
		grid.append([])
		for y in range(size.y):
			var cellData = {
				"tile":1,
				"viking":null,
				"contents":null
			}
			grid[x].append(cellData)
	grid = add_obstacles(grid)
	grid = add_characters(grid)
	return grid

#Spawns all characters for this encounter
func add_characters(grid):
	var playerColor = Color("0000FF")
	for i in range(5): #Spawns 5 vikings
		while true:
			var spawnLoc = Vector2(randi()%grid.size(), randi()%grid[0].size()) #Generate a random spawn
			if grid[spawnLoc.x][spawnLoc.y] != null: #Check the grid area isn't null
				if grid[spawnLoc.x][spawnLoc.y]["tile"] != 0 and grid[spawnLoc.x][spawnLoc.y]["viking"] == null and grid[spawnLoc.x][spawnLoc.y]["contents"] == null: #Ensure the cell is empty
					var newViking = viking.instance()
					newViking.set_color(playerColor)
					grid[spawnLoc.x][spawnLoc.y]["viking"] = newViking
					break
	return grid

#Spawns all obstacles for this encounter
func add_obstacles(grid):
	return grid