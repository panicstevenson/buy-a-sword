extends Sprite

var _Game_State_Controller = null

func _ready():
	_Game_State_Controller = get_node("/root/GameStateController")


func _process(delta):
	if _Game_State_Controller.get("bought") == "1":
		visible = false
	self.rotation += delta
