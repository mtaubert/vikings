extends Node

func load_scene(scene):
	get_tree().change_scene("res://Scenes/" + scene +".tscn")