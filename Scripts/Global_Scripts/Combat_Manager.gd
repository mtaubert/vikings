extends Node
const effectsDataJSON = "res://Assets/JSON/effects_data.json"
const actionDataJSON = "res://Assets/JSON/actions_data.json"

var effectsData = {}
var actionData = {}

#Setup ===========================================================================================================
func _ready():
	load_effects_data()
	load_action_data()
	print(effectsData)
	print(actionData)

func load_effects_data():
	var file = File.new()
	file.open(effectsDataJSON, file.READ)
	var fileJSON = JSON.parse(file.get_as_text())
	
	if fileJSON.error == OK:
		effectsData = fileJSON.result
	
	#Loads portraits
	for key in effectsData:
		effectsData[key]["icon"] = load("res://Assets/Effects/" + key + ".png")

func load_action_data():
	var file = File.new()
	file.open(actionDataJSON, file.READ)
	var fileJSON = JSON.parse(file.get_as_text())
	
	if fileJSON.error == OK:
		actionData = fileJSON.result
	
	#Loads portraits
	for key in actionData:
		actionData[key]["icon"] = load("res://Assets/Actions/" + key + ".png")
#Setup ===========================================================================================================

#Actions =========================================================================================================
func action_selected(character:Character, action):
	print(character.characterName + " " + action)
#Actions =========================================================================================================

