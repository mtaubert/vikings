extends Node

#A Star Logic-----------------------------------------------------------------------------------------------------------------------------------
var currentLevel = {}
onready var aStar = AStar.new()
var obstaclePoints = []
var points = []

#Sets up aStar node
func setup(levelCells):
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
	
	connect_points()

#Connects all the points on the aStar node
func connect_points():
	for point in points:
		add_point(point)

#Returns an array of the shortest path
func get_shortest_path(start:Vector2, end:Vector2):
	var path = aStar.get_point_path(points.find(start), points.find(end))
	var pathAsCells:PoolVector2Array
	
	for id in path:
		pathAsCells.append(Vector2(id.x, id.y))
	
	return pathAsCells

#Gets the points at the max distance from the given location
func get_furthest_reachable_points(location, maxDistance):
	var locationID = points.find(location)
	var reachAblePoints = []
	
	var searchAreaTopLeft = location - Vector2(maxDistance,maxDistance)
	
	for point in points:
		if point.x >= searchAreaTopLeft.x and point.x < searchAreaTopLeft.x+(2*maxDistance)+1 and point.y >= searchAreaTopLeft.y and point.y < searchAreaTopLeft.y+(2*maxDistance)+1:
			if get_distance(location, point) <= maxDistance:
				reachAblePoints.append(point)
	
	return reachAblePoints

#Gets the distance between two vector2s
func get_distance(a:Vector2,b:Vector2):
	var pointA = points.find(a)
	var pointB = points.find(b)
	var distance = aStar.get_point_path(pointA, pointB).size()-1
	return distance

#Adds a point and connects it to it's neighbors
func add_point(newPoint:Vector2):
	var pointID = points.find(newPoint)
	#Grab all adjacent points, TODO:add checks for different tile types and adjust accordingly
	var adjacentPoints = [Vector2(newPoint.x-1, newPoint.y), Vector2(newPoint.x+1, newPoint.y), Vector2(newPoint.x, newPoint.y-1), Vector2(newPoint.x, newPoint.y+1)]
	for adjacentPoint in adjacentPoints:
		if points.has(adjacentPoint): #Checks if the point exists 
			aStar.connect_points(pointID, points.find(adjacentPoint), true)

#Disconnects a point from its neighbors
func remove_point(removePoint:Vector2):
	var pointID = points.find(removePoint)
	#Grab all adjacent points, TODO:add checks for different tile types and adjust accordingly
	var adjacentPoints = [Vector2(removePoint.x-1, removePoint.y), Vector2(removePoint.x+1, removePoint.y), Vector2(removePoint.x, removePoint.y-1), Vector2(removePoint.x, removePoint.y+1)]
	for adjacentPoint in adjacentPoints:
		if points.has(adjacentPoint): #Checks if the point
			if aStar.are_points_connected(pointID, points.find(adjacentPoint)):
				aStar.disconnect_points(pointID, points.find(adjacentPoint))
#A Star Logic-----------------------------------------------------------------------------------------------------------------------------------