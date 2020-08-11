extends Interactable

class_name Dialogueable

var dialog_player = null

# TODO move dialog_player in here
# TODO create the actual dialogue nodes for this guy
export var dialogue_tree = "Plains/Battle/Slime"

func _ready():
	dialog_player = get_node("/root/Dialog_Player")


func interact():
	return dialogue()


func dialogue():
	if dialog_player._is_playing():
		# TODO this is kinda a bug but itll work atm
		return dialog_player.trigger_next_dialogue()
	else:
		dialog_player.play_dialog(dialogue_tree)
		return true

