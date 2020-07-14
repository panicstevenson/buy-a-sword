extends Area2D
class_name Interactable

var letter = "Interactable"
var bubbleScene = load("res://Bubble.tscn")
var bubble = null

var firstFrameCalled = false

func _ready():
	bubble = bubbleScene.instance()
	add_child(bubble)
	var _body_entered = connect("body_entered", self, "_on_Interactable_body_entered")
	var _body_exited = connect("body_exited", self, "_on_Interactable_body_exited")

func _process(delta):
	if !firstFrameCalled:
		firstFrameCalled = true
		firstFrame()

func firstFrame():
	bubble.visible = false

func _on_Interactable_body_entered(body):
	bubble.visible = true
	if (body.get_name() == "Player"):
		body.touching.append(self.name)


func _on_Interactable_body_exited(body):
	bubble.visible = false
	if (body.get_name() == "Player"):
		body.touching.erase(self.name)


func _on_interact():
	pass
