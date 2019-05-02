extends Node

var currentLevel = {}

#Current Level logic----------------------------------------------------------------------------------------------------------------------------

#Current Level logic----------------------------------------------------------------------------------------------------------------------------

#A Star Logic-----------------------------------------------------------------------------------------------------------------------------------
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
			0:
				obstaclePoints.append(pos)
			_:
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
	var furthestReachablePoints:PoolVector2Array = []
	
	for x in range(1, maxDistance+1):
		for y in range(1, maxDistance+1):
			if points.has(location + Vector2(x,y)):
				var distance = astar_get_distance(location, location + Vector2(x,y))
				if distance == maxDistance:
					furthestReachablePoints.append(location + Vector2(x,y))
			if points.has(location - Vector2(x,y)):
				var distance = astar_get_distance(location, location - Vector2(x,y))
				if distance == maxDistance:
					furthestReachablePoints.append(location - Vector2(x,y))
	
	return furthestReachablePoints

#Gets the distance between two vector2s
func astar_get_distance(a:Vector2,b:Vector2):
	var pointA = points.find(a)
	var pointB = points.find(b)
	var distance = aStar.get_point_path(pointA, pointB).size()-1
	return distance

func astar_add_point(newPoint:Vector2):
	pass
	#TODO add points when terrain is destroyed

func astar_remove_point(removePoint:Vector2):
	pass
	#Todo remove points when applicable
#A Star Logic-----------------------------------------------------------------------------------------------------------------------------------