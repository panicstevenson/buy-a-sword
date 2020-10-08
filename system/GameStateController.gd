extends Node2D


var VARIABLES = {}

var HEALTH = "health"
var MAX_HEALTH = 100

signal variables_updated(assignments)


func _ready():
	print("Life begins. :(")
	VARIABLES["talked"] = "0"
	VARIABLES[HEALTH] = MAX_HEALTH
	pass

func update_variable(story_var, value):
	update_variables({story_var: value})

func update_variables(assignments):
	for key in assignments.keys():
		# TODO: Check the value's type (Number, String, Boolean, Counter)
		VARIABLES[key] = assignments[key]
	emit_signal("variables_updated", assignments)

func get(key : String, default_value = null):
	return VARIABLES.get(key, default_value)

# Health Functions
# TODO: Move to a health controller in the future?
func get_health():
	return int(VARIABLES.get(HEALTH))

func set_health(health):
	if health <= 0:
		update_variable(HEALTH, 0)
		print("Game Over.")
		get_tree().quit()
	elif health > MAX_HEALTH:
		update_variable(HEALTH, MAX_HEALTH)
	else:
		update_variable(HEALTH, health)

func change_health(health):
	var new_health = get_health() + health
	set_health(new_health)
