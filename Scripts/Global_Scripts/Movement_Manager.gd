extends Node

var nextNodes = {}

#Calculates the neighbours of each node
func calculate_next_nodes(nodes):
	for node in nodes:
		nextNodes[node] = []
	
	for node in nextNodes:
		if nodes.has(Vector2(node.x+1, node.y)):
			nextNodes[node].append(Vector2(node.x+1, node.y))
		if nodes.has(Vector2(node.x-1, node.y)):
			nextNodes[node].append(Vector2(node.x-1, node.y))
		if nodes.has(Vector2(node.x, node.y+1)):
			nextNodes[node].append(Vector2(node.x, node.y+1))
		if nodes.has(Vector2(node.x, node.y-1)):
			nextNodes[node].append(Vector2(node.x, node.y-1))

#Returns a list of Vector2s that border the given Vector2
func get_neighbours(node):
	return nextNodes[node]

func get_path_between(start:Vector2, end:Vector2):
	var path
	var depth = 1
	
	while true:
		path = depth_first_search(start, end, depth)
		if path != null:
			return PoolVector2Array(path)
		depth += 1

func depth_first_search(start:Vector2, end:Vector2, depth):
	if depth == 0:
		return null
	elif start == end:
		var path = [start]
		return PoolVector2Array(path)
	else:
		for node in nextNodes[start]:
			var path = depth_first_search(node, end, depth-1)
			if path != null:
				path.append(start)
				return PoolVector2Array(path) 
		return null