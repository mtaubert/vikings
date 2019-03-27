extends Node2D

signal selected()

var selectedEntity


onready var grid = get_node("World/Navigation2D/Grid")
onready var navigation = get_node("World/Navigation2D")

func _ready():
	$Camera/Canvas/UI.connect("pass_turn", self, "refresh_vikings")

#User input
func _input(event):
	var pos = get_global_mouse_position()
	var selected
	if Input.is_action_just_pressed("game_select"): #Left click
		selected = grid.get_cell_contents(pos)
		select_grid_cell(pos, selected)		
	elif Input.is_action_just_pressed("game_move"): #Right click
		selected = grid.get_cell_contents(pos)
		interact_with_cell(pos, selected)

#Wiking Movement
func _process(delta):
	$World/Navigation2D/Grid/Selectors.update_selectors(selectedEntity, get_global_mouse_position(), grid)

#Player right clicked a cell
func interact_with_cell(pos, selected):
	if selected == null and selectedEntity != null:
		if selectedEntity.type == grid.ENTITIES.VIKING:
			if !selectedEntity.vikingMoving:
				var path
				var pathSnappedToGrid:PoolVector2Array
				grid.update_cell(selectedEntity.position, null)
				
				#path = Movement_Manager.get_path_between(grid.convert_to_grid_pos(selectedEntity.position), grid.convert_to_grid_pos(pos))
				path = navigation.get_simple_path(selectedEntity.position, pos, false)
				
				for point in path:
					#pathSnappedToGrid.append(grid.convert_to_world_pos(point))
					pathSnappedToGrid.append(grid.get_tile_in_world_vector2(point))
				
				$World/Movement_Line.points = PoolVector2Array(pathSnappedToGrid)
				$World/Movement_Line.show()
				selectedEntity.move(pathSnappedToGrid)

#Selects the contents of the cell
func select_grid_cell(pos, selected):
	selectedEntity = null
	emit_signal("selected", selected)
	if selected != null:
		selectedEntity = selected