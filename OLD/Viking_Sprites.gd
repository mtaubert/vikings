extends Node2D

var customisationValues = []

func _ready():
	randomize()
	
	var bodyIndex = randi()%Asset_Loader.bodies.size()
	customisationValues.append(bodyIndex)
	$Body.texture = Asset_Loader.bodies[bodyIndex]
	
	var headIndex = randi()%Asset_Loader.heads.size()
	customisationValues.append(headIndex)
	$Head.texture = Asset_Loader.heads[headIndex]
	
	var handsColor = Color("ffe1c6")
	customisationValues.append(handsColor)
	$Left_Hand.modulate = handsColor
	$Right_Hand.modulate = handsColor
	
	var footColor = Color("000000")
	customisationValues.append(footColor)
	$Left_Foot.modulate = footColor
	$Right_Foot.modulate = footColor
	
	var weaponIndex = randi()%(Asset_Loader.weapons.size()+1)
	customisationValues.append(weaponIndex)
	if weaponIndex == Asset_Loader.weapons.size():
		$Right_Hand/Weapon.hide()
	elif weaponIndex < Asset_Loader.weapons.size():
		$Right_Hand/Weapon.texture = Asset_Loader.weapons[weaponIndex]
		$Right_Hand/Weapon.show()
	$AnimationPlayer.play("idle")

func setup(customisations):
	customisationValues.clear()
	
	customisationValues.append(customisations[0])
	$Body.texture = Asset_Loader.bodies[customisations[0]]
	
	customisationValues.append(customisations[1])
	$Head.texture = Asset_Loader.heads[customisations[1]]
	
	customisationValues.append(customisations[2])
	$Left_Hand.modulate = customisations[2]
	$Right_Hand.modulate = customisations[2]
	
	customisationValues.append(customisations[3])
	$Left_Foot.modulate = customisations[3]
	$Right_Foot.modulate = customisations[3]
	
	customisationValues.append(customisations[4])
	if customisations[4] == Asset_Loader.weapons.size():
		$Right_Hand/Weapon.hide()
	elif customisations[4] < Asset_Loader.weapons.size():
		$Right_Hand/Weapon.texture = Asset_Loader.weapons[customisations[4]]
		$Right_Hand/Weapon.show()