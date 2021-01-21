extends Dialogueable

class_name SceneTransition

var _Game_State_Controller

export(String, FILE) var nextScenePath = null

# story var must equal "true" to unlock
export(String) var storyVarToUnlock = null

# Called when the node enters the scene tree for the first time.
func _ready():
	_Game_State_Controller = get_node("/root/GameStateController")
	
	
func _process(delta):
	if Input.is_action_just_pressed("ui_page_up"):
		get_tree().change_scene(nextScenePath)

func _on_Interactable_body_entered(body: Node2D):
	if (body == Player):
		emit_signal("interactable_entered", self)
		#check if the variable is not zero
		var storyVarVal = _Game_State_Controller.get(storyVarToUnlock, "false")
		if storyVarVal == "true":
			get_tree().change_scene(nextScenePath)
		else:
			Player._set_occupied_by(self)
			self.interact()

func _on_Interactable_body_exited(body: Node2D):
	if (body == Player):
		emit_signal("interactable_exited", self)

#func _on_Area2D_body_exited(body: Node2D):
#	if (body == Player):
#		if dialog_player._is_playing():
#			# make sure this can't happen while talking to something else
#			dialog_player.stop_dialog()
