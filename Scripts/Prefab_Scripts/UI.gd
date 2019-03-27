extends Control

signal pass_turn()

func _ready():
	get_parent().get_parent().get_parent().connect("selected", self, "toggle_selection_view")
	$Selection.hide()

func toggle_selection_view(entity):
	if entity == null:
		$Selection.hide()
	else:
		$Selection.show()
		match entity.type:
			0: #viking
				$Selection/Viking/Viking_Name.text = entity.vikingName
				$Selection/Viking/Viking_Sprites.setup(entity.get_customisations())
				

func goto_menu():
	Scene_Manager.load_scene("Menu")

func pass_turn():
	emit_signal("pass_turn")
