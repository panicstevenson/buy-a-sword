extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var floatLetters = 0.0

export(NodePath) var labelPath = null
var label = null

export(NodePath) var rectPath = null
var rect = null

var currentText = ""
var showing = false

# Called when the node enters the scene tree for the first time.
func _ready():
	label = get_node(labelPath)
	rect = get_node(rectPath)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rect.visible = showing
	if showing:
		floatLetters += delta * 10
		label.visible_characters = floor(floatLetters)
		if Input.is_action_just_pressed("key_action"):
			if floatLetters < currentText.length():
				# skip to end
				floatLetters = currentText.length()
			else:
				showing = false
	else:
		# TODO REMOVE
		if Input.is_action_just_pressed("key_action"):
			var tempStr = "hey "
			var randInt = randi() % 10
			for i in range(0, randInt):
				tempStr += "hey "
			tempStr += "how u doin?"
			showText(tempStr)


func showText(text):
	floatLetters = 0
	label.text = text
	currentText = text
	showing = true
