extends Node2D

var colors = []

func _ready():
	randomize()
	for child in get_children():
		if child is Sprite:
			if child.get_name() == "Body":
				var bodyIndex = randi()%Asset_Loader.vikingBodies.size()
				colors.append(bodyIndex)
				child.texture = Asset_Loader.vikingBodies[bodyIndex]
			else:
				var tempColor = Color(randf(), randf(), randf())
				colors.append(tempColor)
				child.modulate = tempColor
	$AnimationPlayer.play("idle")

func setup(customisations):
	for child in get_children():
		if child is Sprite:
			if child.get_name() == "Body":
				child.texture = Asset_Loader.vikingBodies[customisations[child.get_index()]] 
			else:
				child.modulate = customisations[child.get_index()]