extends Node2D

var difficultyOptions = ["Easy", "Medium", "Hard"]

func _ready():
	for child in $Background.get_children():
		child.random_look()
	$Options.hide()

func quit():
	get_tree().quit()

func start_game():
	Scene_Manager.load_scene("Game")

#Options--------------------------------------------------------------------------------------
var optionsVisible = false
var tweenQueue = []
func show_options():
	$Options.show()
	tweenQueue.clear()
	for child in $Menu_Buttons.get_children():
		if child is Button:
			child.disabled = true
	for child in $Options.get_children():
		if not child is Tween:
			tweenQueue.append(child)
			if child is Button:
				child.disabled = true
			if child is HSlider:
				child.editable = false
			if child is TextEdit:
				child.readonly = true
	$Options/Options_Tween.interpolate_property(tweenQueue[0], "rect_scale", Vector2(0.001,1), Vector2(1,1), 0.1, Tween.TRANS_BACK, Tween.EASE_OUT)
	$Options/Options_Tween.start()
	optionsVisible = true

func hide_options():
	tweenQueue.clear()
	for child in $Options.get_children():
		if not child is Tween:
			tweenQueue.append(child)
			if child is Button:
				child.disabled = true
			if child is HSlider:
				child.editable = false
			if child is TextEdit:
				child.readonly = true
	$Options/Options_Tween.interpolate_property(tweenQueue[0], "rect_scale", Vector2(1,1), Vector2(0.001,1), 0.1, Tween.TRANS_BACK, Tween.EASE_IN)
	$Options/Options_Tween.start()
	optionsVisible = false

func _on_Options_Tween_tween_completed(object, key):
	tweenQueue.remove(0)
	if optionsVisible: 
		if tweenQueue.size() > 0: #Showing options
			$Options/Options_Tween.interpolate_property(tweenQueue[0], "rect_scale", Vector2(0.001,1), Vector2(1,1), 0.1, Tween.TRANS_BACK, Tween.EASE_OUT)
			$Options/Options_Tween.start()
		else: #Animation done
			for child in $Options.get_children():
				if child is Button:
					child.disabled = false
				if child is HSlider:
					child.editable = true
				if child is TextEdit:
					child.readonly = false
	if !optionsVisible: #Hiding options
		if tweenQueue.size() > 0: #Animation in progress
			$Options/Options_Tween.interpolate_property(tweenQueue[0], "rect_scale", Vector2(1,1), Vector2(0.001,1), 0.1, Tween.TRANS_BACK, Tween.EASE_IN)
			$Options/Options_Tween.start()
		else: #Animation done
			for child in $Menu_Buttons.get_children():
				if child is Button:
					child.disabled = false

func adjust_options_scale():
	for child in $Options.get_children():
		if not child is Tween:
			child.rect_scale = Vector2(0.001,1)
#Options--------------------------------------------------------------------------------------

