extends Control

signal action_pressed(selectedCharacter, action)

#Setup ==========================================================================================================================
func _ready():
	Game_Manager.connect("pass_turn", self, "toggle_pass_turn_button")
	$Character_Info.hide()
	for child in $Actions.get_children():
		child.set_action(null)
		child.connect("action_pressed", self, "action_pressed")

#Plays the game start animation with all portraits set up
func game_start():
	$Game_Details.show()
	var playerCharacterNames = []
	for character in AI_Manager.playerCharacters:
		playerCharacterNames.append(character.characterName)
	for child in $Game_Details/Player_Characters.get_children():
		if child.get_index() < playerCharacterNames.size():
			child.show()
			child.texture = Character_Manager.characterData[playerCharacterNames[child.get_index()]]["Portrait"]
		else:
			child.hide()
	
	var aiCharacterNames = []
	for character in AI_Manager.aiCharacters:
		aiCharacterNames.append(character.characterName)
	for child in $Game_Details/AI_Characters.get_children():
		if child.get_index() < aiCharacterNames.size():
			child.show()
			child.texture = Character_Manager.characterData[aiCharacterNames[child.get_index()]]["Portrait"]
		else:
			child.hide()
	
	$AnimationPlayer.play("game_start")

func quit():
	get_tree().quit()
#Setup ==========================================================================================================================

#Turn passing ===================================================================================================================
func pass_turn():
	Game_Manager.pass_turn()

func toggle_pass_turn_button(isPlayersTurn):
	$Pass.disabled = !isPlayersTurn
#Turn passing ===================================================================================================================

#Character selection and actions ================================================================================================
var selectedCharacter:Character = null

func action_pressed(action):
	if selectedCharacter != null:
		emit_signal("action_pressed", selectedCharacter, action)

#Selects a character
func select_character(character:Character):
	selectedCharacter = character
	if character.isPlayerOwned:
		var actions = Character_Manager.characterData[character.characterName]["Abilities"]
		for child in $Actions.get_children():
			if child.get_index() < actions.size():
				child.set_action(actions[child.get_index()])
			else:
				child.set_action(null)
	else:
		for child in $Actions.get_children():
			child.set_action(null)
	
	$Character_Info.show()
	$Character_Info/Portrait.texture = Character_Manager.characterData[character.characterName]["Portrait"]
	$Character_Info/Name.text = character.characterName

#Clears character selection
func unselect_character():
	selectedCharacter = null
	for child in $Actions.get_children():
		child.set_action(null)
	
	$Character_Info.hide()
#Character selection and actions ================================================================================================
