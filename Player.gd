extends KinematicBody2D

var _Game_State_Controller

export var speed = 400  # How fast the player will move (pixels/sec).
export var jump = -700
export var gravity = 2500
var screen_size  # Size of the game window.

var touching = null
var occupied_by = null

var jumping = false
var velocity = Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	_Game_State_Controller = get_node("/root/GameStateController")


func _on_Interactable_entered(interactable: Interactable):
	print("entered: " + interactable.name)
	touching = interactable


func _on_Interactable_exited(interactable: Interactable):
	print("exited: " + interactable.name)
	interactable.set_visible(false)
	touching = null


func _on_pickup(pickup: Pickup):
	print("picked up: " + pickup.name)
	var current = _Game_State_Controller.get(pickup.story_variable, 0)
	current += pickup.value
	_Game_State_Controller.update_variable(pickup.story_variable, current)
	$PickupSound.play() # TODO: Move to global soundboi


func _process(_delta):
	if touching == null:
		return
	touching.set_visible(true)


func get_input():
	velocity.x = 0
	jumping = false
	if Input.is_action_pressed("ui_right"):
		if occupied_by == null:
			velocity.x += speed
	if Input.is_action_pressed("ui_left"):
		if occupied_by == null:
			velocity.x -= speed
	if Input.is_action_just_pressed("ui_up"):
		if occupied_by != null:
			if not occupied_by.interact():
				_set_occupied_by(null)
		elif touching != null:
			_set_occupied_by(touching)
			occupied_by.interact()
		else:
			pass


func _physics_process(delta):
	get_input()
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)

	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.name == "HazardTileMap":
			_Game_State_Controller.change_health(-20)
			# TODO: Create reset function
			position = Vector2(100, 250)

	if Input.is_action_just_pressed('ui_select'):
		if is_on_floor() and occupied_by == null:
			velocity.y = jump

	if velocity.x != 0:
		$SpriteFlip/AnimatedSprite.animation = "walk"
		$SpriteFlip/AnimatedSprite.play()
		if velocity.x < 0:
			$SpriteFlip.scale.x = -1
		else:
			$SpriteFlip.scale.x = 1
	else:
		$SpriteFlip/AnimatedSprite.stop()


func _set_occupied_by(occupier):
	occupied_by = occupier
