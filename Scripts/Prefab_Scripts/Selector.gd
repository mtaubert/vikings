extends Sprite

var world
var validCells
var tileOffset

func _ready():
	world = get_parent()
	tileOffset = Vector2(0,world.cell_size.y/2)
	hide()

func set_valid_cells(cells):
	validCells = cells

func show_selector():
	show()
	$AnimationPlayer.play("indicate")
	set_process(true)

func hide_selector():
	hide()
	$AnimationPlayer.stop()
	set_process(false)

func _process(delta):
	var mouseHoverCell = world.world_to_map(get_global_mouse_position())
	if(mouseHoverCell in validCells):
		show()
		position = world.map_to_world(mouseHoverCell) + tileOffset
	else:
		hide()