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
	var text = ""
	talk_count += 1
	if talk_count % 2:
		text = "I know there's nowhere to hide"
		do_action = false
	else:
		text = "I'm cellophaneeeeeeeeeeeeeeeeeeee"
		do_action = true
	do_action(do_action)
	# TODO fix, move the code over from Interact Table
	return dialog_player.play_dialog(dialogue_tree)

func do_action(do_action):
	cellophanery = cellophanery * 0.75
	if do_action:
		$SpriteFlip.modulate = Color(1, 1, 1, cellophanery)
