extends Control
class_name SwordMapUI

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(NodePath) var smallSwordNodePath = null
var smallSwordNode = null
export(NodePath) var bigSwordNodePath = null
var bigSwordNode = null


# Called when the node enters the scene tree for the first time.
func _ready():
	smallSwordNode = get_node(smallSwordNodePath)
	bigSwordNode = get_node(bigSwordNodePath)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_released("ui_focus_next"):
		smallSwordNode.visible = !smallSwordNode.visible
		bigSwordNode.visible = !bigSwordNode.visible
