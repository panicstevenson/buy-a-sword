extends Floatable

var _Game_State_Controller = null
var _Dialog_Player = null
export(String, FILE) var swordImageFile = null
var bufferEventDialogue = false


func _ready():
	_Game_State_Controller = get_node("/root/GameStateController")
	_Dialog_Player = get_node("/root/Dialog_Player")
	var swordboy = Sword1Trigger.new()
	add_child(swordboy)
	_Game_State_Controller.add_watcher("sword1Dialogue", swordboy)
	var swordImage = load(swordImageFile)
	$Sprite.set_texture(swordImage)


func _process(delta):
	if _Game_State_Controller.get("bought") == "true":
		visible = false
		if not bufferEventDialogue:
			_Game_State_Controller.update_variable("sword1Dialogue", "true")
			bufferEventDialogue = true
