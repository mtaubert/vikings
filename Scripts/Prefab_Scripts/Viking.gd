extends KinematicBody2D

var type
var grid
var controller

onready var defaultSprite = preload("res://Assets/player.png")
onready var crouchSprite = preload("res://Assets/player_crouch.png")

var playerColor = Color("00ff00")
var opponentColor = Color("ff0000")

func cartesian_to_isometric(vector):
	return Vector2(vector.x - vector.y, (vector.x + vector.y) / 2)

func setup(gridIn):
	grid = gridIn
	type = grid.ENTITIES.VIKING
	print(type)
	$Sprite.modulate = playerColor

var targetPos
var motion
var moving = false
const MAX_SPEED = 1200

func _input(event):
	#Player_Inputs
	if Input.is_action_pressed("ui_page_down"):
		$Sprite.texture = crouchSprite
	elif Input.is_action_pressed("ui_page_up"):
		$Sprite.texture = defaultSprite
	elif Input.is_action_pressed("game_select"):
		print(grid.get_tile_contents(get_global_mouse_position()))
	
	var direction = Vector2(0,0)
	#Debug movement
	if Input.is_action_pressed("ui_up"):
		direction.y = -100
	elif Input.is_action_pressed("ui_down"):
		direction.y = 100
	elif Input.is_action_pressed("ui_left"):
		direction.x = -100
	elif Input.is_action_pressed("ui_right"):
		direction.x = 100
	
	self.move_and_collide(cartesian_to_isometric(direction))