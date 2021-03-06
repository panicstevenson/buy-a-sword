extends Area2D

class_name Interactable

export var bubble_position = Vector2( 0, 0 )

var letter = "Interactable"
const bubble_scene = preload("res://objects/ui/Bubble.tscn")
var bubble = bubble_scene.instance()
var show_bubble = false

var Player = null

signal interactable_entered(node)
signal interactable_exited(node)


func _init():
	var _body_entered = connect("body_entered", self, "_on_Interactable_body_entered")
	var _body_exited = connect("body_exited", self, "_on_Interactable_body_exited")


func _ready():
	Player = get_tree().get_current_scene().find_node("Player")
	var _interactable_entered = connect("interactable_entered", Player, "_on_Interactable_entered")
	var _interactable_exited = connect("interactable_exited", Player, "_on_Interactable_exited")
	add_child(bubble)
	bubble.position = bubble_position


func _process(_delta):
	if show_bubble and Player.occupied_by == null:
		bubble.show()
	else:
		bubble.hide()


func _on_Interactable_body_entered(body: Node2D):
	if (body == Player):
		emit_signal("interactable_entered", self)


func _on_Interactable_body_exited(body: Node2D):
	if (body == Player):
		emit_signal("interactable_exited", self)


func set_visible(is_visible: bool):
	show_bubble = is_visible


# returns whether the interaction is still going
func interact():
	# do_interaction()
	# TODO: Figure out if an interaction should ever be blocking
	return Player.occupied_by == null
