extends Area2D
class_name Interactable

var letter = "Z"

func _ready():
	connect("body_entered", self, "_on_Interactable_body_entered")
	connect("body_exited", self, "_on_Interactable_body_exited")


func _on_Interactable_body_entered(body):
	if (body.get_name() == "Player"):
		body.touching.append(self.name)


func _on_Interactable_body_exited(body):
	if (body.get_name() == "Player"):
		body.touching.erase(self.name)


func _on_interact():
	pass
