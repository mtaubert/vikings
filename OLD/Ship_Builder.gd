extends Node

var ship = []
func build_ship(size:Vector2):
	for x in range(size.x):
		ship.append([])
		for y in range(size.y):
			ship[x].append(0)
	
	randomize()
	for i in range(5):
		var temp = Vector2(randi()%int(size.x), randi()%int(size.y))
		if ship[temp.x][temp.y] != 2:
			ship[temp.x][temp.y] = 2
			
	
	return ship
