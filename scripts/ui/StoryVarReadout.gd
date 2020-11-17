extends MarginContainer

var _Game_State_Controller = null

export(bool) var show_if_zero = true

export(NodePath) var label_node_path = null
var label_node = null

export var story_var = ""
onready var tween = $Tween

func _ready():
	_Game_State_Controller = get_node("/root/GameStateController")
	_Game_State_Controller.connect("variables_updated", self, "story_vars_updated")

	var value = _Game_State_Controller.get(story_var)
	if not value:
		value = 0

	label_node = get_node(label_node_path)
	set_label_text(value)

	# update the label text here?
	# health_number_label.text = str(player_health)

func story_vars_updated(assignments):
	if story_var in assignments.keys():
		set_label_text(assignments.get(story_var))

func set_label_text(value):
	if not show_if_zero:
		if not value:
			self.hide()
		else:
			self.show()
	label_node.text = str(value)
