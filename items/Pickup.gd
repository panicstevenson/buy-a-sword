extends Area2D

class_name Pickup

export var story_variable = ""
export var value = 1

var Player = null

func _init():
	var _body_entered = connect("body_entered", self, "_on_Pickup_body_entered")


func _ready():
	Player = get_parent().find_node("Player")
	

func _on_Pickup_body_entered(body: Node2D):
	if (body == Player):
		Player._on_pickup(self)
		get_parent().remove_child(self)
