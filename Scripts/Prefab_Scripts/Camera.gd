extends Camera2D

var cameraMovement
var cameraSpeed = 10

func _process(delta):
	cameraMovement = Vector2(0,0)
	
	var mousePos = get_viewport().get_mouse_position()
	
	if mousePos.x < 100:
		cameraMovement.x = -((1-(mousePos.x/100)) * cameraSpeed)
	elif mousePos.x > 1820:
		cameraMovement.x = (((mousePos.x-1820)/100) * cameraSpeed)
	
	if mousePos.y < 100:
		cameraMovement.y = -((1-(mousePos.y/100)) * cameraSpeed)
	elif mousePos.y > 980:
		cameraMovement.y = (((mousePos.y-980)/100) * cameraSpeed)
	
	self.position += cameraMovement