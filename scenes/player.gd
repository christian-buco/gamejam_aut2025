extends CharacterBody2D

# Speed in pixels per second
@export var speed: float = 200

# Animation and direction tracking
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
var last_direction: Vector2 = Vector2.DOWN  # Default facing direction

# Attack system
var is_attacking: bool = false
var attack_cooldown: float = 0.0
@export var attack_duration: float = 0.6  # Duration of attack animation
@export var attack_cooldown_time: float = 0.3  # Time between attacks

func _ready():
	# Start with idle animation facing down
	play_animation("idle_down")

func _physics_process(delta):
	# Handle attack cooldown
	if attack_cooldown > 0:
		attack_cooldown -= delta
	
	# Handle attack input
	if Input.is_action_just_pressed("ui_accept") and attack_cooldown <= 0 and not is_attacking:
		start_attack()
		return  # Don't process movement during attack
	
	# Handle attack duration
	if is_attacking:
		attack_duration -= delta
		if attack_duration <= 0:
			end_attack()
		return  # Don't process movement during attack
	
	var direction = Vector2.ZERO

	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1

	# Normalize so diagonal movement isn't faster
	if direction != Vector2.ZERO:
		direction = direction.normalized()
		last_direction = direction

	velocity = direction * speed
	move_and_slide()
	
	# Update animations based on movement
	update_animation(direction)

func update_animation(direction: Vector2):
	if direction == Vector2.ZERO:
		# Player is idle, play idle animation in last direction
		play_idle_animation()
	else:
		# Player is moving, play walk animation in current direction
		play_walk_animation(direction)

func play_idle_animation():
	var animation_name = "idle_"
	
	if abs(last_direction.x) > abs(last_direction.y):
		# Horizontal movement is dominant
		if last_direction.x > 0:
			animation_name += "right"
		else:
			animation_name += "left"
	else:
		# Vertical movement is dominant
		if last_direction.y > 0:
			animation_name += "down"
		else:
			animation_name += "up"
	
	play_animation(animation_name)

func play_walk_animation(direction: Vector2):
	var animation_name = "walk_"
	
	if abs(direction.x) > abs(direction.y):
		# Horizontal movement is dominant
		if direction.x > 0:
			animation_name += "right"
		else:
			animation_name += "left"
	else:
		# Vertical movement is dominant
		if direction.y > 0:
			animation_name += "down"
		else:
			animation_name += "up"
	
	play_animation(animation_name)

func play_animation(animation_name: String):
	if animated_sprite.animation != animation_name:
		animated_sprite.play(animation_name)

func start_attack():
	is_attacking = true
	attack_duration = 0.6  # Reset attack duration
	attack_cooldown = attack_cooldown_time
	
	var animation_name = "attack_"
	
	if abs(last_direction.x) > abs(last_direction.y):
		# Horizontal attack
		if last_direction.x > 0:
			animation_name += "right"
		else:
			animation_name += "left"
	else:
		# Vertical attack
		if last_direction.y > 0:
			animation_name += "down"
		else:
			animation_name += "up"
	
	play_animation(animation_name)
	
	# Stop movement during attack
	velocity = Vector2.ZERO

func end_attack():
	is_attacking = false
	# Return to idle animation in the same direction
	play_idle_animation()
