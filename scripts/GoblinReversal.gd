extends Area2D

func _init():
	var _body_entered = connect("body_entered", self, "_on_GoblinReversal_body_entered")

func _on_GoblinReversal_body_entered(body: Node2D):
	if body.name == "Goblin":
		body.flipped *= -1
