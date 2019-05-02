extends TileMap

var tileSize = get_cell_size()
var yOffset = Vector2(0, tileSize.y/2)

var grid
var usedCells

func _ready():
	Game_Manager.connect("levelUpdate", self, "update_grid")
	
	Game_Manager.setup_encounter()
	grid = Game_Manager.get_current_encounter()
	clear_grid()
	setup_grid()

#Clears grid, ensures the world is empty
func clear_grid():
	for cell in get_used_cells():
		set_cell(cell.x, cell.y, -1)

#Loads in all the characters and obstacles in the grid
func setup_grid():
	for x in range(grid.size()):
		for y in range(grid[0].size()):
			set_cell(x,y,grid[x][y]["tile"])
			
			if grid[x][y]["viking"] != null:
				grid[x][y]["viking"].position = map_to_world(Vector2(x,y)) + yOffset
				$Sorter.add_child(grid[x][y]["viking"])
				grid[x][y]["viking"].setup(self, Game_Manager.ENTITIES.VIKING)

func update_grid(newGrid):
	grid.clear()
	grid = newGrid