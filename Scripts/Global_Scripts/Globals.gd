extends Node

enum ENTITY_TYPE {
	CHARACTER,
	WALL,
	ENTITY
}

var globals = {
	"camera": null
}

func set(name, entity):
	print("Set " + name)
	globals[name] = entity

func get(name):
	return globals[name]