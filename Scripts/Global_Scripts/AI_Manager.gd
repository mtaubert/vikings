extends Node

var aiCharacters = []
var playerCharacters = []
var currentSelectedCharacter:int

#Setup ================================================================================================
func _ready():
	randomize()
	Game_Manager.connect("pass_turn", self, "turn_passed")

func setup_ai(entities):
	for pos in entities:
		var entity:Character = entities[pos]
		if entity.type == Globals.ENTITY_TYPE.CHARACTER:
			if entity.isPlayerOwned:
				playerCharacters.append(entity)
			else:
				aiCharacters.append(entity)
				entity.connect("done_moving", self, "next_character_action")
	
	if aiCharacters.size() > 0:
		currentSelectedCharacter = 0 #Selects the first ai character
	
	print("The heroes:")
	for character in playerCharacters:
		print(character.characterName)
	
	print("The villains:")
	for character in aiCharacters:
		print(character.characterName)
#Setup ================================================================================================

#AI actions =========================================================================================== 
signal ai_character_move(character, location)

func turn_passed(isPlayerTurn):
	if not isPlayerTurn:
		next_character_action()

func move_current_selected_character():
	#print(String(currentSelectedCharacter) + " is moving")
	#print(String(aiCharacters[currentSelectedCharacter].characterStats["AP"]))
	var targets = Game_Manager.get_current_level_empty_cells()
	var target = targets[randi()%targets.size()]
	emit_signal("ai_character_move", aiCharacters[currentSelectedCharacter], target)

func next_character_action():
	if aiCharacters[currentSelectedCharacter].characterStats["AP"] > 0:
		print(String(currentSelectedCharacter) + " is moving")
		print(String(aiCharacters[currentSelectedCharacter].characterStats["AP"]))
		move_current_selected_character()
	else:
		if aiCharacters.size()-1 == currentSelectedCharacter:
			Game_Manager.pass_turn()
			currentSelectedCharacter = 0 #Selects the first ai character
		else:
			currentSelectedCharacter += 1 #selects the next character
			next_character_action()
#AI actions ===========================================================================================
