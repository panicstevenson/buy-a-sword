extends Interactable


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Interactable_body_entered(body):
	if (body.get_name() == "Player"):
		body.is_touching = true


func _on_Interactable_body_exited(body):
	if (body.get_name() == "Player"):
		body.is_touching = false


func _on_interact():
	pass
