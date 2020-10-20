extends Node2D

class_name SceneTransition

export(NodePath) var detectAreaPath = null
var detectArea = null

export(String, FILE) var nextScenePath = null

var Player = null

# Called when the node enters the scene tree for the first time.
func _ready():
	detectArea = get_node(detectAreaPath)
	Player = get_parent().find_node("Player")
	detectArea.connect("body_entered", self, "_on_Area2D_body_entered")
	detectArea.connect("body_exited", self, "_on_Area2D_body_exited")
	
	
func _process(delta):
	if Input.is_action_just_pressed("ui_page_up"):
		get_tree().change_scene(nextScenePath)

func _on_Area2D_body_entered(body: Node2D):
	if (body == Player):
		get_tree().change_scene(nextScenePath)


func _on_Area2D_body_exited(body: Node2D):
	if (body == Player):
		pass # no
