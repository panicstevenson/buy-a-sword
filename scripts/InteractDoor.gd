extends Interactable

class_name InteractDoor

signal interact_door

# TODO move dialog_player in here
# TODO create the actual dialogue nodes for this guy
# export var dialogue_tree = "Plains/Battle/Slime"

func interact():
	return toggleDoor()


func toggleDoor():
	emit_signal("interact_door")
	print("toggle door")
	# do not grab the player's attention
	return false
