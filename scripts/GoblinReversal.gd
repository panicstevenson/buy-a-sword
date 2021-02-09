extends Area2D

func _init():
	var _body_entered = connect("body_entered", self, "_on_GoblinReversal_body_entered")

func _on_GoblinReversal_body_entered(body: Node2D):
	# if body.name.starts_with("Goblin"):
	if body.name.similarity("Goblin") > 0.6:
		body.flipped *= -1
