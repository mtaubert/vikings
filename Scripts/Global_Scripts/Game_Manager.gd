extends Node

#Signals
signal pass_turn(isPlayerTurn) #Emitted when the turn is passed

var currentLevelEntities = {}

#Current Level logic----------------------------------------------------------------------------------------------------------------------------
func new_level_entities(entities):
	currentLevelEntities.clear()
	currentLevelEntities = entities

func setup_level_ai():
	AI_Manager.setup_ai(currentLevelEntities)

#Returns an array with the (x,y) coordinates of empty cells
func get_current_level_empty_cells():
	var empty_cells:PoolVector2Array = []
	
	for pos in points:
		if !currentLevelEntities.has(pos):
			empty_cells.append(pos)
	
	return empty_cells

#Game and turn logic----------------------------------------------------------------------------------------------------------------------------
var isPlayerTurn:bool = true

func pass_turn():
	isPlayerTurn = !isPlayerTurn
	emit_signal("pass_turn", isPlayerTurn)

#Game and turn logic----------------------------------------------------------------------------------------------------------------------------

#A Star Logic-----------------------------------------------------------------------------------------------------------------------------------
var currentLevel = {}
onready var aStar = AStar.new()
var obstaclePoints = []
var points = []

#Sets up aStar node
func astar_setup(levelCells):
	currentLevel.clear()
	currentLevel = levelCells
	
	#New level, clear all the stored points
	aStar.clear()
	obstaclePoints.clear()
	points.clear()
	
	for pos in currentLevel:
		match(currentLevel[pos]):
			0: #Naturally blocked tile
				obstaclePoints.append(pos)
			_: #Any other tile type
				aStar.add_point(points.size(), Vector3(pos.x,pos.y,0.0))
				points.append(pos)
	
	astar_connect_points()

#Connects all the points on the aStar node
func astar_connect_points():
	for point in points:
		var pointID = points.find(point)
		#Grab all adjacent points, TODO:add checks for different tile types and adjust accordingly
		var adjacentPoints = [Vector2(point.x-1, point.y), Vector2(point.x+1, point.y), Vector2(point.x, point.y-1), Vector2(point.x, point.y+1)]
		for adjacentPoint in adjacentPoints:
			if points.has(adjacentPoint) and currentLevel.has(adjacentPoint): #Checks if the point exists and is in the level boundry
				aStar.connect_points(pointID, points.find(adjacentPoint), true)

func astar_get_path(start:Vector2, end:Vector2):
	var path = aStar.get_point_path(points.find(start), points.find(end))
	var pathAsCells:PoolVector2Array
	
	for id in path:
		pathAsCells.append(Vector2(id.x, id.y))
	
	return pathAsCells

#Gets the points at the max distance from the given location
func astar_get_furthest_reachable_points(location, maxDistance):
	var locationID = points.find(location)
	var reachAblePoints:PoolVector2Array = []
	
	var searchAreaTopLeft = location - Vector2(maxDistance,maxDistance)
	
	for point in points:
		if point.x >= searchAreaTopLeft.x and point.x < searchAreaTopLeft.x+maxDistance and point.y >= searchAreaTopLeft.y and point.y < searchAreaTopLeft.y+maxDistance:
			if astar_get_distance(location, point) <= maxDistance:
				reachAblePoints.append(point)
	
	return reachAblePoints

#Gets the distance between two vector2s
func astar_get_distance(a:Vector2,b:Vector2):
	var pointA = points.find(a)
	var pointB = points.find(b)
	var distance = aStar.get_point_path(pointA, pointB).size()-1
	print(distance)
	return distance

func astar_add_point(newPoint:Vector2):
	pass
	#TODO add points when terrain is destroyed

func astar_remove_point(removePoint:Vector2):
	pass
	#Todo remove points when applicable
#A Star Logic-----------------------------------------------------------------------------------------------------------------------------------