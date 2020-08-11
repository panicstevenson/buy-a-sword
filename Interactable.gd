extends Area2D

class_name Interactable

export var bubble_position = Vector2( 0, 0 )

var letter = "Interactable"
const bubble_scene = preload("res://Bubble.tscn")
var bubble = bubble_scene.instance()
var show_bubble = false
var player_occupied = false

var Player = null

signal interactable_entered(node)
signal interactable_exited(node)


func _init():
	var _body_entered = connect("body_entered", self, "_on_Interactable_body_entered")
	var _body_exited = connect("body_exited", self, "_on_Interactable_body_exited")


func _ready():
	Player = get_parent().find_node("Player")
	var _player_occupied = Player.connect("PLAYER_OCCUPIED", self, "_set_Player_occupied")
	var _interactable_entered = connect("interactable_entered", Player, "_on_Interactable_entered")
	var _interactable_exited = connect("interactable_exited", Player, "_on_Interactable_exited")
	add_child(bubble)
	bubble.position = bubble_position


func _process(_delta):
	if show_bubble and not player_occupied:
		bubble.show()
	else:
		bubble.hide()


func _on_Interactable_body_entered(body: Node2D):
	if (body == Player):
		emit_signal("interactable_entered", self)


func _on_Interactable_body_exited(body: Node2D):
	if (body == Player):
		emit_signal("interactable_exited", self)


func _set_Player_occupied(is_occupied: bool):
	player_occupied = is_occupied
	if player_occupied:
		print("player is occupied " + self.name)


func set_visible(is_visible: bool):
	show_bubble = is_visible


# returns whether the interaction is still going
func interact():
	# do_interaction()
	# TODO: Figure out if an interaction should ever be blocking
	return not player_occupied
