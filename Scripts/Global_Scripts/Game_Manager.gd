extends Node

enum ENTITIES {
	VIKING, 
	COVER,
	OBSTACLE, 
	DOOR
}

#Signals----------------------------------------------------------------------------------------------------------------------------------------
signal selectedCell
signal interactWithCell
signal levelUpdate
#Signals----------------------------------------------------------------------------------------------------------------------------------------

#Level creation---------------------------------------------------------------------------------------------------------------------------------
var currentLevel
var levelSize = Vector2(3,3)

#Sets up a new encounter and returns the currentLevel dictionary
func setup_encounter():
	currentLevel = Encounter_Manager.new_enounter(levelSize)
	astar_setup()
	astar_get_path(Vector2(0,0), Vector2(2,2))

func get_current_encounter():
	return currentLevel

#Returns true if a given cell is in the level
func is_cell_in_level(cell:Vector2):
	if cell.x >= levelSize.x or cell.x < 0 or cell.y >= levelSize.y or cell.y < 0:
		return false
	return true
#Level creation---------------------------------------------------------------------------------------------------------------------------------

#Player interaction-----------------------------------------------------------------------------------------------------------------------------
func player_selected_cell():
	pass

func player_interacted_with_cell():
	pass
#Player interaction-----------------------------------------------------------------------------------------------------------------------------

#A Star Logic-----------------------------------------------------------------------------------------------------------------------------------
onready var aStar = AStar.new()
var obstaclePoints = []
var points = []

#Sets up aStar node
func astar_setup():
	#New level, clear all the stored points
	aStar.clear()
	obstaclePoints.clear()
	points.clear()
	
	for x in range(currentLevel.size()):
		for y in range(currentLevel[0].size()):
			match currentLevel[x][y]["tile"]:
				0:
					obstaclePoints.append(Vector2(x,y))
				_:
					aStar.add_point(points.size(), Vector3(x,y,0.0))
					points.appe.nd(Vector2(x,y))
	
	print(aStar.get_points())
	astar_connect_points()

#Connects all the points on the aStar node
func astar_connect_points():
	for point in points:
		var pointID = points.find(point)
		#Grab all adjacent points, TODO:add checks for different tile types and adjust accordingly
		var adjacentPoints = [Vector2(point.x-1, point.y), Vector2(point.x+1, point.y), Vector2(point.x, point.y-1), Vector2(point.x, point.y+1)]
		for adjacentPoint in adjacentPoints:
			if points.has(adjacentPoint) and is_cell_in_level(adjacentPoint): #Checks if the point exists and is in the level boundry
				aStar.connect_points(pointID, points.find(adjacentPoint), true)

func astar_get_path(start:Vector2, end:Vector2):
	var path = aStar.get_point_path(points.find(start), points.find(end))
	var pathAsCells:PoolVector2Array
	
	for id in path:
		pathAsCells.append(Vector2(id.x, id.y))
	
	return pathAsCells
#A Star Logic-----------------------------------------------------------------------------------------------------------------------------------