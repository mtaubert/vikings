extends Node2D

func ready():
	pass

func random_look():
	randomize()
	
	var bodyColor = Asset_Loader.bodyColors[randi()%Asset_Loader.bodyColors.size()]
	$Body.texture = Asset_Loader.bodies[randi()%Asset_Loader.bodies.size()]
	$Body.modulate = bodyColor
	$Face.texture = Asset_Loader.faces[randi()%Asset_Loader.faces.size()]
	
	var beard = randi()%(Asset_Loader.beards.size()+1)
	if beard < Asset_Loader.beards.size():
		$Face/Beard.texture = Asset_Loader.beards[beard]
		$Face/Beard.modulate = Asset_Loader.beardColors[randi()%Asset_Loader.beardColors.size()]
	else:
		$Face/Beard.hide()
	
	var helmet = randi()%(Asset_Loader.helmets.size()+1)
	if helmet < Asset_Loader.helmets.size():
		$Face/Helmet.texture = Asset_Loader.helmets[helmet]
	else:
		$Face/Helmet.hide()
	
	var handType = randi()%Asset_Loader.hands.size()
	$Left_Hand.texture = Asset_Loader.hands[handType]
	$Right_Hand.texture = Asset_Loader.hands[handType]
	if handType == 0:
		$Left_Hand.modulate = bodyColor
		$Right_Hand.modulate = bodyColor
	