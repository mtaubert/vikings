extends Camera2D

var cameraMovement
var viewport
var cameraSpeed = 500
var cameraZoomSPeed = Vector2(0.1, 0.1)

func _ready():
	viewport = get_viewport()
	Globals.set("camera", self)

func set_limits(topLeft:Vector2, bottomRight:Vector2):
	print(topLeft)
	print(bottomRight)
	limit_left = topLeft.x
	limit_top = topLeft.y
	limit_right = bottomRight.x
	limit_right = bottomRight.y

func _input(event):
	if Input.is_action_just_pressed("camera_scroll_out") and self.zoom < Vector2(3,3):
		self.zoom += cameraZoomSPeed
	elif Input.is_action_just_pressed("camera_scroll_in") and self.zoom > Vector2(0.5, 0.5):
		self.zoom -= cameraZoomSPeed

#Camera movement WIP
func _physics_process(delta):
	cameraMovement = Vector2(0,0)
	var mousePos = viewport.get_mouse_position()
	
	if mousePos.x < 150:
		cameraMovement.x = -(1 * cameraSpeed)
	elif mousePos.x > 1130:
		cameraMovement.x = (1 * cameraSpeed)
	
	if mousePos.y < 150:
		cameraMovement.y = -(1 * cameraSpeed)
	elif mousePos.y > 570:
		cameraMovement.y = (1 * cameraSpeed)
	
	self.position += cameraMovement * delta