extends TextureButton

signal action_pressed(action)

var actionName:String

func set_action(action):
	if action != null:
		actionName = action
		$Action_Icon.texture = Combat_Manager.actionData[action]["icon"]
		self.show()
	else:
		actionName = ""
		self.hide()

func action_pressed():
	emit_signal("action_pressed", actionName)
