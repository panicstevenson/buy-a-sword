extends Control
class_name SwordMapUI

var _Game_State_Controller = null

export(NodePath) var smallSwordNodePath = null
var smallSwordNode = null
export(NodePath) var bigSwordNodePath = null
var bigSwordNode = null


# Called when the node enters the scene tree for the first time.
func _ready():
	_Game_State_Controller = get_node("/root/GameStateController")
	visible = false;
	smallSwordNode = get_node(smallSwordNodePath)
	bigSwordNode = get_node(bigSwordNodePath)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if _Game_State_Controller.get("bought") == "1":
		visible = true
		if Input.is_action_just_released("ui_focus_next"):
			smallSwordNode.visible = !smallSwordNode.visible
			bigSwordNode.visible = !bigSwordNode.visible
