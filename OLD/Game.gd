extends Node2D

signal selected()

var selectedEntity


onready var grid = get_node("World/Navigation2D/Grid")
onready var navigation = get_node("World/Navigation2D")
onready var movementLine = get_node("World/Navigation2D/Grid/Sorter/Movement_Line")

func _ready():
	$Camera/Canvas/UI.connect("pass_turn", self, "refresh_vikings")

#User input
func _input(event):
	var pos = get_global_mouse_position()
	var selectedCell
	if Input.is_action_just_pressed("game_select"): #Left click
		selectedCell = grid.get_cell_contents(pos)
		#select_grid_cell(pos, selectedCell)		
	elif Input.is_action_just_pressed("game_move"): #Right click
		selectedCell = grid.get_cell_contents(pos)
	#	interact_with_cell(pos, selectedCell)

#Selectors updating
func _process(delta):
	$World/Navigation2D/Grid/Selectors.update_selectors(selectedEntity, get_global_mouse_position(), grid)

#Player left clicked cell
func select_grid_cell(pos, selectedCell):
	selectedEntity = null
	if selectedCell != null and grid.is_cell(pos):
		selectedEntity = selectedCell
	
	#emit_signal("selected", selectedEntity)

#Interacting with different game objects
#Player right clicked a cell
func interact_with_cell(pos, selectedCell):
	if selectedCell == null and selectedEntity != null and grid.is_cell(pos):
		if selectedEntity.type == grid.ENTITIES.VIKING:
			move_viking(pos)

func move_viking(moveToLocation):
	if !selectedEntity.vikingMoving:
		var path #Array of points 
		var pathSnappedToGrid:PoolVector2Array #Same array of points snapped to the grid
		
		path = navigation.get_simple_path(selectedEntity.position, moveToLocation, false)
		
		var previousPoint = null
		for point in path:
			var convertedPoint = grid.get_tile_in_world_vector2(point) #Converts the point in the calculated path to one on the grid
			if previousPoint == null or previousPoint != convertedPoint: #Ensures no duplicated points
				pathSnappedToGrid.append(convertedPoint)
				previousPoint = convertedPoint
		
		#Movement line indicator
		movementLine.points = PoolVector2Array(pathSnappedToGrid)
		movementLine.show()
		
		grid.update_cell(selectedEntity.position, null) #Updates the current cell to be empty
		grid.update_cell(pathSnappedToGrid[pathSnappedToGrid.size()-1], selectedEntity) #Updates the new end of the path as the viking
		
		selectedEntity.move(pathSnappedToGrid)