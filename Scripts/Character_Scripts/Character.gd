extends Node2D
class_name Character
const type = Globals.ENTITY_TYPE.CHARACTER

signal done_moving()

enum CHARACTER_STATE {
	MOVING,
	IDLE
}

export(String, "Ragna", "Thorbrand", "Arnor", "Vali", "Surtr Demon") var characterName
export(bool) var isPlayerOwned = false
var currentState = CHARACTER_STATE.IDLE
var currentCamera

func _ready():
	hide_character_info()
	currentCamera = Globals.get("camera")
	if characterName != "":
		setup(characterName, isPlayerOwned)

func setup(nameIn, playerOwned):
	characterName = nameIn
	isPlayerOwned = playerOwned
	$Character_Sprite.modulate = Color(Character_Manager.characterData[characterName]["Color"])
	$Character_Info/Character_Stats/Name.text = characterName
	$Character_Info/Character_Stats/Heatlh.max_value = Character_Manager.characterData[characterName]["Life"]
	$Character_Info/Character_Stats/Heatlh.value = Character_Manager.characterData[characterName]["Life"]
	$Character_Info/Icon.texture = Character_Manager.characterData[characterName]["Portrait"]

#Movement ====================================================================================
var movementPoints:PoolVector2Array = []

func move_character(points:PoolVector2Array):
	if currentState == CHARACTER_STATE.IDLE:
		currentState = CHARACTER_STATE.MOVING
		movementPoints = points
		move_to_next_point()

func move_to_next_point():
	$Movement_Tween.interpolate_property(self, "position", position, movementPoints[0], 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Movement_Tween.start()
	movementPoints.remove(0)

func _on_Movement_Tween_tween_completed(object, key):
	if movementPoints.size() > 0:
		move_to_next_point()
	else:
		emit_signal("done_moving")
		currentState = CHARACTER_STATE.IDLE
#Movement ====================================================================================

#Selection ===================================================================================
signal selected()

func _process(delta):
	if currentCamera:
		$Character_Info.rect_scale = currentCamera.zoom
	else:
		currentCamera = Globals.get("camera")

func show_character_info():
	$Character_Info.show()
	set_process(true)

func hide_character_info():
	$Character_Info.hide()
	set_process(false)

#Character selection
func _on_Character_Kinematic_Body_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("game_select"):
		emit_signal("selected", self)
#Selection ===================================================================================


