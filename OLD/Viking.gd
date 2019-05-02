extends Node2D

var names = [
"Sighadd", 
"Balli", 
"Hallfred", 
"Thorlak", 
"Tore", 
"Bothvar", 
"Kabbi", 
"Mursi", 
"Sigestæl", 
"Bui",
"Sighadd",
"Ragnar" 
]

#Grid variables
var grid
var movementLine 

#Viking identification
var type
var controller
var vikingName

#Customisation---------------------------------------------------------------------------------
func setup(gridIn, typeIn):
	grid = gridIn
	type = typeIn
	
	randomize()
	vikingName = names[randi()%names.size()] + " " + names[randi()%names.size()] + "sson"

func get_customisations():
	return $Viking_Sprites.customisationValues

func set_color(color:Color):
	$Debug_Sprite.modulate = color
#Customisation---------------------------------------------------------------------------------

#Movement---------------------------------------------------------------------------------
var path
var vikingMoving = false
var speed = 100

func move(newPath):
	path = newPath
	print(path)
	vikingMoving = true
	set_process(true)

func _process(delta):
	if !path:
		vikingMoving = false
		set_process(false)
		return

	if path.size() > 0:
		var distance: float = self.position.distance_to(path[0])
		if distance > 5:
			self.position = self.position.linear_interpolate(path[0], (speed * delta)/distance)
		else:
			if path.size() == 1:
				pass
				#movementLine.hide()
			path.remove(0)
#Movement---------------------------------------------------------------------------------