extends Interactable

class_name Dialogueable

var talk_count = 0
var do_action
var cellophanery = 1

# TODO move dialog_player in here
# TODO create the actual dialogue nodes for this guy
export var dialogue_tree = "Plains/Battle/Slime"

func interact():
	return dialogue()


func dialogue():
	if dialog_player._is_playing():
		# TODO this is kinda a bug but itll work atm
		return dialog_player.trigger_next_dialogue()
	else:
		dialog_player.play_dialog(dialogue_tree)
		return true

