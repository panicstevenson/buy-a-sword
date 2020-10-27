extends Floatable

var _Game_State_Controller = null
export(String, FILE) var swordImageFile = null



func _ready():
	_Game_State_Controller = get_node("/root/GameStateController")
	var swordImage = load(swordImageFile)
	$Sprite.set_texture(swordImage)


func _process(delta):
	if _Game_State_Controller.get("bought") == "1":
		visible = false
