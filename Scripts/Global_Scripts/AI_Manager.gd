extends Node

var aiCharacters = {}
var playerCharacters = {}
var currentSelectedCharacter:Vector2

#Setup ================================================================================================
func _ready():
	Game_Manager.connect("pass_turn", self, "turn_passed")

func setup_ai(entities):
	for pos in entities:
		var entity:Character = entities[pos]
		if entity.type == Globals.ENTITY_TYPE.CHARACTER:
			if entity.isPlayerOwned:
				playerCharacters[pos]= entity
			else:
				aiCharacters[pos] = entity
				entity.connect("done_moving", self, "next_character_action")
	
	currentSelectedCharacter = aiCharacters.keys()[0] #Selects the first ai character
	
	print("The heroes:")
	for pos in playerCharacters:
		print(playerCharacters[pos].characterName)
	
	print("The villains:")
	for pos in aiCharacters:
		print(aiCharacters[pos].characterName)
#Setup ================================================================================================

#AI actions =========================================================================================== 
func turn_passed(isPlayerTurn):
	if not isPlayerTurn:
		move_current_selected_character()

func move_current_selected_character():
	print(aiCharacters[currentSelectedCharacter].characterName + " is moving")
	next_character_action()

func next_character_action():
	if aiCharacters.keys().back() == currentSelectedCharacter:
		Game_Manager.pass_turn()
		currentSelectedCharacter = aiCharacters.keys()[0] #Selects the first ai character
	else:
		currentSelectedCharacter = aiCharacters.keys()[aiCharacters.keys().find(currentSelectedCharacter)+1] #Grabs the next key from the aiCharacters dict
		move_current_selected_character()
#AI actions ===========================================================================================
