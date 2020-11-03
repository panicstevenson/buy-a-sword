extends Node2D

var alpha = 1.0
var targetAlpha = 1.0
const FADE_SPEED = 2

export(NodePath) var exteriorNodePath
var exteriorNode = null

# Called when the node enters the scene tree for the first time.
func _ready():
	exteriorNode = get_node(exteriorNodePath)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if alpha < targetAlpha:
		alpha = min(alpha + delta * FADE_SPEED, targetAlpha)
	elif alpha > targetAlpha:
		alpha = max(alpha - delta * FADE_SPEED, targetAlpha)
	exteriorNode.modulate = Color(1, 1, 1, alpha)
	

# attach this to a detect player in inspector
func _on_DetectPlayer_body_entered(body):
	print(str('HOUSE Body entered: ', body.get_name()))
	if body.get_name() == "Player":
		targetAlpha = 0.0 # turn invis

# attach this to a detect player in inspector
func _on_DetectPlayer_body_exited(body):
	print(str('HOUSE Body exited: ', body.get_name()))
	if body.get_name() == "Player":
		targetAlpha = 1.0 # turn opaque
