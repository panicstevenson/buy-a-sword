extends Area2D
class_name Interactable

var letter = "Interactable"


func _ready():
	var _body_entered = connect("body_entered", self, "_on_Interactable_body_entered")
	var _body_exited = connect("body_exited", self, "_on_Interactable_body_exited")


func _on_Interactable_body_entered(body):
	$Interactable/Bubble.visible = true
	if (body.get_name() == "Player"):
		body.touching.append(self.name)


func _on_Interactable_body_exited(body):
	$Interactable/Bubble.visible = false
	if (body.get_name() == "Player"):
		body.touching.erase(self.name)


func _on_interact():
	pass
