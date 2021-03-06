extends KinematicBody2D

var _Game_State_Controller

export var accel = 1000 # sideways acceleration pixels/sec2
export var friction = 300 # pixels/s2
export var speed = 400  # How fast the player will move (pixels/sec).
export var jump = -875
export var gravity = 2500
var start_position = Vector2.ZERO
var screen_size  # Size of the game window.

var touching = null
var hurt_counter = 0
var occupied_by = null

var jumping = false
var velocity = Vector2.ZERO
var knockback_velocity = Vector2.ZERO

# short timer that starts when you fall off a ledge so you can still jump
onready var coyote_timer = $Timer
var was_on_floor = false

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	_Game_State_Controller = get_node("/root/GameStateController")
	start_position = position


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


func _process(delta):
	if touching != null:
		touching.set_visible(true)
	if hurt_counter > 0:
		$SpriteFlip/AnimatedSprite.modulate = Color(1, 1, 1, min(fmod((hurt_counter * 7.0), 1.0), 0.5))
		hurt_counter -= delta
	else:
		$SpriteFlip/AnimatedSprite.modulate = Color(1, 1, 1)


func get_input(delta):
	if Input.is_action_pressed("ui_right"):
		if occupied_by == null:
			velocity.x += accel * delta
	if Input.is_action_pressed("ui_left"):
		if occupied_by == null:
			velocity.x -= accel * delta
	# decelerate in the opposite direction of velocity. Do not subtract more than velocity
	var slowdown = friction * delta
	if abs(velocity.x) > slowdown:
		velocity.x -= sign(velocity.x) * slowdown
	else:
		velocity.x = 0
		
	velocity.x = clamp(velocity.x, -speed, speed)
	
	if Input.is_action_just_pressed("ui_up"):
		if occupied_by != null:
			# if currently occupied, keep interacting with that object
			if not occupied_by.interact():
				_set_occupied_by(null)
		elif touching != null:
			# if not occupied, try interacting with the object I am touching
			if touching.interact():
				_set_occupied_by(touching)
		else:
			pass


func _physics_process(delta):
	get_input(delta)
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)

	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.name == "HazardTileMap":
			get_hurt(20)
			# TODO: Create reset function
			position = start_position

	# jump with a coyote timer
	if is_on_floor():
		jumping = false
		
	if Input.is_action_just_pressed('ui_select'):
		if (is_on_floor() or !coyote_timer.is_stopped()) and occupied_by == null:
			velocity.y = jump
			jumping = true
			
	if !is_on_floor() and was_on_floor and !jumping:
		coyote_timer.start()
	was_on_floor = is_on_floor()

	if velocity.x != 0:
		$SpriteFlip/AnimatedSprite.animation = "walk"
		$SpriteFlip/AnimatedSprite.play()
		if velocity.x < 0:
			$SpriteFlip.scale.x = -1
		else:
			$SpriteFlip.scale.x = 1
	else:
		$SpriteFlip/AnimatedSprite.stop()
		

func is_iframe():
	return hurt_counter > 0

func get_hurt(damage):
	_Game_State_Controller.change_health(-damage)
	hurt_counter = 1.5


func _set_occupied_by(occupier):
	occupied_by = occupier
