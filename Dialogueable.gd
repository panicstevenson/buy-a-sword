extends Interactable

class_name Dialogueable

var first_talk = true

func interact():
	dialogue()


func dialogue():
	var text = "Excuse me, but I am busy doing my daily routine of 10,000 squats."
	if first_talk:
		first_talk = false
	else:
		text = "Please go away....................."
	dialogue_ui.showText(text)
