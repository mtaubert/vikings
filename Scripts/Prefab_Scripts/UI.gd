extends Control

func _ready():
	Game_Manager.connect("pass_turn", self, "toggle_pass_turn_button")
	for child in $Actions.get_children():
		child.set_action(null)
		child.connect("action_pressed", Combat_Manager, "action_selected")

#Plays the game start animation with all portraits set up
func game_start():
	$Game_Details.show()
	var playerCharacterNames = []
	for pos in AI_Manager.playerCharacters:
		playerCharacterNames.append(AI_Manager.playerCharacters[pos].characterName)
	for child in $Game_Details/Player_Characters.get_children():
		if child.get_index() < playerCharacterNames.size():
			child.show()
			child.texture = Character_Manager.characterData[playerCharacterNames[child.get_index()]]["Portrait"]
		else:
			child.hide()
	
	var aiCharacterNames = []
	for pos in AI_Manager.aiCharacters:
		aiCharacterNames.append(AI_Manager.aiCharacters[pos].characterName)
	for child in $Game_Details/AI_Characters.get_children():
		if child.get_index() < aiCharacterNames.size():
			child.show()
			child.texture = Character_Manager.characterData[aiCharacterNames[child.get_index()]]["Portrait"]
		else:
			child.hide()
	
	$AnimationPlayer.play("game_start")

func toggle_pass_turn_button(isPlayersTurn):
	$Pass.disabled = !isPlayersTurn

func quit():
	get_tree().quit()

func pass_turn():
	Game_Manager.pass_turn()

#Selects a character
func select_character(character:Character):
	var actions = Character_Manager.characterData[character.characterName]["Abilities"]
	for child in $Actions.get_children():
		if child.get_index() < actions.size():
			child.set_action(actions[child.get_index()])
		else:
			child.set_action(null)

#Clears character selection
func unselect_character():
	for child in $Actions.get_children():
		child.set_action(null)