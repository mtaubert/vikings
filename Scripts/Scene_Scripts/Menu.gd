extends Node2D

onready var optionsMenu = get_node("Main_Menu/Options")
onready var mainMenu = get_node("Main_Menu/Menu_Buttons")
onready var optionsTween = get_node("Main_Menu/Options/Options_Tween")

func _ready():
	$Main_Menu/Options.hide()

func quit():
	get_tree().quit()

func start_game():
	Scene_Manager.load_scene("Game")

#Options--------------------------------------------------------------------------------------
var optionsVisible = false
var tweenQueue = []
var tweenSpeed = 0.05

func show_options():
	optionsMenu.show()
	tweenQueue.clear()
	for child in mainMenu.get_children():
		if child is Button:
			child.disabled = true
	for child in optionsMenu.get_children():
		if not child is Tween:
			tweenQueue.append(child)
			if child is Button:
				child.disabled = true
			if child is HSlider:
				child.editable = false
			if child is TextEdit:
				child.readonly = true
	optionsTween.interpolate_property(tweenQueue[0], "rect_scale", Vector2(0.001,1), Vector2(1,1), tweenSpeed, Tween.TRANS_BACK, Tween.EASE_OUT)
	optionsTween.start()
	optionsVisible = true

func hide_options():
	tweenQueue.clear()
	for child in optionsMenu.get_children():
		if not child is Tween:
			tweenQueue.append(child)
			if child is Button:
				child.disabled = true
			if child is HSlider:
				child.editable = false
			if child is TextEdit:
				child.readonly = true
	optionsTween.interpolate_property(tweenQueue[0], "rect_scale", Vector2(1,1), Vector2(0.001,1), tweenSpeed, Tween.TRANS_BACK, Tween.EASE_IN)
	optionsTween.start()
	optionsVisible = false

func _on_Options_Tween_tween_completed(object, key):
	tweenQueue.remove(0)
	if optionsVisible: 
		if tweenQueue.size() > 0: #Showing options
			optionsTween.interpolate_property(tweenQueue[0], "rect_scale", Vector2(0.001,1), Vector2(1,1), tweenSpeed, Tween.TRANS_BACK, Tween.EASE_OUT)
			optionsTween.start()
		else: #Animation done
			for child in optionsMenu.get_children():
				if child is Button:
					child.disabled = false
				if child is HSlider:
					child.editable = true
				if child is TextEdit:
					child.readonly = false
	if !optionsVisible: #Hiding options
		if tweenQueue.size() > 0: #Animation in progress
			optionsTween.interpolate_property(tweenQueue[0], "rect_scale", Vector2(1,1), Vector2(0.001,1), tweenSpeed, Tween.TRANS_BACK, Tween.EASE_IN)
			optionsTween.start()
		else: #Animation done
			for child in mainMenu.get_children():
				if child is Button:
					child.disabled = false

func adjust_options_scale():
	for child in optionsMenu.get_children():
		if not child is Tween:
			child.rect_scale = Vector2(0.001,1)
#Options--------------------------------------------------------------------------------------

