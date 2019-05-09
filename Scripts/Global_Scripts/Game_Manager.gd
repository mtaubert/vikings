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
	
	for pos in Movement_Manager.points:
		if !currentLevelEntities.has(pos):
			empty_cells.append(pos)
	
	return empty_cells

#Game and turn logic----------------------------------------------------------------------------------------------------------------------------
var isPlayerTurn:bool = true

func pass_turn():
	isPlayerTurn = !isPlayerTurn
	
	if isPlayerTurn:
		for character in AI_Manager.playerCharacters:
			character.refresh()
	else:
		for character in AI_Manager.aiCharacters:
			character.refresh()
	
	emit_signal("pass_turn", isPlayerTurn)

#Game and turn logic----------------------------------------------------------------------------------------------------------------------------