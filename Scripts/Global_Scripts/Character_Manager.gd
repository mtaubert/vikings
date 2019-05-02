extends Node

const characterDataJSON = "res://Assets/JSON/character_data.json"

var characterData = {}

func _ready():
	load_character_data()

func load_character_data():
	var file = File.new()
	file.open(characterDataJSON, file.READ)
	var fileJSON = JSON.parse(file.get_as_text())
	
	if fileJSON.error == OK:
		characterData = fileJSON.result
	
	#Loads portraits
	for key in characterData:
		characterData[key]["Portrait"] = load("res://Assets/Vikings/" + key + "_Portrait.png")