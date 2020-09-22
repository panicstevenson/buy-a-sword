extends Node

onready var _Body_AnimationPlayer = self.find_node("Body_AnimationPlayer")
onready var _Body_LBL = self.find_node("Body_Label")
onready var _Dialog_Box = self.find_node("Dialog_Box")
onready var _Speaker_LBL = self.find_node("Speaker_Label")
onready var _SpaceBar_Icon = self.find_node("SpaceBar_NinePatchRect")

var _did = 0
var _nid = 0
var _next_slot = 0
var _final_nid = 0
var _Story_Reader
var _Game_State_Controller

# Virtual Methods

func _ready():
	var Story_Reader_Class = load("res://addons/EXP-System-Dialog/Reference_StoryReader/EXP_StoryReader.gd")
	_Story_Reader = Story_Reader_Class.new()
	
	var story = load("res://stories/SimpleStory_Baked.tres")
	_Story_Reader.read(story)
	
	_Game_State_Controller = get_node("/root/GameStateController")

	_Dialog_Box.visible = false
	_SpaceBar_Icon.visible = false
	
	# play_dialog("Plains/Battle/Slime")

# Callback Methods

func _on_Body_AnimationPlayer_animation_finished(anim_name):
	_SpaceBar_Icon.visible = true

#happens when you press space, returns true if still occupied
func trigger_next_dialogue():
	if _is_waiting():
		_SpaceBar_Icon.visible = false
		_get_next_node()
		if _is_playing():
			_play_node()
			return true
		else:
			return false #finished
	else:
		# do nothing
		return true # TODO press interact to speed up text

# Public Methods

func play_dialog(record_name : String):
	_did = _Story_Reader.get_did_via_record_name(record_name)
	_nid = self._Story_Reader.get_nid_via_exact_text(_did, "<start>")
	_final_nid = _Story_Reader.get_nid_via_exact_text(_did, "<end>")
	_get_next_node()
	_play_node()
	_Dialog_Box.visible = true

# Private Methods

func _is_playing():
	return _Dialog_Box.visible


func _is_waiting():
	return _SpaceBar_Icon.visible


func _get_next_node():
	_nid = _Story_Reader.get_nid_from_slot(_did, _nid, _next_slot)
	
	if _nid == _final_nid:
		_Dialog_Box.visible = false


func _get_tagged_text(tag : String, text : String):
	var tagged_regex = RegEx.new()
	tagged_regex.compile("<" + tag + ">(.*)<\/" + tag + ">")
	var results = []
	for content in tagged_regex.search_all(text):
		results.append(content.strings[1])
	return results


func _parse_conditionals(conditionals : Array):
	for conditional in conditionals:
		var text_split = conditional.split("=>")
		if len(text_split) < 2:
			# TODO: Make it an error?
			print("Error: Need a => character in conditional " + conditional)
			return
		var conditions = text_split[0].strip_edges()
		var destination = text_split[1].strip_edges()
		var condition_regex = RegEx.new()
		condition_regex.compile("(?P<operand1>\\w+)\\s*(?P<comparator>[<>!=]=)\\s*(?P<operand2>\\w+)\\s*(?P<logic_gate>and|or)?\\s*")
		for condition in condition_regex.search_all(conditions):
			if _parse_conditional(condition.strings[condition.names["operand1"]], condition.strings[condition.names["comparator"]], condition.strings[condition.names["operand2"]]):
				return int(destination)
	return -1


func _parse_conditional(operand1 : String, comparator : String, operand2 : String):
	# TODO: Fix this!!
	# We need to initialize things and/or also compare against capital F false?
	# Just, do better... In general.
	var operand1_val = str(_Game_State_Controller.get(operand1, false)).to_lower()
	print(operand1_val)
	if comparator == "==":
		return operand1_val == operand2
	elif comparator == "!=":
		return operand1_val != operand2
	elif comparator == ">=":
		return int(operand1_val) >= int(operand2)
	elif comparator == "<=":
		return int(operand1_val) <= int(operand2)
	else:
		# TODO: Make it an error?
		print("Error: Invalid comparator found within conditional!")
	return false


func _play_node():
	var text = _Story_Reader.get_text(_did, _nid)
	var speaker = _get_tagged_text("speaker", text)[0]
	var dialog = _get_tagged_text("dialog", text)[0]
	var variables = _get_tagged_text("var", text)
	var variable_map = _unpack_variables(variables)
	_Game_State_Controller.update_variables(variable_map)
	
	# TODO LOTS LEFT TO DO HERE - this is j ust for texting
	if "<if>" in text:
		var conditionals = _get_tagged_text("if", text)
		_next_slot = _parse_conditionals(conditionals)
		if _next_slot == -1:
			_next_slot = int(_get_tagged_text("else", text)[0].strip_edges())
	else:
		_next_slot = 0

	_Speaker_LBL.text = speaker
	_Body_LBL.text = dialog
	_Body_AnimationPlayer.play("TextDisplay")

func _unpack_variables(variables):
	var variable_map = {}
	for variable in variables:
		if not variable:
			continue
		var variable_regex = RegEx.new()
		variable_regex.compile("(?P<var_name>\\w+)\\s*(?P<operator>[+-]?=)\\s*(?P<var_value>\\w+)")
		var result = variable_regex.search(variable)
		var var_name = result.get_string("var_name").strip_edges()
		var operator = result.get_string("operator").strip_edges()
		var var_value = result.get_string("var_value").strip_edges()
		# TODO: Parse the value's type (Number, String, Boolean)
		if operator == "=":
			variable_map[var_name] = var_value
		else:
			var existing_value = int(_Game_State_Controller.get(var_name, 0))
			if operator == "+=":
				variable_map[var_name] = existing_value + int(var_value)
			elif operator == "-=":
				variable_map[var_name] = existing_value - int(var_value)
			else:
				# TODO: Make it an error?
				print("Error: Invalid operator found within variable!")
	return variable_map
