extends Node

onready var _Body_AnimationPlayer = self.find_node("Body_AnimationPlayer")
onready var _Body_LBL = self.find_node("Body_Label")
onready var _Dialog_Box = self.find_node("Dialog_Box")
onready var _Speaker_LBL = self.find_node("Speaker_Label")
onready var _SpaceBar_Icon = self.find_node("SpaceBar_NinePatchRect")

var _did = 0
var _nid = 0
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
	_nid = _Story_Reader.get_nid_from_slot(_did, _nid, 0)
	
	if _nid == _final_nid:
		_Dialog_Box.visible = false


func _get_tagged_text(tag : String, text : String):
	# TODO return multiple results if found
	var start_tag = "<" + tag + ">"
	var end_tag = "</" + tag + ">"
	var start_index = text.find(start_tag) + start_tag.length()
	var end_index = text.find(end_tag)
	var substr_length = end_index - start_index
	return text.substr(start_index, substr_length)
	
func _parse_conditionals(text : String):
	var text_split = text.split("=>")
	if len(text_split) < 2:
		print("Need a => character in conditional " + text)
		return
	var conditions = text_split[0].strip_edges()
	var destination = text_split[1].strip_edges()
	
	var condition_regex = RegEx.new()
	condition_regex.compile("(?P<operand1>\\w+)\\s*(?P<operator>[<>!=]=)\\s*(?P<operand2>\\w+)\\s*(?P<logic_gate>and|or)?\\s*")
	for condition in condition_regex.search_all(conditions):
		for key in condition.names:
			print(key + ": " + str(condition.names[key]))
			print("match: " + condition.strings[condition.names[key]])
	var indexInText = 0
	# TODO how does branching work? what is the format of the returned thing? should it just check the vars here?
	


func _play_node():
	var text = _Story_Reader.get_text(_did, _nid)
	var speaker = _get_tagged_text("speaker", text)
	var dialog = _get_tagged_text("dialog", text)
	var variables = [_get_tagged_text("var", text)]
	var variable_map = _unpack_variables(variables)
	_Game_State_Controller.update_variables(variable_map)
	
	# TODO LOTS LEFT TO DO HERE - this is j ust for texting
	if "<if>" in text:
		var conditional = _get_tagged_text("if", text)
		_parse_conditionals(conditional)

	_Speaker_LBL.text = speaker
	_Body_LBL.text = dialog
	_Body_AnimationPlayer.play("TextDisplay")

func _unpack_variables(variables):
	var variable_map = {}
	for variable in variables:
		if not variable:
			continue
		var var_name = variable.split("=")[0].strip_edges()
		var var_value = variable.split("=")[1].strip_edges()
		# TODO: Parse the value's type (Number, String, Boolean, Counter)
		variable_map[var_name] = var_value
	return variable_map
