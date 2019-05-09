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

var characterStats = {
	"Max_Ap": 2,
	"AP": 2,
	"Movement_Max": 4,
	"Max_Life": 0,
	"Life": 0
}

func _ready():
	hide_character_info()
	if characterName != "":
		setup(characterName, isPlayerOwned)

func setup(nameIn, playerOwned):
	characterName = nameIn
	isPlayerOwned = playerOwned
	characterStats["Max_Life"] = Character_Manager.characterData[characterName]["Life"]
	characterStats["Life"] = Character_Manager.characterData[characterName]["Life"]
	$Character_Sprite.modulate = Color(Character_Manager.characterData[characterName]["Color"])
	$Character_Info/Character_Stats/Name.text = characterName
	$Character_Info/Character_Stats/Heatlh.max_value = characterStats["Life"]
	$Character_Info/Character_Stats/Heatlh.value = characterStats["Life"]
	$Character_Info/Icon.texture = Character_Manager.characterData[characterName]["Portrait"]
	$Character_Info/AP.text = String(characterStats["AP"])

#Movement ====================================================================================
var movementPoints:PoolVector2Array = []

#Starts moving the character
func move_character(points:PoolVector2Array):
	characterStats["AP"] -= 1
	$Character_Info/AP.text = String(characterStats["AP"])
	if currentState == CHARACTER_STATE.IDLE:
		currentState = CHARACTER_STATE.MOVING
		movementPoints = points
		move_to_next_point()

#Tween movement to the next point
func move_to_next_point():
	$Movement_Tween.interpolate_property(self, "position", position, movementPoints[0], 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Movement_Tween.start()
	movementPoints.remove(0)

#Loops until no more points to move to
func _on_Movement_Tween_tween_completed(object, key):
	if movementPoints.size() > 0:
		move_to_next_point()
	else:
		emit_signal("done_moving")
		currentState = CHARACTER_STATE.IDLE

#Reset character AP
func refresh():
	characterStats["AP"] = characterStats["Max_Ap"]
	$Character_Info/AP.text = String(characterStats["AP"])
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

#Damage ======================================================================================
func take_damage(damage):
	characterStats["Life"] -= damage
	$Character_Info/Character_Stats/Heatlh.value = characterStats["Life"]
	if characterStats["Life"] <= 0:
		pass 
		#DIE

func heal(heal):
	characterStats["Life"] += heal
	if characterStats["Life"] > characterStats["Max_Life"]:
		characterStats["Life"] = characterStats["Max_Life"]
	$Character_Info/Character_Stats/Heatlh.value = characterStats["Life"]
#Damage ======================================================================================
