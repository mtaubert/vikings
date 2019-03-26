extends Node2D

signal selected()

var selectedViking
var path
var speed = 100

onready var grid = get_node("World/Navigation2D/Grid")
onready var navigation = get_node("World/Navigation2D")

func _input(event):
	var selected
	
	if Input.is_action_just_pressed("game_select"): #Left click
		selected = grid.get_cell_contents(get_global_mouse_position()) #Grab the item in the grid there
		emit_signal("selected", selected)
		if selected != null:
			if selected.type == grid.ENTITIES.VIKING:
				selectedViking = selected
			else:
				selectedViking = null
		else:
			selectedViking = null
			
	elif Input.is_action_just_pressed("game_move"):
		selected = grid.get_cell_contents(get_global_mouse_position())
		if selected == null and selectedViking != null:
			print(selectedViking.position)
			print(grid.get_tile_in_world_vector2(get_global_mouse_position()))
			path = navigation.get_simple_path(selectedViking.position, grid.get_tile_in_world_vector2(get_global_mouse_position()), false)
			print(path)
			$World/Movement_Line.points = PoolVector2Array(path)
			$World/Movement_Line.show()

func _process(delta: float):
	if !path:
		$World/Movement_Line.hide()
		return
	if path.size() > 0:
		var d: float = selectedViking.position.distance_to(path[0])
		if d > 10:
			selectedViking.position = selectedViking.position.linear_interpolate(path[0], (speed * delta)/d)
		else:
			path.remove(0)