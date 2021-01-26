extends Node2D


var VARIABLES = {}

var HEALTH = "health"
var MAX_HEALTH = 100

signal variables_updated(assignments)

onready var watchers = {}
onready var watcher_cache = {}

func _ready():
	print("Life begins. :(")
	VARIABLES["bought"] = "0"
	VARIABLES[HEALTH] = MAX_HEALTH
	VARIABLES["sword1Dialogue"] = "false"
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

func _process(delta):
	check_variable_states()

func add_watcher(key: String, trigger: Trigger, defaultValue: String = ""):
	watchers[key] = trigger
	watcher_cache[key] = VARIABLES.get(key, defaultValue)

func check_variable_states():
	if watchers.empty():
		return
	for watcher in watchers.keys():
		if VARIABLES.get(watcher) != watcher_cache.get(watcher):
			watchers.get(watcher).trigger()
			watchers.erase(watcher)
