extends Interactable

class_name Dialogueable

var talk_count = 0
var do_action
var cellophanery = 1

func interact():
	dialogue()


func dialogue():
	var text = ""
	talk_count += 1
	if talk_count % 2:
		text = "I know there's nowhere to hide"
		do_action = false
	else:
		text = "I'm cellophaneeeeeeeeeeeeeeeeeeee"
		do_action = true
	dialogue_ui.showText(text)
	do_action(do_action)

func do_action(do_action):
	cellophanery = cellophanery * 0.75
	if do_action:
		$SpriteFlip.modulate = Color(1, 1, 1, cellophanery)
