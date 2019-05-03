extends Node

enum ENTITY_TYPE {
	CHARACTER, #A
	WALL,
	ENTITY
}

enum WORLD_TYPE {
	BLOCKED, #Unused
	DEBUG, 
	DESERT
}

var globals = {
	"camera": null
}

func set(entityName, entity):
	globals[entityName] = entity

func get(entityName):
	return globals[entityName]