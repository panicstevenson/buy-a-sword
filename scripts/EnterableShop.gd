extends Node2D

var inside = false
var alpha = 1.0
var targetAlpha = 1.0
const FADE_SPEED = 2

export(NodePath) var exteriorPath
var exterior = null
export(NodePath) var exteriorCollidersPath
var exteriorColliders = null
export(NodePath) var backCollidersPath
var backColliders = null

# Called when the node enters the scene tree for the first time.
func _ready():
	exterior = get_node(exteriorPath)
	exteriorColliders = get_node(exteriorCollidersPath)
	backColliders = get_node(backCollidersPath)
	$InteractDoor.connect("interact_door", self, "_on_InteractDoor_interact_door")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if alpha < targetAlpha:
		alpha = min(alpha + delta * FADE_SPEED, targetAlpha)
	elif alpha > targetAlpha:
		alpha = max(alpha - delta * FADE_SPEED, targetAlpha)
	exterior.modulate = Color(1, 1, 1, alpha)
		
func _on_InteractDoor_interact_door():
	inside = !inside
	if inside:
		targetAlpha = 0.0
		for node in backColliders.get_children():
			node.set_collision_layer(1)
		for node in exteriorColliders.get_children():
			node.set_collision_layer(0)
			print(node)
	else:
		targetAlpha = 1.0
		for node in backColliders.get_children():
			node.set_collision_layer(0)
		for node in exteriorColliders.get_children():
			node.set_collision_layer(1)
			print(node)
