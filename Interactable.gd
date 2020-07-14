extends Area2D

class_name Interactable

export var bubble_position = Vector2( 0, 0 )

var letter = "Interactable"
const bubble_scene = preload("res://Bubble.tscn")
var bubble = bubble_scene.instance()
var touching = false

func _init():
	var _body_entered = connect("body_entered", self, "_on_Interactable_body_entered")
	var _body_exited = connect("body_exited", self, "_on_Interactable_body_exited")


func _ready():
	add_child(bubble)
	bubble.position = bubble_position


func _process(_delta):
	if self.touching:
		bubble.show()
	else:
		bubble.hide()


func _on_Interactable_body_entered(body):
	if (body.get_name() == "Player"):
		self.touching = true
		body.touching.append(self.name)


func _on_Interactable_body_exited(body):
	if (body.get_name() == "Player"):
		self.touching = false
		body.touching.erase(self.name)


func _on_interact():
	pass
